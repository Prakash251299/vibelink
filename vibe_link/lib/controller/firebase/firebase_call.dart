import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibe_link/controller/Network/recommend_knn.dart';
import 'package:vibe_link/controller/Network/user_network_functions.dart';
import 'package:vibe_link/controller/genre/user_genre.dart';
import 'package:vibe_link/controller/local_storing/read_write.dart';
import 'package:vibe_link/controller/firebase/user_info/get_user_info.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/model/user_info.dart';

class FirebaseCall {
  var db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  /* Fetch current user's genres */
  Future<List<String>> fetchCurrentUserArtists()async{
    DocumentSnapshot<Map<String, dynamic>> t =
    await db.collection("users").doc(user?.email).get();
    List<String>artistIds = t['topGenres'];
    return artistIds;
  }


  Future<void> storeUserWithGenrePercentage()async{
    DateTime now = DateTime.now();
    String date = '${now.day}/${now.month}/${now.year}';
    List<String> a = StaticStore.userGenre;
    print(date);
    print(a);
    
    

    // if(StaticStore.dateStored==date.toString()){

    // }
    for(int i=0;i<a.length&&i<3;i++){
      await db.collection(a[i]).doc(user?.email).set({
      }, SetOptions(merge: true)).onError((e, _) {
        print("Error writing user info in firebase: $e");
      });
    }

  }

  Future<void> getGenrePercentage(genres) async {
    int total = genres.length;
    Map<String, int> m = {};
    for (int i = 0; i < genres.length; i++) {
      if (m[genres[i]] == null) {
        m[genres[i]] = 1;
      } else {
        m[genres[i]] = m[genres[i]]! + 1;
      }
    }

    m.forEach((key,value){
      int a = ((value*100)/total).round();
      if((a - 5*(a~/5))>=3){ // '~/' is used for integer division (output is an integer)
        a = 5*(a~/5)+5;
      }else{
        a = 5*(a~/5);
      }
      m[key] = a;
    });

    Map<dynamic, dynamic> l = await sortMapByValue(m, null);
    // print(l);
    StaticStore.userGenreWithDistributedPercentage = l;
    // StaticStore.userGenreWithCount
    List<String> temp = [];
    for (var k in l.keys) {
      // print(k);
      
      temp.add('$k${l[k]}');
    }
    StaticStore.userGenre = temp;
    print(temp);
  }

  // Future<List<dynamic>> getUserArtists() async {
  Future<void> getUserArtistsWithGenrePercentage() async {
    List<dynamic> allArtists = [];
    DocumentSnapshot<Map<String, dynamic>> t =
        await db.collection("users").doc(user?.email).get();
    allArtists = t['topArtists'];
    // await getArtistsGenres(allArtists);
    String artistIds = allArtists[0];
    for (int i = 1; i < allArtists.length; i++) {
      artistIds += ",${allArtists[i]}";
    }
    List<String> genres = [];
    genres = await getArtistsGenres(artistIds);
    // print(genres);
    await getGenrePercentage(genres);

    // await storeUserWithGenrePercentage();

    return;
  }

  Future<void> storeUserData(artistIds) async {
    // List<dynamic> topArtists = getTopThreeGenres(topGenre);

    await db.collection("users").doc(user?.email).set({
      "name": user?.displayName,
      // "id":_userInfo.id,
      "email": user?.email,
      // "country":user?.,
      "images": user?.photoURL,
      // "age":user?.age,
      // "country":user?.country,
      // "topArtists":artistIds,
      'topArtists': FieldValue.arrayUnion(artistIds),
    }, SetOptions(merge: true)).onError((e, _) {
      print("Error writing user info in firebase: $e");
    });
  }

  List<dynamic> getTopThreeGenres(var topGenre) {
    List<dynamic> topThreeGenre = [];
    if (topGenre.length > 2) {
      topThreeGenre.add(topGenre[0]);
      topThreeGenre.add(topGenre[1]);
      topThreeGenre.add(topGenre[2]);
    }
    if (topGenre.length == 2) {
      topThreeGenre.add(topGenre[0]);
      topThreeGenre.add(topGenre[1]);
    }
    if (topGenre.length == 1) {
      topThreeGenre.add(topGenre[0]);
    }
    topThreeGenre.sort();
    return topThreeGenre;
  }

