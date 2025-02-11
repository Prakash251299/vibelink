import 'dart:convert';

import 'package:http/http.dart';
import 'package:vibe_link/controller/error/accesstoken_error.dart';
import 'package:vibe_link/controller/genre/user_genre.dart';
import 'package:vibe_link/controller/local_storing/read_write.dart';
import 'package:vibe_link/controller/store_to_firebase/firebase_call.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/model/user_info.dart';

class StoreUserInfo {
  Future<void> fetch_store_user_info() async {
    StoreUserInfo s = StoreUserInfo();
    FirebaseCall _firebaseCall = FirebaseCall();
    // current user info can be fetched from here
    // UserInfo? _userInfo = await s.fetchCurrentUserInfo();


    /* This must not called everytime */
    // var topTrackGenres = await _firebaseCall.getUserArtists(); // For storing it
    // await writeTofirestore(_userInfo);
  }

  Future<void> writeTofirestore(UserInfoMine? _userInfo) async {
    FirebaseCall _firebaseCall = FirebaseCall();
    // await _firebaseCall.writeUserData(_userInfo!, StaticStore.userGenre);
    await _firebaseCall.writeSpotifyGenreData(StaticStore.userGenre);
  }
}
