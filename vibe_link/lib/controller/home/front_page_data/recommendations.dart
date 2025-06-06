import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vibe_link/controller/error/accesstoken_error.dart';
import 'package:vibe_link/controller/local_storing/read_write.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/model/home/first_page_categories.dart';
import 'package:vibe_link/view/home/home_screen.dart';
// import 'package:linkify/controller/error/accesstoken_error.dart';
// import 'package:linkify/model/home/first_page_categories.dart';
// import 'package:linkify/controller/login.dart';
// import 'package:linkify/controller/logout.dart';
// import 'package:linkify/controller/local_storing/read_write.dart';
// import 'package:http/http.dart' as http;
// import 'package:linkify/controller/variables/static_store.dart';
// import 'package:linkify/view/home/home_screen.dart';
// import 'package:spotify/spotify.dart';
// import 'package:spotify/src/models/_models.dart';
// import 'package:linkify/controller/webview.dart';
// import 'package:linkify/main.dart';
// import 'package:linkify/widgets/uis/screens/bottom_nav_bar/bottom_nav_bar.dart';
// import 'package:url_launcher/url_launcher.dart';

// Future<Map<String, List<dynamic>>?> getCarouselSongs() async {
Future<Map<String, List<dynamic>>?> getCarouselSongs() async {
  Map<String, List<dynamic>>? m = {};
  List<String> id = [];
  List<String> name = [];
  List<String> imgUrl = [];
  List<String> trackName = [];
  List<String> trackId = [];

  ReadWrite _readWrite = ReadWrite();
  while (true) {
    var accessToken = await _readWrite.getAccessToken();
    // print("fetching carousel lists");
    var res = await get(Uri.parse(
        'https://api.spotify.com/v1/me/tracks?limit=30&time_range=medium_term&access_token=$accessToken'));
    // print(res.statusCode);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      // print("kl");
      // print(data['items'].length);
      print("carouselSongs fetching in recommendation");
      if (data['items'].length > 0) {
        for (int i = 0; i < data['items'].length; i++) {
          // print(data['items'].keys.toList()[0]);

          // name.add(data['items'])
          // print(data['items'][0].name);
          trackName.add(data['items'][i]['track']['name']);
          trackId.add(data['items'][i]['track']['id']);
          // for(int j=0;j<data['items'][i]['track']['artists'].length;j++){
          //   singleTrackArtists.add(data['items'][i]['track']['artists'][j]['name']);
          // }
          // trackImg.add(data['items'][i]['track']['album']['images'][0]['url']);

          name.add(data['items'][i]['track']['album']['name']);
          id.add(data['items'][i]['track']['album']['id']);
          imgUrl.add(data['items'][i]['track']['album']['images'][0]['url']);
          // trackArtists.add(singleTrackArtists);
          // print(data['items'][i]['track']['album']['name']);
          //  print(data['items'][i]['track']['name']);
        }
      } else {
        /* write code for new user */
      }
      // print(imgUrl);

      m.addEntries({'name': name}.entries);
      m.addEntries({'id': id}.entries);
      m.addEntries({'image': imgUrl}.entries);

      m.addEntries({'trackName': trackName}.entries);
      m.addEntries({'trackId': trackId}.entries);
      // m.addEntries({'artists':trackArtists}.entries);
      // m.addEntries({'trackImage':trackImg}.entries);
      // print("heer");
      // print("heer1");
      // print(m.length);
      print(name.length);
      return m;
    } else {
      AccessError e = AccessError();
      var a = await e.handleError(res);
      if (a == 2) {
        print("null refresh token plaese go to login or restart the app");
        // return m;
      }
      // return m;
    }
    // return m;
  }
}

