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

  Future<UserInfoMine?> fetchCurrentUserInfo() async {
    print('current userinfo not avaialable');
    return null;
    FirebaseCall _firebaseCall = FirebaseCall();
    var accessToken = "";
    ReadWrite _readWrite = ReadWrite();
    while (true) {
      accessToken = await _readWrite.getAccessToken();
      print("Hhhhh");

      /* Fetching user info */
      var res = await get(
          Uri.parse('https://api.spotify.com/v1/me?access_token=$accessToken'));

      print("userinfo: ${res.statusCode}");
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        // var topTrackGenres = await fetchTopTrackGenres();

        UserInfoMine? _userInfo;
        _userInfo = UserInfoMine.fromJson(data);
        StaticStore.currentUserId = _userInfo.id;
        StaticStore.currentUserName = _userInfo.displayName;
        StaticStore.currentUserEmail = _userInfo.email;
        StaticStore.currentUserCountry = _userInfo.country;
        StaticStore.currentUserImageUrl = _userInfo.imgUrl;

        print("user data fetched");

        return _userInfo;
      } else {
        AccessError e = AccessError();
        var responseOfAccesstoken = await e.handleError(res);
        if (responseOfAccesstoken == 2) {
          print("null refresh token plaese go to login or restart the app");
          return null;
        }

        if (responseOfAccesstoken != 1) {
          print("Error is not resolved for getting accesstoken in userinfo");
          return null;
        }
      }
    }
  }

  Future<void> writeTofirestore(UserInfoMine? _userInfo) async {
    FirebaseCall _firebaseCall = FirebaseCall();
    // await _firebaseCall.writeUserData(_userInfo!, StaticStore.userGenre);
    await _firebaseCall.writeSpotifyGenreData(StaticStore.userGenre);
  }
}
