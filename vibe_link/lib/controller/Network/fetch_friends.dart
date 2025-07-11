import 'package:flutter/material.dart';
import 'package:vibe_link/controller/Network/recommend_knn.dart';
import 'package:vibe_link/controller/Network/user_network_functions.dart';
import 'package:vibe_link/controller/firebase/firebase_call.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/model/user_info.dart';
// import 'package:linkify/controller/Network/recommend_knn.dart';
// import 'package:linkify/controller/Network/user_network_functions.dart';
// import 'package:linkify/controller/store_to_firebase/firebase_call.dart';
// import 'package:linkify/controller/variables/static_store.dart';
// import 'package:linkify/model/user_info.dart';
// import 'package:linkify/view/Network/suggestions/friend_suggestion.dart';
// import 'package:linkify/view/Network/user_network.dart';

Future<List<UserInfoMine>> fetchAllFriends(int numberOfUsers) async {
  NetworkFunction _networkFunction = NetworkFunction();
  List<UserInfoMine>? allUsers = await _networkFunction.fetchAllUsersInfo(numberOfUsers);
  if(allUsers==null){
    return [];
  }
  return allUsers;
}

Future<List<UserInfoMine>> fetchBestMatchFriends(int numberOfUsers) async {
  NetworkFunction _networkFunction = NetworkFunction();
  try{
    List<UserInfoMine>? bestMatch =
        await _networkFunction.fetchRecommendedUsersInfo(numberOfUsers);
        if(bestMatch==null){
          return [];
        }
    return bestMatch;
  }catch(e){
    print("error happened at finding bestmatch (the api does not provide genre of a song so it is happenning)");
    return [];
  }
}

Future<List<UserInfoMine>> fetchGoodMatchFriends(int numberOfUsers) async {
  NetworkFunction _networkFunction = NetworkFunction();
  List<UserInfoMine> goodMatch = await KNN_recommender(numberOfUsers);
  // print("goodMatch length1");
  // print(goodMatch.length);
  // if(goodMatch==null){
  //   return [];

  // }
    // return [];
  return goodMatch;
}

Future<void> getRequestStatus(List<UserInfoMine>? users, int recommendationIndex) async {
  List<String>? temp = [];
  temp = StaticStore.requestStatusValue?[recommendationIndex];
  if (users != null) {
    // print("bestmatch has data");
    for (int i = 0; i < users.length; i++){
      temp?.add(await getFriendStatus(users[i].email));
    }
    // print("bestmatch has stored data");
    StaticStore.requestStatusValue?.add(temp);
  } else {
    StaticStore.requestStatusValue?.add([]);
  }
}

Future<List<List<UserInfoMine>?>?> connectionCaller()  async {
  StaticStore.requestStatusValue?.clear();

  /* The below array store requeststatus value which is '0' if nothing done, 'userEmailId' if request sent and '1' if request has been accepted */
  StaticStore.requestStatusValue = [[], [], []];
  // right now only 20 matches are fetched (Implement the load more users on scroll)
  List<UserInfoMine> bestMatch = await fetchBestMatchFriends(20);
  List<UserInfoMine> goodMatch = await fetchGoodMatchFriends(20);


  /* Below code fetches all users (but no use so commented) */
  // List<UserInfoMine>? allUsers = await fetchAllFriends(3);
  List<UserInfoMine>? allUsers=[];

  await getRequestStatus(bestMatch, 0);
  await getRequestStatus(goodMatch, 1);
  await getRequestStatus(allUsers, 2);
  return [bestMatch,goodMatch,allUsers];
}

// Future<List<List<UserInfo>?>> userButtonCaller() async {
//   StaticStore.requestStatusValue?.clear();
//   StaticStore.requestStatusValue = [[], [], []];
//   List<UserInfo>? bestMatch = await fetchBestMatchFriends(3);
//   List<UserInfo>? goodMatch = await fetchGoodMatchFriends();
//   // List<UserInfo>? goodMatch = await KNN_recommender();
//   List<UserInfo>? allUsers = await fetchAllFriends(3);
//   // List<UserInfo>? allUsers = await KNN_recommender();

//   await getRequestStatus(bestMatch, 0);
//   await getRequestStatus(goodMatch, 1);
//   await getRequestStatus(allUsers, 2);

//       return [bestMatch,goodMatch,allUsers];
// }
