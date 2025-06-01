import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vibe_link/controller/player/youtube_player.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/model/album_track.dart';
import 'package:vibe_link/view/home/loading.dart';
import 'package:vibe_link/view/music_screen/carousel_song_screen.dart';
import 'package:vibe_link/view/album/album_play_pause_button/button_album_play_pause.dart';

class QueueScreen extends StatefulWidget {
  QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  ScrollController _scrollController = ScrollController();
  List<AlbumTrack> _queueTracks = StaticStore.myQueueTrack;
  YoutubeSongPlayer _player = YoutubeSongPlayer();
  var _counter = 0.0;
  late AnimationController _animation_controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;
    var mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Queue",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        // backgroundColor: ,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: NotificationListener(
        child: StaticStore.myQueueTrack.isEmpty
            ? Center(
                child: Text("No songs in queue"),
              )
            : ListView.builder(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: _queueTracks.length,
                controller: _scrollController,
                itemBuilder: (context, position) {
                  return Column(children: [
                    Card(
                      color: Colors.black,
                      child: Column(children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () async {
                            if (StaticStore.nextPlay == 0) {
                              return;
                            }
                            if (StaticStore.player.playing == true) {
                              if (StaticStore.currentSong ==
                                  _queueTracks[position].name) {
                                await _player.youtubePause();
                                StaticStore.playing = false;
                                StaticStore.pause = true;
                              } else {
                                await _player.youtubeStop();
                                StaticStore.queueIndex = position;
                                StaticStore.currentSong =
                                    _queueTracks[position].name ?? "";
                                StaticStore.currentSongImg =
                                    _queueTracks[position].imgUrl ?? "";

                                StaticStore.currentArtists = List.from(
                                    _queueTracks[position].trackArtists ?? []);
                                await _player
                                    .youtubePlay(
                                        _queueTracks[position].name,
                                        _queueTracks[position].trackArtists?[0],
                                        position)
                                    .then((value) {
                                  // StaticStore.queueIndex = position;
                                  // StaticStore.currentSong = _queueTracks[position].name??"";
                                  // StaticStore.currentSongImg = _queueTracks[position].imgUrl??"";

                                  // StaticStore.currentArtists = List.from(_queueTracks[position].trackArtists??[]);

                                  StaticStore.playing = true;
                                  StaticStore.pause = false;
                                  Navigator.pop(context);
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => CarouselSongScreen(
                                  //         _queueTracks[position].name,
                                  //         _queueTracks[position].id,
                                  //         _queueTracks[position].trackArtists,
                                  //         _queueTracks[position].imgUrl)));
                                });
                              }
                            } else {
                              StaticStore.playing = true;
                              StaticStore.pause = false;
                              if (StaticStore.currentSong ==
                                  _queueTracks[position].name) {
                                await _player.youtubeResume();
                              } else {
                                await _player.youtubeStop();
                                StaticStore.queueIndex = position;
                                StaticStore.currentSong =
                                    _queueTracks[position].name!;
                                StaticStore.currentSongImg =
                                    _queueTracks[position].imgUrl!;
                                StaticStore.currentArtists = List.from(
                                    _queueTracks[position].trackArtists ?? []);

                                await _player
                                    .youtubePlay(
                                        _queueTracks[position].name,
                                        _queueTracks[position].trackArtists?[0],
                                        position)
                                    .then((value) {
                                  // StaticStore.queueIndex = position;
                                  // StaticStore.currentSong = _queueTracks[position].name!;
                                  // StaticStore.currentSongImg = _queueTracks[position].imgUrl!;
                                  // StaticStore.currentArtists = List.from(_queueTracks[position].trackArtists??[]);

                                  Navigator.pop(context);

                                  Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CarouselSongScreen(
                                      _queueTracks[position].name,
                                      _queueTracks[position].id,
                                      _queueTracks[position].trackArtists,
                                      _queueTracks[position].imgUrl)));

                                  // int countOfScreens=0;
                                  // Navigator.popUntil(context, CarouselSongScreen());

                                  // Navigator.of(context).pushAndRemoveUntil(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => CarouselSongScreen(
                                  //         _queueTracks[position].name,
                                  //         _queueTracks[position].id,
                                  //         _queueTracks[position].trackArtists,
                                  //         _queueTracks[position].imgUrl),
                                  //   ),
                                  //   (Route<dynamic> route){return countOfScreens++>=1;},
                                  // );
                                });
                              }
                            }
                          },
                          child: ListTile(
                            leading: Column(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(3),
                                  bottomLeft: Radius.circular(3),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: "${_queueTracks[position].imgUrl}",
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
                                  progressIndicatorBuilder: (context, url, l) =>
                                      const LoadingImage(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ]),
                            title: Text(
                              "${_queueTracks[position].name}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: _queueTracks != [] &&
                                    _queueTracks[position].trackArtists !=
                                        null &&
                                    _queueTracks[position]
                                            .trackArtists!
                                            .length >
                                        1
                                ? Text(
                                    '${_queueTracks[position].trackArtists?[0]}, ${_queueTracks[position].trackArtists?[1]}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white70))
                                : Text(
                                    '${_queueTracks[position].trackArtists?[0]}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white70)),
                            isThreeLine: true,
                            trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      playPauseAlbumButton(
                                          _queueTracks, position),
                                      StreamBuilder<Object>(
                                          stream: StaticStore
                                              .player.playerStateStream,
                                          builder: (context, snapshot) {
                                            return IconButton(
                                                onPressed: () {
                                                  if (_queueTracks[position]
                                                          .name !=
                                                      StaticStore.currentSong) {
                                                    StaticStore.myQueueTrack
                                                        .removeAt(position);
                                                  }
                                                },
                                                icon: _queueTracks[position]
                                                            .name !=
                                                        StaticStore.currentSong
                                                    ? const Icon(
                                                        Icons.delete,
                                                        color: Colors.grey,
                                                      )
                                                    : SizedBox());
                                          }),
                                    ],
                                  )
                                ]),
                          ),
                        ),
                      ]),
                    ),
                    // ),

                    // }),),
                  ]);
                },
              ),
        onNotification: (t) {
          if (t is ScrollEndNotification) {}
          if (_scrollController.position.pixels > mq.height) {
            print("hi");
          }
          print(_scrollController.position);
          WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
          _counter = _scrollController.position.pixels;
          print(_counter);
          return true;
        },
      ),
    );
  }
}
