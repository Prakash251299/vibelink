import 'dart:convert';

import 'package:http/http.dart';
import 'package:vibe_link/controller/error/accesstoken_error.dart';
// import 'package:linkify/controller/error/accesstoken_error.dart';
// import 'package:linkify/controller/local_storing/read_write.dart';
import 'package:vibe_link/controller/local_storing/read_write.dart';
import '../../model/search/song_model.dart';

class SearchRepository {
  // Future<List<SongModel>> getSearchedSongOptions() async {
  Future<List<SongModel>> getSearchedSongOptions(var query) async {
    ReadWrite _readWrite = ReadWrite();

    while (true) {
      var accessToken = await _readWrite.getAccessToken();
      // print(query);
      // print("access token: $accessToken");
      // return [];
      // print("Hhhhh");

      /* Fetching searched tracks */
      var res = await get(Uri.parse(
          'https://api.spotify.com/v1/search?query=$query&type=track&locale=en-GB%2Cen-US%3Bq%3D0.9%2Cen%3Bq%3D0.8&offset=0&limit=20&access_token=$accessToken'));

      print(res.statusCode);
      // List<String>genres=[];
      if (res.statusCode == 200) {
        var data = await jsonDecode(res.body);
        // // print(data['items'][0]['genres'][0]);
        // var id = data['items'];
        // print(data['tracks']['items'][0]['name']);

        // SongModel s = SongModel();
        // print(data['tracks']['items'][0]['artists'][0]['name']);
        
        // List<SongModel> s = (data['tracks']['items'] as List)
        //     .map((e) => SongModel.fromJson(e))
        //     .toList();

        List<SongModel> s=[];
        print(data['tracks']['items'].length);
        for(int i=0;i<data['tracks']['items'].length && i<20;i++){
          if(data['tracks']['items'][i]['name']==null || data['tracks']['items'][i]['album']['images']==null || data['tracks']['items'][i]['album']['images'].length==0 || data['tracks']['items'][i]['id']=="" || data['tracks']['items'][i]['artists']==null){
            continue;
          }
          s.add(SongModel.fromJson(data['tracks']['items'][i]));
          print(i);
        }

        // return [];
        return s;

        // print(s.name);

        // (data['tracks']['items'])
        //   .map((e) => SongModel.fromJson(e))
        //   .toList();

        // return;
      } else {
        AccessError e = AccessError();
        if (await e.handleError(res) != 1) {
          print("Error is not resolved");
          List<SongModel> s = [];
          return s;
        }
      }
    }
  }

  // Future<List<User>> getUsers(String tag) async {
  //   final query = {
  //     "page": 0.toString(),
  //     "limit": 50.toString(),
  //     "q": tag,
  //   };

  //   Response res = await getResponse(
  //       Uri.https(baseUrl, basePath + '/search/artists', query));
  //   if (res.statusCode == 200) {
  //     var body = jsonDecode(res.body);
  //     return (body['results'] as List).map((e) => User.fromJson(e)).toList();
  //   } else {
  //     throw Exception("failed fetch users ");
  //   }
  // }

  // Future<List<SongModel>> getSongs(String tag) async {
  //   final query = {
  //     "page": 0.toString(),
  //     "limit": 50.toString(),
  //     "q": tag,
  //   };

  //   Response res = await getResponse(
  //       Uri.https(baseUrl, basePath + '/search/songs', query));
  //   if (res.statusCode == 200) {
  //     var body = jsonDecode(res.body);

  //     return (body['results'] as List)
  //         .map((e) => SongModel.fromJson(e))
  //         .toList();
  //   } else {
  //     throw Exception("failed fetch users ");
  //   }
  // }
}
