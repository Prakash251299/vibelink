// my api key:- AIzaSyBERpvDh6R8JMFdBowOTgdqLRKIgXutzBk


import 'dart:convert';
// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:audio_session/audio_session.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vibe_link/controller/player/play_song.dart';
import 'package:vibe_link/controller/player/song_url_getter.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
// import 'package:linkify/controller/notification/background.dart';
// import 'package:linkify/controller/player/play_song.dart';
// import 'package:linkify/controller/variables/static_store.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
// import 'package:http/http.dart' as http;
// import 'package:html/dom.dart' as dom;



class YoutubeSongPlayer{
  SongUrlGetter _songUrlGetter = SongUrlGetter();
  Future<void> youtubePlay(String? songName,String artist,ind) async {
    // int ind = 0;
    StaticStore.player.playerStateStream.listen((state) async {
      if (state.processingState == ProcessingState.completed) {
        print("song completed bro");
        StaticStore.nextPlay=0;
        // StaticStore.songIndex;
        // StaticStore.songIndex++;
        // int ind = StaticStore.songIndex;
        // ind = StaticStore.songIndex;
        ind++;
        if(ind<StaticStore.myQueueTrack.length){
          String? nextSong = StaticStore.myQueueTrack[ind].name??"";
          String? nextSongArtist1 = StaticStore.myQueueTrack[ind].trackArtists!=null?(StaticStore.myQueueTrack[ind].trackArtists?[0]):"";
          String? nextSongArtist2 = StaticStore.myQueueTrack[ind].trackArtists!=null &&StaticStore.myQueueTrack[ind].trackArtists!.length>=2?(StaticStore.myQueueTrack[ind].trackArtists?[1]):"";
          String? nextSongImage = StaticStore.myQueueTrack[ind].imgUrl;
          Uri nextUrl;
            nextUrl = await _songUrlGetter.fetchSongUrl("$nextSong", "$nextSongArtist1");
        

          StaticStore.playlist.add(AudioSource.uri(
              // Uri.parse(songUrl),
              nextUrl,
              tag: MediaItem(
                // Specify a unique ID for each media item:
                id: '$ind',
                artist: "${nextSongArtist1} ${nextSongArtist2}",
                title: "${nextSong}",
                artUri: nextSongImage!=null?Uri.parse(nextSongImage):Uri.parse(""),
              ),
            ),);










        }else{
          print("no songs to play next");
        }
        StaticStore.nextPlay=1;

      }
      if (state.processingState == ProcessingState.idle) {
        print("hi");
      }
    });

    
    print("youtube play song");
    // print(StaticStore.myQueueTrack);
    print("youtube songName");
    print(songName);
    // StaticStore.queueIndex
    if(songName==null){
      print("Song name is not given to youtube play function");
      return;
    }
    var videoId;
    if(songName!=""){
      songName = "$songName $artist lyrical";
        try{
          final yt = YoutubeExplode();
          print("songName $songName");
          final video = (await yt.search.search(songName)).first;
          // print("1a");
          videoId = video.id.value;
          print("2a videoid - $videoId");
          print(StaticStore.myQueueTrack[0]);
          // var manifest = await yt.videos.streams.getManifest(videoId);
          var manifest = await yt.videos.streams.getManifest(videoId,
            // ytClients: [
            //   YoutubeApiClient.safari,
            //   YoutubeApiClient.androidVr  
            // ]
          );
          print("3a");
          print(manifest.streams.first);
          var audio = await manifest.audioOnly.first;
          // var audio = manifest.audioOnly.where((s) => s.codec('mp4')).firstOrNull;
          if(audio.toString().contains('mp4')==false){
            print("bad url");
            return;
          }
          Uri audioUrl = await audio.url;
          print("audio url");
          print(audioUrl);

          StaticStore.playlist.add(AudioSource.uri(
            // Uri.parse(songUrl),
            audioUrl,
            // headers: headers,
            tag: MediaItem(
              // Specify a unique ID for each media item:
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              artist: StaticStore.currentArtists.length>=2?"${StaticStore.currentArtists[0]}, ${StaticStore.currentArtists[1]}":StaticStore.currentArtists.length==1?"${StaticStore.currentArtists[0]}":"unknown",
              title: "${StaticStore.currentSong}",
              // artUri: Uri.parse(StaticStore.currentSongImg),
              artUri: StaticStore.myQueueTrack[ind].imgUrl!=null?Uri.parse(StaticStore.myQueueTrack[ind].imgUrl!):Uri.parse(""),
            ),
          ),);
          // playSong(audioUrl);
          if (StaticStore.player.audioSource == null) {
            await StaticStore.player.setAudioSource(StaticStore.playlist);
            // print("audiosource null");
          }
          // var _isConnected = false;
          // var _connectionSubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          //   _isConnected = (result != ConnectivityResult.none);
          //   if (_isConnected) {
          //     print("Internet is back, try to resume audio");
          //     // Retry playing
          //     if (StaticStore.player.playing == false && StaticStore.player.audioSource != null) {
          //       StaticStore.player.play();
          //     }
          //   }
          // });


          StaticStore.player.play();
          StaticStore.nextPlay=1;
        
        }
        catch(e){
          print("FirstPlayer: Youtube player can't play songs error: $e");

          /* Trying again to play the song */
          try{
            print("came to play again the song");
            final yt = YoutubeExplode();
            var manifest = await yt.videos.streams.getManifest(videoId,
            ytClients: [
              YoutubeApiClient.safari,
              YoutubeApiClient.androidVr  
            ]
          );
          print("3a");
          print(manifest.streams.first);
          var audio = await manifest.audioOnly.first;
          // var audio = manifest.audioOnly.where((s) => s.codec('mp4')).firstOrNull;
          if(audio.toString().contains('mp4')==false){
            print("bad url");
            return;
          }
          Uri audioUrl = await audio.url;
          print("audio url");
          print(audioUrl);

          StaticStore.playlist.add(AudioSource.uri(
            // Uri.parse(songUrl),
            audioUrl,
            // headers: headers,
            tag: MediaItem(
              // Specify a unique ID for each media item:
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              artist: StaticStore.currentArtists.length>=2?"${StaticStore.currentArtists[0]}, ${StaticStore.currentArtists[1]}":StaticStore.currentArtists.length==1?"${StaticStore.currentArtists[0]}":"unknown",
              title: "${StaticStore.currentSong}",
              artUri: Uri.parse(StaticStore.currentSongImg),
            ),
          ),);
          // playSong(audioUrl);
          if (StaticStore.player.audioSource == null) {
            await StaticStore.player.setAudioSource(StaticStore.playlist);
            // print("audiosource null");
          }
          // var _isConnected = false;
          // var _connectionSubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          //   _isConnected = (result != ConnectivityResult.none);
          //   if (_isConnected) {
          //     print("Internet is back, try to resume audio");
          //     // Retry playing
          //     if (StaticStore.player.playing == false && StaticStore.player.audioSource != null) {
          //       StaticStore.player.play();
          //     }
          //   }
          // });


          StaticStore.player.play();
          StaticStore.nextPlay=1;


          }catch(e){
            print("failed even after changing the youtube api call method with error: $e");
          }

        }
        }
      // }
    // });
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