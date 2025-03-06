import 'package:just_audio/just_audio.dart';
import 'package:vibe_link/controller/player/play_song.dart';
import 'package:vibe_link/controller/player/song_url_getter.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/model/album_track.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SongSender{

Future<void> send_to_play(List<AlbumTrack>songs, int index)async{
    print("youtube play song");
    // print(StaticStore.myQueueTrack);
    print("youtube songName");
    String? songName = songs[index].name;
    String artist=songs[index].trackArtists?[0];
    // print(songs[0].name);
    // StaticStore.queueIndex
    Uri? nextUrl;
    Uri? currentUrl;
    SongUrlGetter _songUrlGetter = SongUrlGetter();


     if (index < songs.length) {
          // if (currentUrl == null) {
            // If the next song is not ready, fetch it now
            currentUrl = await _songUrlGetter.fetchSongUrl(songs[index].name.toString(),songs[index].trackArtists?[0]);
          // }
          if(index+1 < songs.length){
            nextUrl = await _songUrlGetter.fetchSongUrl(songs[index+1].name.toString(),songs[index+1].trackArtists?[0]);
          }
        await playSong1(currentUrl,nextUrl,index);
     }

    // StaticStore.player.playerStateStream.listen((state) async {
    //   // if(state.processingState == ProcessingState.) {

    //   // }
    //   print("reached to play");
      // if (state.processingState == ProcessingState.completed) {
      //   print("song completed");
    //     StaticStore.songIndex++;
    //     index++;

        // if (index < songs.length) {
        //   if (nextUrl == null) {
        //     // If the next song is not ready, fetch it now
        //     nextUrl = await _songUrlGetter.fetchSongUrl(songs[index].name.toString(),songs[index].trackArtists?[0]);
        //   }

    //       if (nextUrl != null) {
    //         currentUrl = nextUrl;
            // await playSong(currentUrl);

    //         // Prefetch the next song for smoother playback
    //         nextUrl = (index + 1 < songs.length)
    //             ? await _songUrlGetter.fetchSongUrl(songs[index + 1].name.toString(),songs[index+1].trackArtists?[0])
    //             : null;
    //       }
    //     }
    //   }
    // });


    // if(songName==null){
    //   print("Song name is not given to youtube play function");
    //   return;
    // }
    // if(songName!=""){
    //   songName+=" $artist lyrical";
    //     try{
    //       final yt = YoutubeExplode();
    //       print("songName $songName");
    //       final video = (await yt.search.search(songName)).first;
    //       // print("1a");
    //       final videoId = video.id.value;
    //       print("2a videoid - $videoId");
    //       var manifest = await yt.videos.streams.getManifest(videoId);
    //       // var manifest = await yt.videos.streams.getManifest(videoId);
    //       print("3a");
    //       print(manifest.streams.first);
    //       var audio = await manifest.audioOnly.first;
    //       var audioUrl = await audio.url;
    //       print("audio url");
    //       print(audioUrl);
    //       playSong(audioUrl);
    //       StaticStore.nextPlay=1;
    //     }
    //     catch(e){
    //       print("Youtube player can't play songs $e");
    //     }
    //   }
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