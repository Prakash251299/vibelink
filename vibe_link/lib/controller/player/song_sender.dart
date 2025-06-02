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