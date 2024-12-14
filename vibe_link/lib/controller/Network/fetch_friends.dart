import 'package:flutter/material.dart';
import 'package:vibe_link/controller/Network/recommend_knn.dart';
import 'package:vibe_link/controller/Network/user_network_functions.dart';
import 'package:vibe_link/controller/store_to_firebase/firebase_call.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/model/user_info.dart';
// import 'package:linkify/controller/Network/recommend_knn.dart';
// import 'package:linkify/controller/Network/user_network_functions.dart';
// import 'package:linkify/controller/store_to_firebase/firebase_call.dart';
// import 'package:linkify/controller/variables/static_store.dart';
// import 'package:linkify/model/user_info.dart';
// import 'package:linkify/view/Network/suggestions/friend_suggestion.dart';
// import 'package:linkify/view/Network/user_network.dart';

Future<List<UserInfoMine>?> fetchAllFriends(int numberOfUsers) async {
  NetworkFunction _networkFunction = NetworkFunction();
  List<UserInfoMine>? allUsers =
      await _networkFunction.fetchAllUsersInfo(numberOfUsers);
  return allUsers;
}

Future<List<UserInfoMine>?> fetchBestMatchFriends(int numberOfUsers) async {
  NetworkFunction _networkFunction = NetworkFunction();
  List<UserInfoMine>? bestMatch =
      await _networkFunction.fetchRecommendedUsersInfo(numberOfUsers);
  return bestMatch;
}

Future<List<UserInfoMine>?> fetchGoodMatchFriends() async {
  NetworkFunction _networkFunction = NetworkFunction();
  List<UserInfoMine>? goodMatch = await KNN_recommender();
  return goodMatch;
}

Future<void> getRequestStatus(List<UserInfoMine>? users, int recommendationIndex) async {
  // List<dynamic>Error happened at homecubit in getRecommendedUsers function
  List<String>? temp = [];
  temp = StaticStore.requestStatusValue?[recommendationIndex];
  if (users != null) {
    print("bestmatch has data");
    // print(users.length);
    // return ;
    for (int i = 0; i < users.length && i<3; i++){
      temp?.add(await getFriendStatus(users[i].email));
    }
    print("bestmatch has stored data");
    StaticStore.requestStatusValue?.add(temp);
  } else {
    StaticStore.requestStatusValue?.add([]);
  }
  // print(StaticStore.requestStatusValue);
}

Future<List<List<UserInfoMine>?>?> connectionCaller()  async {
  StaticStore.requestStatusValue?.clear(); 

  /* The below array store requeststatus value which is '0' if nothing done, 'userEmailId' if request sent and '1' if request has been accepted */
  StaticStore.requestStatusValue = [[], [], []];
  // List<UserInfoMine>? bestMatch = await fetchBestMatchFriends(3);
  List<UserInfoMine>? goodMatch = await fetchGoodMatchFriends();
  // print(goodMatch?.length);

  List<UserInfoMine>? allUsers = await fetchAllFriends(3);

  // await getRequestStatus(bestMatch, 0);
  print("goodmatch length");
  print(goodMatch?[0].displayName);
  print(goodMatch?[0].email);
  await getRequestStatus(goodMatch, 1);
  await getRequestStatus(allUsers, 2);

  // return [bestMatch,goodMatch,allUsers];
  return [[],goodMatch,allUsers];
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
