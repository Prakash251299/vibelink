/*
CustomScrollView widget is better
*/

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vibe_link/controller/player/youtube_player.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/model/album_track.dart';
import 'package:vibe_link/view/album/album_play_pause_button/button_album_play_pause.dart';
import 'package:vibe_link/view/home/loading.dart';
import 'package:vibe_link/view/music_screen/carousel_song_screen.dart';
import 'package:vibe_link/view/sticky/sticky_widgets.dart';

class AlbumView extends StatefulWidget {
  String? albumImg = "";
  String? albumName = "";
  List<AlbumTrack>? _albumTracks = [];
  AlbumView(this.albumImg, this.albumName, this._albumTracks);

  @override
  State<AlbumView> createState() => AlbumViewState();
}

class AlbumViewState extends State<AlbumView> {
  // var playing = false;
  var ind = -10;
  YoutubeSongPlayer _player = YoutubeSongPlayer();

  double _counter = 0;
  @override
  Widget build(BuildContext context) {
    // var _extraScrollSpeed = 0;
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;
    ScrollController _scrollController = ScrollController();
    // var mq = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            NotificationListener(
              child: CustomScrollView(controller: _scrollController, slivers: [
                SliverAppBar(
                    // collapsedHeight:50,
                    backgroundColor: Colors.black,
                    toolbarHeight: 0,
                    leading: SizedBox(),
                    floating: false,
                    pinned: true,
                    expandedHeight: 250,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const <StretchMode>[
                        StretchMode.blurBackground
                      ],
                      expandedTitleScale: 1,
                      title: Container(
                        padding: EdgeInsets.only(left: 7, right: 20),
                        width: MediaQuery.of(context).size.width,
                      ),
                      background: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Image.network(
                          '${widget.albumImg}', // Replace with your image URL
                          fit: BoxFit
                              .fitHeight, // Ensure the image covers the entire space
                        ),
                      ),
                    )),
                SliverAppBar(
                    expandedHeight: 90,
                    backgroundColor: Colors.black,
                    leading: SizedBox(),
                    floating: false,
                    pinned: true,
                    // expandedHeight: 200,
                    flexibleSpace: FlexibleSpaceBar(
                      // collapseMode: CollapseMode.parallax,
                      titlePadding: EdgeInsets.only(left: 0),
                      // stretchModes:const <StretchMode>[StretchMode.zoomBackground],
                      expandedTitleScale: 1,
                      title: Container(
                          padding: EdgeInsets.only(left: 7, right: 20),
                          // color: Colors.red,
                          width: MediaQuery.of(context).size.width,
                          // width:50,
                          height: 60,
                          child: Row(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width - _counter - 100,
                                  padding: EdgeInsets.only(left: 10 + _counter),
                                  child: Text(
                                    '${widget.albumName}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              Spacer(),
                              Container(
                                  // padding: EdgeInsets.only(right: 30),
                                  child: StreamBuilder<Object>(
                                      stream:
                                          StaticStore.player.playerStateStream,
                                      builder: (context, snapshot) {
                                        return IconButton(
                                          // icon:Icon(Icons.play_circle,color: Colors.white,size:50),
                                          icon: playPauseAlbumButtonTop(
                                              widget._albumTracks, 0),
                                          onPressed: () async {
                                            print("number of songs");
                                            print(widget._albumTracks!.length);

                                            if (StaticStore.playing == true) {
                                              _player
                                                  .youtubePause()
                                                  .then((value) {
                                                StaticStore.pause = true;
                                                StaticStore.playing = false;
                                              });
                                            } else {
                                              if (StaticStore.pause == true) {
                                                _player
                                                    .youtubeResume()
                                                    .then((value) {
                                                  StaticStore.pause = false;
                                                  StaticStore.playing = true;
                                                });
                                              } else {
                                                await _player.youtubeStop().then((v)async{
                                                await _player
                                                    .youtubePlay(
                                                        widget._albumTracks![0]
                                                            .name,
                                                        widget._albumTracks![0]
                                                            .trackArtists?[0],0)
                                                    .then((value) {
                                                  // });
                                                  // StaticStore.pause = false;
                                                  StaticStore.myQueueTrack =
                                                      widget._albumTracks!;
                                                  StaticStore.queueLoaded = 1;
                                                  StaticStore.queueIndex = 0;
                                                  StaticStore.currentSong =
                                                      widget._albumTracks![0]
                                                          .name!;
                                                  StaticStore.currentSongImg =
                                                      widget._albumTracks![0]
                                                          .imgUrl!;
                                                  StaticStore.currentArtists =
                                                      List.from(widget
                                                          ._albumTracks![0]
                                                          .trackArtists??[]);
                                                  StaticStore.playing = true;
                                                  StaticStore.pause = false;
                                                });
                                                });
                                              }
                                            }
                                          },
                                        );
                                      }))
                            ],
                          )),
                    )),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Column(children: [
                        Card(
                          color: Colors.black,
                          child: Column(children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () async {
                                if (StaticStore.player.playing == true) {
                                  if (StaticStore.currentSong ==
                                      widget._albumTracks![index].name) {
                                    await _player.youtubePause();
                                    // setState(() {
                                    StaticStore.playing = false;
                                    StaticStore.pause = true;
                                    // });
                                  } else {
                                    // print(widget._albumTracks?[index].name);
                                    if(StaticStore.nextPlay==1){
                                      StaticStore.nextPlay = 0;
                                    await _player.youtubeStop().then((v)async{
                                    await _player
                                        .youtubePlay(
                                            widget._albumTracks![index].name,
                                            widget._albumTracks![index]
                                                .trackArtists?[0],index)
                                        .then((value) {
                                      // });
                                      // StaticStore.pause = false;
                                      
                                      StaticStore.myQueueTrack =
                                          widget._albumTracks!;
                                      StaticStore.queueLoaded = 1;
                                      StaticStore.queueIndex = index;
                                      StaticStore.currentSong =
                                          widget._albumTracks![index].name!;
                                      StaticStore.currentSongImg =
                                          widget._albumTracks![index].imgUrl!;
                                      StaticStore.currentArtists = List.from(
                                          widget._albumTracks![index]
                                              .trackArtists??[]);
                                      // setState(() {

                                      StaticStore.playing = true;
                                      StaticStore.pause = false;
                                      // });
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CarouselSongScreen(
                                                      widget
                                                          ._albumTracks![index]
                                                          .name,
                                                      // widget.albumImg[index],
                                                      widget
                                                          ._albumTracks![index]
                                                          .id,
                                                      widget
                                                          ._albumTracks![index]
                                                          .trackArtists,
                                                      // widget.trackImg[index]
                                                      widget
                                                          ._albumTracks![index]
                                                          .imgUrl)));
                                    });
                                    });}
                                  }
                                } else {
                                  // if(StaticStore.pause==true){

                                  // }
                                  // StaticStore.playing=true;
                                  // StaticStore.pause=false;
                                  if (StaticStore.currentSong ==
                                      widget._albumTracks![index].name) {
                                    StaticStore.playing = true;
                                    StaticStore.pause = false;
                                    await _player.youtubeResume();
                                  } else {
                                    if(StaticStore.nextPlay==1){
                                      StaticStore.nextPlay = 0;
                                    await _player.youtubeStop();

                                    await _player
                                        .youtubePlay(
                                            widget._albumTracks![index].name,
                                            widget._albumTracks![index]
                                                .trackArtists?[0],index)
                                        .then((value) {
                                      // });
                                      StaticStore.myQueueTrack =
                                          widget._albumTracks!;
                                      StaticStore.queueLoaded = 1;
                                      StaticStore.queueIndex = index;
                                      StaticStore.currentSong =
                                          widget._albumTracks![index].name!;
                                      StaticStore.currentSongImg =
                                          widget._albumTracks![index].imgUrl!;
                                      StaticStore.currentArtists = List.from(
                                          widget._albumTracks![index]
                                              .trackArtists??[]);
                                      StaticStore.playing = true;
                                      StaticStore.pause = false;

                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CarouselSongScreen(
                                                      widget
                                                          ._albumTracks![index]
                                                          .name,
                                                      // widget.albumImg[index],
                                                      widget
                                                          ._albumTracks![index]
                                                          .id,
                                                      widget
                                                          ._albumTracks![index]
                                                          .trackArtists,
                                                      // widget.trackImg[index]
                                                      widget
                                                          ._albumTracks![index]
                                                          .imgUrl)));
                                    });
                                    }
                                  }
                                }
                              },
                              child: ListTile(
                                leading: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(3),
                                          bottomLeft: Radius.circular(3),
                                        ),
                                        child:
                                            // CachedNetworkImage(imageUrl: ""),
                                            CachedNetworkImage(
                                          // imageUrl: user.avatar!,

                                          imageUrl:
                                              "${widget._albumTracks?[index].imgUrl}",
                                          // imageUrl: "",

                                          width: 55,
                                          height: 55,
                                          memCacheHeight:
                                              (55 * devicePexelRatio).round(),
                                          memCacheWidth:
                                              (55 * devicePexelRatio).round(),
                                          maxHeightDiskCache:
                                              (55 * devicePexelRatio).round(),
                                          maxWidthDiskCache:
                                              (55 * devicePexelRatio).round(),
                                          progressIndicatorBuilder:
                                              (context, url, l) =>
                                              LoadingImage(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ]),
                                title: Text(
                                  "${widget._albumTracks?[index].name}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: widget._albumTracks != null && widget._albumTracks![index].trackArtists!=null &&
                                        widget._albumTracks![index].trackArtists!
                                                .length >
                                            1
                                    ? Text(
                                        '${widget._albumTracks?[index].trackArtists?[0]}, ${widget._albumTracks?[index].trackArtists?[1]}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white70))
                                    : Text(
                                        '${widget._albumTracks![index].trackArtists?[0]}',
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            TextStyle(color: Colors.white70)),
                                isThreeLine: true,
                                trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      
                                      StreamBuilder<Object>( // for updating the button
                                        stream: StaticStore.player.playerStateStream,
                                        builder: (context, snapshot) {
                                          return playPauseAlbumButton(
                                              widget._albumTracks, index);
                                        }
                                      ),
                                    ]),
                              ),
                            ),
                          ]),
                        ),
                      ]);
                    },
                    childCount:
                        widget._albumTracks?.length, // Number of list items
                  ),
                ),
              ]),
              onNotification: (t) {
                // print(_scrollController.offset);
                setState(() {
                  if (_scrollController.offset >= 236) {
                    _counter = _scrollController.offset - 236;
                  }
                  if (_scrollController.offset > 266) {
                    _counter = 30;
                  }
                  if (_scrollController.offset < 236) {
                    _counter = 0;
                  }
                  // print(_counter);
                });
                return true;
              },
            ),
            StreamBuilder(
                stream: StaticStore.player.playerStateStream,
                builder: (context, snapshot1) {
                  return StaticStore.playing == true ||
                          StaticStore.pause == true
                      ?
                      // Text("hi")
                      miniplayer(context)
                      : const SizedBox();
                }),
            footer(context),
            Container(
              padding: EdgeInsets.only(
                top: 3,
              ),
              child: Opacity(
                // opacity: _counter/40,
                opacity: 1,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}