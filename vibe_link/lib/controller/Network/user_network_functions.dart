import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibe_link/controller/store_to_firebase/user_info/get_user_info.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/model/user_info.dart';
// import 'package:linkify/controller/store_to_firebase/user_info/get_user_info.dart';
// import 'package:linkify/controller/variables/static_store.dart';
// import 'package:linkify/model/user_info.dart';

class NetworkFunction {
  Future<UserInfoMine> fetchUserInfo(var userId) async {
    var db = FirebaseFirestore.instance;
    UserInfoMine users = UserInfoMine();
    // print(userId);
    // return users;
    DocumentSnapshot<Map<String,dynamic>> userData;
    try{
      userData = await db.collection("users").doc(userId).get();
      users.displayName = userData.data()?['name'];
      users.email = userId;
      users.imgUrl = userData.data()?['images'];
      users.topArtists = userData.data()?['topArtists'];
      print("knn users' info fetching");
      // print(users.email);
    }catch(e){
      print("User id doesn't exist in users collection on firebase");
    }
    // print(userData.data()?['images']);
    // print(userData.data()?['name']);
    // print(userData.data()?['topArtists']);
    // print(users.imgUrl);
    // .then((v) async {
    //   // UserInfo k = v.data() as UserInfo;
    //   try{
    //   users.displayName = v.data()?['name'];
    //   // users.displayName = k.displayName;
    //   users.image = v.data()?['images'];
    //   // users.id = v.data()?['id'];
    //   // users.id = k.id;
    //   // print(users.id);
    //   users.topArtists = v.data()?['topArtists'];
    //   // print(v.data());
    //   return users;
    //   }catch(e){
    //     print("User id doesn't exist in users collection on firebase");
    //   }
    // });
    return users;
  }

  Future<List<UserInfoMine>?> fetchRecommendedUsersInfo(numberOfUsers) async {
    List<dynamic>? likeUsersId = []; // In firebase type is dynamic
    List<UserInfoMine>? likeUsersInfo = [];
    StoreUserInfo _storeUserInfo = StoreUserInfo();
    if(StaticStore.currentUserGenreId=="" || StaticStore.currentUserGenreId==null){
      await _storeUserInfo.fetch_store_user_info();
      print("Fetched user info again, because it was null");
      // double checking cause if it is still null so no users are available
      if(StaticStore.currentUserGenreId=="" || StaticStore.currentUserGenreId==null){
        return [];
      }
    }
    
    // UserInfo? currentUser = await _storeUserInfo.fetchCurrentUserInfo();
    // print(currentUser?.spotifyBasedGenre);
    // print(StaticStore.userGenre);

    // return null;
    await FirebaseFirestore.instance
        .collection('spotifyBasedGenreUsers')
        .get()
        .then((value) async {
      likeUsersId = value.docs[0]['genreList'][StaticStore.currentUserGenreId];
      // print(StaticStore.);
      // print(value.docs[0]['genreList'][StaticStore.currentUserGenreId]);
      // return null;



      likeUsersId?.remove(StaticStore.currentUserId);
      if(numberOfUsers<0){
        for (int i = 0; likeUsersId != null && i < likeUsersId!.length; i++) {
          likeUsersInfo.add(await fetchUserInfo(likeUsersId?[i]));
        }
      }else{
        for (int i = 0; likeUsersId != null && i < likeUsersId!.length && i<numberOfUsers; i++) {
          likeUsersInfo.add(await fetchUserInfo(likeUsersId?[i]));
        }
      }
      return likeUsersInfo;
    });

    return likeUsersInfo;
  }

  Future<List<UserInfoMine>?> fetchAllUsersInfo(numberOfUsers) async {
    List<dynamic>? allUsersId = []; // In firebase type is dynamic
    List<UserInfoMine>? allUsersInfo = [];
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) async {
      try{
        for(int i=0;i<value.docs.length;i++){
          allUsersId.add(value.docs[i].id);
          print("fetching all users");
        }
        // print(allUsersId);
        if(allUsersId.length>2){
          allUsersId.remove(StaticStore.currentUserEmail);
        }
        if(numberOfUsers<0){
          for (int i = 0;i < allUsersId.length;i++) {
            allUsersInfo.add(await fetchUserInfo(allUsersId[i]));
          }
        }else{
          for (int i = 0;i < allUsersId.length && i < numberOfUsers;i++) {
            allUsersInfo.add(await fetchUserInfo(allUsersId[i]));
          }
        }
        return allUsersInfo;
      }catch(e){
        print("Error happened while callling for the alluserInfo");
        return allUsersInfo;
      }
    });

    return allUsersInfo;
  }

  Future<int> getNumberOfUsers() async {
    var a = 0;
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) async {
      a = value.docs.length;
    });
    return a;
  }
}