  /* Write data */
  // Future<void> writeUserData(UserInfoMine _userInfo, var topGenre) async {
  //   var db = FirebaseFirestore.instance;
  //   List<dynamic> topThreeGenres = getTopThreeGenres(topGenre);
  //   await db.collection("users").doc(StaticStore.currentUserId).set({
  //     "name": _userInfo.displayName,
  //     "id": _userInfo.id,
  //     "email": _userInfo.email,
  //     "country": _userInfo.country,
  //     "images": _userInfo.imgUrl,
  //     "spotifyGenre": topThreeGenres,
  //   }).onError((e, _) => print("Error writing user info in firebase: $e"));
  //   return;
  // }

  Future<void> writeSpotifyGenreData(var topGenre) async {
    List<dynamic> topThreeGenres = getTopThreeGenres(topGenre);
    var db = FirebaseFirestore.instance;
    /* For new user */
    if (topThreeGenres.length == 0) {
      print("No genres availabe for the user");
      return;
    }
    String genreId = "";
    for (int i = 0; i < topThreeGenres.length; i++) {
      genreId += "_${topThreeGenres[i]}";
    }
    genreId = genreId.replaceAll(' ', '');

    // After finding current genreId, checking it with the previous one
    if (StaticStore.currentUserGenreId == genreId) {
      return;
    }
    StaticStore.currentUserGenreId = genreId;
    List<dynamic> tempUserList = [];

    await db.collection("spotifyBasedGenreUsers").get().then(
      (value) async {
        // print("CheckState: spotifyBasedGenreUsers get");
        if (value.docs[0]['genreList'][genreId] != null) {
          await db.collection("spotifyBasedGenreUsers").doc("genre").set({
            'genreList': {
              genreId: FieldValue.arrayUnion([StaticStore.currentUserId])
            }
          }, SetOptions(merge: true)).onError((e, _) =>
              print("Error writing spotifyUserGenre info in firebase: $e"));
        } else {
          tempUserList.add(StaticStore.currentUserId);
          await db.collection("spotifyBasedGenreUsers").doc("genre").set({
            'genreList': {genreId: tempUserList}
          }, SetOptions(merge: true)).onError((e, _) =>
              print("Error writing spotifyUserGenre info in firebase: $e"));
        }
      },
    );
  }

  Future<void> storeChats(var mesId, Map<String, Object?> mes) async {
    var db = FirebaseFirestore.instance;
    await db.collection("chats").doc(mesId).set({
      "messageInfo": FieldValue.arrayUnion([mes])
    }, SetOptions(merge: true)).onError(
        (e, _) => print("Error Storing message info in firebase: $e"));
  }
}

Future<String> requestIdGenerator(String otherUser) async {
  print("generating id");
  ReadWrite _readWrite =ReadWrite();
  String currentUserEmail = await _readWrite.getEmail();
  List<String?> s = [currentUserEmail, otherUser];
  s.sort();
  String requestId = "${s[0]}_${s[1]}";
  return requestId;
}

class Friends extends StatefulWidget {
  const Friends({super.key});

