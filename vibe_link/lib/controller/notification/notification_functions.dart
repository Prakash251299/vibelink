// import 'package:firebase_core/firebase_core.dart';
// import 'package:linkify/controller/Network/user_network_functions.dart';
// import 'package:linkify/controller/store_to_firebase/firebase_call.dart';
// import 'package:linkify/model/user_info.dart';

import 'package:vibe_link/controller/Network/user_network_functions.dart';
import 'package:vibe_link/controller/store_to_firebase/firebase_call.dart';
import 'package:vibe_link/model/user_info.dart';

Future<List<UserInfoMine>?> FetchRequestNotifications()async{
  // FirebaseCall _firebaseCaller = FirebaseCall(); 
  List<dynamic>? friendRequests = await fetchFriendRequests(); // data called from firebase can be null so null check must be there
  NetworkFunction _fetchUserInfo = NetworkFunction();
  List<UserInfoMine>? _userInfo=[];
  for(int i=0;friendRequests!=null && i<friendRequests.length;i++){
    UserInfoMine temp = await _fetchUserInfo.fetchUserInfo(friendRequests[i]);
    _userInfo.add(temp);
  }
  // print(_userInfo);
  return _userInfo;
}

Future<void>acceptFriendRequest(userId)async{
  print("friend request accepted");
  // FirebaseCall _firebaseCaller = FirebaseCall();
  await updateRequestStatus("1",userId);
  await addFriend(userId);
  await deleteFriendRequest(userId);
}

Future<void>rejectFriendRequest(userId)async{
  print("friend request rejected");
  // FirebaseCall _firebaseCaller = FirebaseCall();
  await deleteFriendRequest(userId);
  await updateRequestStatus("0",userId);

}