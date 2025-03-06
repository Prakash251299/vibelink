// my api key:- AIzaSyBERpvDh6R8JMFdBowOTgdqLRKIgXutzBk


import 'dart:convert';
// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vibe_link/controller/player/play_song.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
// import 'package:linkify/controller/notification/background.dart';
// import 'package:linkify/controller/player/play_song.dart';
// import 'package:linkify/controller/variables/static_store.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
// import 'package:http/http.dart' as http;
// import 'package:html/dom.dart' as dom;



class YoutubeSongPlayer{
  Future<void> youtubePlay(String? songName,String artist) async {
    print("youtube play song");
    print(StaticStore.myQueueTrack);
    print("youtube songName");
    print(songName);
    // StaticStore.queueIndex
    if(songName==null){
      print("Song name is not given to youtube play function");
      return;
    }
    if(songName!=""){
      songName+=" $artist lyrical";
        try{
          final yt = YoutubeExplode();
          print("songName $songName");
          final video = (await yt.search.search(songName)).first;
          // print("1a");
          final videoId = video.id.value;
          print("2a videoid - $videoId");
          // var manifest = await yt.videos.streams.getManifest(videoId);
          var manifest = await yt.videos.streams.getManifest(videoId,ytClients: [
            YoutubeApiClient.safari,
            YoutubeApiClient.androidVr  
          ]);
          print("3a");
          print(manifest.streams.first);
          var audio = await manifest.audioOnly.first;
          var audioUrl = await audio.url;
          print("audio url");
          print(audioUrl);
          playSong(audioUrl);
          StaticStore.nextPlay=1;
        }
        catch(e){
          print("Youtube player can't play songs $e");
        }
      }
  }


  Future<void> youtubePause() async {
    StaticStore.player.pause();
  }
  Future<void> youtubeStop() async {
    StaticStore.player.stop();
  }
  Future<void> youtubeResume() async {
    StaticStore.player.play();
  }

}