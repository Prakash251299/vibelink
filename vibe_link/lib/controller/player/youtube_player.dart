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
  Future<void> youtubePlay(String? songName,String artist) async {
    int ind = 0;
    StaticStore.player.playerStateStream.listen((state) async {
      if (state.processingState == ProcessingState.completed) {
        print("song completed bro");
        StaticStore.nextPlay=0;
        StaticStore.songIndex++;
        ind++;
        if(ind<StaticStore.myQueueTrack.length){
          String? nextSong = StaticStore.myQueueTrack[ind].name??"";
          String? nextSongArtist = StaticStore.myQueueTrack[ind].trackArtists?[0]??"";
          Uri nextUrl = await _songUrlGetter.fetchSongUrl("$nextSong", "$nextSongArtist");
          StaticStore.playlist.add(AudioSource.uri(
              // Uri.parse(songUrl),
              nextUrl,
              tag: MediaItem(
                // Specify a unique ID for each media item:
                id: '$ind',
                artist: StaticStore.currentArtists.length>=2?"${StaticStore.currentArtists[0]}, ${StaticStore.currentArtists[1]}":StaticStore.currentArtists.length==1?"${StaticStore.currentArtists[0]}":"unknown",
                title: "${StaticStore.currentSong}",
                artUri: Uri.parse(StaticStore.currentSongImg),
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
    if(songName!=""){
      songName = "$songName $artist lyrical";
        try{
          final yt = YoutubeExplode();
          print("songName $songName");
          final video = (await yt.search.search(songName)).first;
          // print("1a");
          final videoId = video.id.value;
          print("2a videoid - $videoId");
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

          // await callFun(audioUrl);
          // StaticStore.nextPlay=1;
          // return;
          // final headers = {
          //   'User-Agent': 'Mozilla/5.0',
          //   'Accept-Language': 'en',
          //   'Referer': 'https://www.youtube.com/'
          // };
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

          StaticStore.player.play();
          StaticStore.nextPlay=1;
        
        }
        catch(e){
          print("Youtube player can't play songs $e");
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