Future<List<Items>?> fetchCategoryPlaylists(String categoryId,String categoryName) async {
  List<Items>? item = [];
  // List<Map<String,dynamic>> item=[];
  ReadWrite _readWrite = ReadWrite();
  while (true) {
    var accessToken = await _readWrite.getAccessToken();
    /* Fetching category playlsts */
    var res = await get(Uri.parse(
        // 'https://api.spotify.com/v1/recommendations?seed_tracks=$trackId&limit=6&access_token=$accessToken'
        // 'https://api.spotify.com/v1/browse/categories/$categoryId/playlists?access_token=$accessToken'
        'https://api.spotify.com/v1/search?q=$categoryName&limit=30&type=playlist&access_token=$accessToken'
        ));
    print("fetching category playlists");
    print("CategoryPlaylistsState: ${res.statusCode}");
    int c=0;
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      
      for (int i = 0; i < data['playlists']['items'].length && i < 10; i++) {
        // String s = data['playlists']['items'][i]['name'];
        // print(data['playlists']['items'][i]['name']);
      //   // print(data['playlists']['items'][i]['images'][0]['url']);
      //   // item.add()
        data['playlists']['items'][i]==null?null:
        item.add(Items.fromJson({
          "name": data['playlists']['items'][i]['name']==null?"NA":data['playlists']['items'][i]['name'],
          "id": data['playlists']['items'][i]['id']==null?"NA":data['playlists']['items'][i]['id'],
          "imgUrl": data['playlists']['items'][i]['images'][0]['url']==null?"":data['playlists']['items'][i]['images'][0]['url']
        }));
      }
      return item;
    } else {
      AccessError e = AccessError();
      await e.handleError(res);
      c++;
      if(c>=1){
        return item;
      }
    }
  }
  // return item;object
}

Future<List<FrontPageCategories>> fetchCategory() async {
  DateTime now = DateTime.now(); // 30/09/2023 15:54:30
  var dateToday = now.day.toString();
  dateToday += "-";
  dateToday += now.month.toString();
  dateToday += "-";
  dateToday += now.year.toString();
  // if (StaticStore.dateStored == dateToday) {
  //   return [];
  // }
  print("same date data doesn't fetched");
  if (StaticStore.dateStored2 == dateToday) {
    return StaticStore.categoryInfo;
  }
  StaticStore.dateStored2 = dateToday;
  ReadWrite _readWrite = ReadWrite();
  List<FrontPageCategories> _categories = [];

  StaticStore.categoryInfo = _categories;
  // int c=0;
  while (true) {
    var accessToken = await _readWrite.getAccessToken();
    /* Fetching category playlsts */
    // print(accessToken);

    var res = await get(Uri.parse(
        'https://api.spotify.com/v1/browse/categories?access_token=$accessToken'));
    // var res = await http.get(Uri.parse('https://api.spotify.com/v1/browse/categories?access_token=$accessToken'));
    print("fetched categories");
    print(res.statusCode);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);



      for (int i = 0;i < data['categories']['items'].length && i < numberOfFrontPageCategories;i++) {
        // print(data['categories']['items'][i]['name']);
        List<Items>? item =
            data['categories']['items']==null?null:await fetchCategoryPlaylists(data['categories']['items'][i]['id'],data['categories']['items'][i]['name']);
        data['categories']['items']==null?null:
        _categories.add(FrontPageCategories.fromJson({
          "name": data['categories']['items'][i]['name'],
          "id": data['categories']['items'][i]['id'],
          "playlists": item,
        }));
        // _categories.add(k);
      }

      // print(_categories);

      return _categories;
    } else {
      AccessError e = AccessError();
      await e.handleError(res);
    }
  }
}

Future<void> carouselRecommendation(var trackId) async {
  ReadWrite _readWrite = ReadWrite();
  while (true) {
    var accessToken = await _readWrite.getAccessToken();

    /* Fetching album tracks */
    var res = await get(Uri.parse(
        'https://api.spotify.com/v1/recommendations?seed_tracks=$trackId&limit=6&access_token=$accessToken'));
    print(res.statusCode);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      for (int i = 0; i < data['tracks'].length; i++) {
        print(data['tracks'][i]['name']);
      }
      return;
    } else {
      AccessError e = AccessError();
      await e.handleError(res);
    }
  }
}
