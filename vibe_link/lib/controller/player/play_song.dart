import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
// import 'package:linkify/controller/variables/static_store.dart';

Future<void> playSong(songUrl) async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    StaticStore.player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      // await StaticStore.player.setUrl(songUrl);


      await StaticStore.player.setAudioSource(AudioSource.uri(
        // Uri.parse(songUrl),
        songUrl,
        tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '1',
        artist: StaticStore.currentArtists.length>=2?"${StaticStore.currentArtists[0]}, ${StaticStore.currentArtists[1]}":StaticStore.currentArtists.length==1?"${StaticStore.currentArtists[0]}":"unknown",
        title: "${StaticStore.currentSong}",
        artUri: Uri.parse(StaticStore.currentSongImg),
      ),
      ));
      // await StaticStore.player.setLoopMode(LoopMode.all); // Enables auto-next
      // await StaticStore.player.; // Enables auto-next
      StaticStore.player.play();
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      print("Error loading playlist: $e");
      print(stackTrace);
    }
  }