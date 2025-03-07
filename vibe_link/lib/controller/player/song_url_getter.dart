import 'package:vibe_link/controller/player/play_song.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SongUrlGetter {
  Future<Uri>fetchSongUrl(String songName,String artist)async{
    Uri audioUrl=Uri();
    if(songName==""){
      print("Song name is not given to youtube play function");
      return audioUrl;
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
          var manifest = await yt.videos.streams.getManifest(videoId,
            // ytClients: [
            //   YoutubeApiClient.safari,
            //   YoutubeApiClient.androidVr  
            // ]
          );
          // var manifest = await yt.videos.streams.getManifest(videoId);
          print("3a");
          print(manifest.streams.first);
          var audio = await manifest.audioOnly.first;
          audioUrl = await audio.url;
          print("audio url");
          print(audioUrl);
          return audioUrl;
        }
        catch(e){
          print("Youtube player can't play songs $e");
        }
      }
    return audioUrl;
  }
}