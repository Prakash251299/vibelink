import 'dart:async';

import 'package:just_audio/just_audio.dart';
// import 'package:linkify/model/home/first_page_categories.dart';
// import 'package:linkify/model/album_track.dart';
// import 'package:linkify/model/user_info.dart';
import 'package:spotify/spotify.dart';
import 'package:vibe_link/model/album_track.dart';
import 'package:vibe_link/model/home/first_page_categories.dart';

class StaticStore{
  static var carouselLength = 6;
  static List<List<AlbumTrack>>trackInfo=[
    [],
    [],
    [],
    [],
    [],
    []
  ];
  static List<String> userGenre = [];
  static Map<dynamic,dynamic>? userGenreWithCount;
  static Map<dynamic,dynamic>? userGenreWithDistributedPercentage;
  static String dateStored = "1-1-2024";
  static String dateStored2 = "1-1-2024";
  static var carouselInd = -10;
  static var playingCarouselInd = -10;
  static var playing = false;
  static var currentSong = "";
  static var currentSongImg = "";
  static var currentArtists = [];
  static var pause = false;
  static AudioPlayer player = AudioPlayer();
  static var musicScreenEnabled = false;
  static String userSelectedArtists=""; // this string is comma separated artists name
  static String? currentUserGenreId="";
  static String? currentUserId="";
  static String? currentUserName="";
  static String? currentUserEmail="";
  static String? currentUserCountry="";
  // static List<dynamic>? currentUserImage=[];
  static String? currentUserImageUrl="";
  static int videoPlayingIndex = -1;
  static List<FrontPageCategories>categoryInfo=[];
  static List<AlbumTrack> myQueueTrack=[];
  static int queueIndex = 0;
  static int queueLoaded = 0;
  static int screen = 0;
  static List<List<String>?>? requestStatusValue=[[],[],[]];
  static int notificationCounts=0;
  static double miniplayerMargin=50;
  static int songIndex=0;
  static String country = 'IN';
  static var playlist = ConcatenatingAudioSource(
        children: [],
      );
  // static int nextPlay=1;
  static final StreamController<int> _nextPlayController =
      StreamController<int>.broadcast();

  static Stream<int> get nextPlayStream => _nextPlayController.stream;

  static int _nextPlay = 1;

  static int get nextPlay => _nextPlay;

  static void setNextPlay(int value) {
    _nextPlay = value;
    _nextPlayController.add(value);
  }

  static void disposeStreams() {
    _nextPlayController.close();
  }
}