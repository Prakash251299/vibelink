import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vibe_link/controller/error/accesstoken_error.dart';
import 'package:vibe_link/controller/local_storing/read_write.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/model/album_track.dart';
import 'package:vibe_link/view/album/album_view.dart';
import 'package:vibe_link/view/home/loading.dart';
// import 'package:linkify/controller/error/accesstoken_error.dart';
// import 'package:linkify/controller/local_storing/read_write.dart';
// import 'package:linkify/controller/variables/static_store.dart';
// import 'package:linkify/model/album_track.dart';
// import 'package:linkify/view/album/album_view.dart';
// import 'package:linkify/view/home/loading.dart';

class CarouselSongs extends StatefulWidget {
  // var albumInfo = {};
  Map<String, List<dynamic>>? albumInfo = {};

  CarouselSongs(this.albumInfo, {super.key});

  @override
  State<CarouselSongs> createState() => _CarouselSongsState();
}

class _CarouselSongsState extends State<CarouselSongs> {
  // PlaySpotifySong _playSpotifySong = PlaySpotifySong();

  Future<void> fetchAlbumSongs(var albumId, int ind) async {
    DateTime now = DateTime.now(); // 30/09/2021 15:54:30
    var dateToday = now.day.toString();
    dateToday += "-";
    dateToday += now.month.toString();
    dateToday += "-";
    dateToday += now.year.toString();
    StaticStore.myQueueTrack = StaticStore.trackInfo[ind];
    if (StaticStore.dateStored == dateToday &&
        StaticStore.trackInfo[ind].length != 0) {
      return;
    }
    StaticStore.dateStored = dateToday;
    String? id = "";
    String name = "";

    // DateTime now = DateTime.now(); // 30/09/2021 15:54:30
    // var dateToday = now.day.toString();
    // dateToday += "-";
    // dateToday += now.month.toString();
    // dateToday += "-";
    // dateToday += now.year.toString();
    // if (StaticStore.dateStored == dateToday &&
    //     StaticStore.trackInfo[ind]['name'] != null) {
    //   return;
    // }
    // StaticStore.dateStored = dateToday;

    ReadWrite _readWrite = ReadWrite();
    while (true) {
      var accessToken = await _readWrite.getAccessToken();
      // print("Hhhhh");

      /* Fetching album tracks */
      var res = await get(Uri.parse(
          'https://api.spotify.com/v1/albums/$albumId/tracks?offset=0&locale=en-GB%2Cen-US%3Bq%3D0.9%2Cen%3Bq%3D0.8&time_range=short_term&access_token=$accessToken'));
      // var res = await get(Uri.parse('https://api.spotify.com/v1/me/tracks?limit=30&time_range=short_term&access_token=$accessToken'));
      print(res.statusCode);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        id = data['items'][0]['id'];
        name = data['items'][0]['name'] ?? "";

        name == "" ? null : await fetchSimilarTracks(name, ind);

        return;
      } else {
        AccessError e = AccessError();
        var a = await e.handleError(res);
        if (a == 2) {
          print("null refresh token plaese go to login or restart the app");
          return;
        }
      }
    }
  }

  Future<void> fetchSimilarTracks(String songName, var ind) async {
    // List<String>? name = [];
    // List<String>? id = [];
    List<String>? trackArtists = [];
    // List<String>?trackImg = [];
    // List<List<String>>? artistNames = [];
    ReadWrite _readWrite = ReadWrite();
    while (true) {
      var accessToken = await _readWrite.getAccessToken();

      /* Fetching album tracks */
      var res = await get(Uri.parse(
          'https://api.spotify.com/v1/search?q=$songName+like+songs&type=track&limit=30&access_token=$accessToken'
          // 'https://api.spotify.com/v1/recommendations?seed_tracks=$songId&limit=50&access_token=$accessToken'
          // var res = await get(Uri.parse('https://api.spotify.com/v1/me/tracks?limit=30&time_range=short_term&access_token=$accessToken'
          ));
      print(res.statusCode);
      if (res.statusCode == 200) {
        List<AlbumTrack>? carouselTrack = [];
        var data = jsonDecode(res.body);
        for (int i = 0; i < data['tracks']['items'].length && i < 30; i++) {
          trackArtists = [];
          for (int j = 0;
              data['tracks']['items'][i] != null &&
                  data['tracks']['items'][i]['artists'] != null &&
                  j < data['tracks']['items'][i]['artists'].length;
              j++) {
            trackArtists.add(data['tracks']['items'][i]['artists'].length != 0
                ? data['tracks']['items'][i]['artists'][j]['name']
                : "unknown");
          }
          AlbumTrack _albumTrack = AlbumTrack.fromJson({
            "name": data['tracks']['items'][i] == null
                ? ""
                : data['tracks']['items'][i]['name'],
            "id": data['tracks']['items'][i] == null
                ? ""
                : data['tracks']['items'][i]['id'],
            "trackImg": data['tracks']['items'][i] == null
                ? ""
                : data['tracks']['items'][i]['album']['images'].length != 0
                    ? data['tracks']['items'][i]['album']['images'][0]['url']
                    : "",
            "trackArtists": trackArtists,
          });

          print(data['tracks']['items'][0]);

          if (_albumTrack.name == "" ||
              _albumTrack.id == "" ||
              _albumTrack.imgUrl == "") {
            continue;
          } else {
            carouselTrack.add(_albumTrack);
          }

          // fetching 50 similar songs
          //   name.add(data['tracks'][i]['name']);
          //   id.add(data['tracks'][i]['id']);
          //   trackImg.add(data['tracks'][i]['album']['images'][0]['url']);

          //   artistNames.add(trackArtists!);
          //   trackArtists=[];
          // }
          // StaticStore.trackInfo[ind].addEntries({'id': id}.entries);
          // StaticStore.trackInfo[ind].addEntries({'name': name}.entries);
          // StaticStore.trackInfo[ind].addEntries({'artists': artistNames}.entries);
          // StaticStore.trackInfo[ind].addEntries({'trackImg': trackImg}.entries);
          // return;
        }
        // StaticStore.trackInfo = carouselTrack;
        StaticStore.trackInfo[ind] = List.from(carouselTrack);
        return;
      }

      // if (res.statusCode == 200) {
      //   var data = jsonDecode(res.body);
      //   for (int i = 0; i < 50; i++) {
      //     // fetching 50 similar songs
      //     name.add(data['tracks'][i]['name']);
      //     id.add(data['tracks'][i]['id']);
      //     trackImg.add(data['tracks'][i]['album']['images'][0]['url']);

      //     for(int j=0;j<data['tracks'][i]['artists'].length;j++){
      //       trackArtists?.add(data['tracks'][i]['artists'][j]['name']);
      //     }
      //     artistNames.add(trackArtists!);
      //     trackArtists=[];
      //   }
      //   StaticStore.trackInfo[ind].addEntries({'id': id}.entries);
      //   StaticStore.trackInfo[ind].addEntries({'name': name}.entries);
      //   StaticStore.trackInfo[ind].addEntries({'artists': artistNames}.entries);
      //   StaticStore.trackInfo[ind].addEntries({'trackImg': trackImg}.entries);
      //   return;
      // }

      else {
        AccessError e = AccessError();
        var a = await e.handleError(res);
        if (a == 2) {
          print("null refresh token plaese go to login or restart the app");
        }
      }
    }
  }

  // var _useRtlText = false;

  @override
  Widget build(BuildContext context) {
    var devicePexelRatio = MediaQuery.of(context).devicePixelRatio;

    return SafeArea(
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            // filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child:
                // widget.albumInfo?['trackName']!=null
                // widget.albumInfo?.length!=0
                widget.albumInfo!['name']!.isNotEmpty
                    //  && widget.albumInfo?['trackName']?[0]!=""
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Column(
                          //   children: [
                          Padding(
                            padding: EdgeInsets.all(17.0),
                            child: Wrap(
                              // alignment: WrapAlignment.center,
                              // crossAxisAlignment: WrapCrossAlignment.center,
                              runSpacing: 8,
                              spacing: 8,
                              children: [
                                for (int i = 0;
                                    i < widget.albumInfo!['name']!.length &&
                                        i < 6;
                                    i++) ...{
                                  InkWell(
                                    onTap: () async {
                                      print("Inside carousel");
                                      // await fetchUserGenre();

                                      setState(() {
                                        StaticStore.carouselInd = i;
                                      });

                                      await fetchAlbumSongs(
                                          widget.albumInfo?['id']?[i], i);
                                      // StaticStore.myQueueTrack = ;

                                      Navigator.of(context).push(
                                          PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            AlbumView(
                                          widget.albumInfo?['image']?[i],
                                          widget.albumInfo?['trackName']?[i],
                                          StaticStore.trackInfo[i],
                                        ),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                        transitionDuration:
                                            const Duration(milliseconds: 400),
                                      )
                                          // MaterialPageRoute(
                                          //   builder: (context) =>
                                          //   AlbumView(
                                          //     widget.albumInfo?['image']?[i],
                                          //     widget.albumInfo?['trackName']?[i],
                                          //     StaticStore.trackInfo[i],
                                          //   ),
                                          //   )
                                          );

                                      // });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white12,
                                        // color: Colors.black,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      width:
                                          ((MediaQuery.of(context).size.width *
                                                  .5) -
                                              21.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(3),
                                              bottomLeft: Radius.circular(3),
                                            ),
                                            child: CachedNetworkImage(
                                              // imageUrl: user.avatar!,
                                              imageUrl:
                                                  widget.albumInfo?['image']
                                                          ?[i] ??
                                                      "",
                                              // imageUrl: "",

                                              width: 55,
                                              height: 55,
                                              memCacheHeight:
                                                  (55 * devicePexelRatio)
                                                      .round(),
                                              memCacheWidth:
                                                  (55 * devicePexelRatio)
                                                      .round(),
                                              maxHeightDiskCache:
                                                  (55 * devicePexelRatio)
                                                      .round(),
                                              maxWidthDiskCache:
                                                  (55 * devicePexelRatio)
                                                      .round(),
                                              progressIndicatorBuilder:
                                                  (context, url, l) =>
                                                      const LoadingImage(),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 30,
                                                // width:auto,
                                                child: Text(
                                                  '${widget.albumInfo?['trackName']?[i]}   ',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                // Text("jejk"),
                                                // Text("${widget.albumInfo?['name']?[i]}"),

                                                // Text("hello",style:TextStyle(color:Colors.white)),
                                                //     Marquee(
                                                //   text: '${widget.albumInfo?['trackName']?[i]}   ',
                                                //   // text: 'hi   ',

                                                //   style: TextStyle(color: Colors.white),
                                                //   velocity: 4,
                                                // ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                }
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          //   ],
                          // ):SizedBox(),
                        ],
                      )
                    :
                    // Text("sagd",style:TextStyle(color: Colors.white)),
                    SizedBox(),
          ),
        ],
      ),
    );
  }
}