  Future<String> friendStatusStore(requestReceiver) async {
    ReadWrite _readWrite = ReadWrite();
    String currentUserEmail = await _readWrite.getEmail();
    var requestId = await requestIdGenerator(requestReceiver);
    var db = FirebaseFirestore.instance;
    try {
      await db.collection("friendStatus").doc(requestId).set(
          {"requestStatus": "${currentUserEmail}"},
          SetOptions(merge: true));
      print("friend status fetcher");

      // StaticStore.requestStatusValue = "1";
      return "1";
      // return 1;
      // .onError((e, _) => print("Error Storing message info in firebase: $e"));
      // .get().then((value) {
      //   print(value.exists);
      // });
    } catch (e) {
      return "0";
    }
  }

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Future<String> getFriendStatus(requestReceiver) async {
  print("fetching requestId");
  var requestId = await requestIdGenerator(requestReceiver);
  print(requestId);
  // return "";
  var db = FirebaseFirestore.instance;
  try {
    var friendStatus = await db.collection("friendStatus").doc(requestId).get();
    if(friendStatus.exists){
      return friendStatus['requestStatus'];
    }
    // var a = await db.collection("friendStatus").doc(requestId).get();
    // return a['requestStatus'];
    return "";
  } catch (e) {
    return "";
  }
}

Future<void> storeFriendRequest(requestReceiverId) async {
  // var requestId = requestIdGenerator(requestReceiver);
  // if(requestReceiverId==StaticStore.currentUserId){
  //   return;
  // }
  ReadWrite _readWrite = ReadWrite();
  String currentUserEmail = await _readWrite.getEmail();
  var db = FirebaseFirestore.instance;
  print("Storing friend request: $requestReceiverId");
  try {
    var a = await db.collection("friendRequest").doc(requestReceiverId).set({
      "users": FieldValue.arrayUnion([currentUserEmail])
    }, SetOptions(merge: true)).onError(
        (e, _) => print("Error Storing message info in firebase: $e"));
    return;
  } catch (e) {
    return;
  }
}

Future<List<dynamic>?> fetchFriendRequests() async {
  StoreUserInfo _storeUserInfo = StoreUserInfo();
  ReadWrite _readWrite = ReadWrite();
  String currentUserEmail = await _readWrite.getEmail();
  // StaticStore.currentUserId == ""
  //     ? await _storeUserInfo.fetchCurrentUserInfo()
  //     : null;
  // if (StaticStore.currentUserId == null ||
  //     StaticStore.currentUserId?.length == 0) {
  //   return [];
  // }
  var db = FirebaseFirestore.instance;
  try {
    var a = await db
        .collection("friendRequest")
        .doc(currentUserEmail)
        .get();
    if (a.exists) {
      return a['users'];
    }
    return null;
  } catch (e) {
    print(
        "fetch friend request error occured from fetchFriendRequests function");
    return null;
  }
}

Future<void> updateRequestStatus(requestStatus, userEmail) async {
  var requestId = await requestIdGenerator(userEmail);
  var db = FirebaseFirestore.instance;
  var a = await db
      .collection("friendStatus")
      .doc(requestId)
      .set({'requestStatus': '$requestStatus'});
}

Future<void> deleteFriendRequest(String userEmail) async {
  print("delete from firebase called");
  ReadWrite _readWrite = ReadWrite();
  String currentUserEmail = await _readWrite.getEmail();
  var db = FirebaseFirestore.instance;
  var a =
      await db.collection("friendRequest").doc(currentUserEmail).get();
  if (a.exists) {
    print(a['users']);
    List<dynamic> friendRequests = a['users'];
    friendRequests.remove(userEmail);
    await db
        .collection("friendRequest")
        .doc(currentUserEmail)
        .set({"users": friendRequests});
    // .delete();
    // .delete({"users":FieldValue.arrayRemove([])},SetOptions(merge: true));
  } else {
    print("user doesn't exist");
  }
}

Future<void> addFriend(userEmail) async {
  var db = FirebaseFirestore.instance;
  ReadWrite _readWrite = ReadWrite();
  String currentUserEmail = await _readWrite.getEmail();
  await db.collection("friends").doc(currentUserEmail).set({
    "users": FieldValue.arrayUnion([userEmail])
  }, SetOptions(merge: true));
  await db.collection("friends").doc(userEmail).set({
    "users": FieldValue.arrayUnion([currentUserEmail])
  }, SetOptions(merge: true));
}

Future<List<UserInfoMine>> fetchFriends() async {
  List<UserInfoMine>? friends = [];
  List<dynamic> friendIds = [];
  NetworkFunction _networkFunction = NetworkFunction();
  var db = FirebaseFirestore.instance;
  ReadWrite _readWrite = ReadWrite();
  String currentUserEmail = await _readWrite.getEmail();
  var a = await db.collection("friends").doc(currentUserEmail).get();
  if (a.exists) {
    friendIds = a['users'];
    // List<UserInfo> friends = [];
    UserInfoMine temp;
    for (int i = 0; i < friendIds.length; i++) {
      temp = await _networkFunction.fetchUserInfo(friendIds[i]);
      friends.add(temp);
    }

    // print("friends");
    print(friends);
    return friends;
  }
  return [];
}
