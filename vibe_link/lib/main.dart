import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vibe_link/controller/login/login.dart';
import 'package:vibe_link/controller/local_songs/get_local_songs/permission/permission_handler.dart';
import 'package:vibe_link/view/Login/login_screen.dart';
import 'package:vibe_link/view/home/bottom_nav_bar.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  SongDataController c = SongDataController();
  LoginPage loginController = LoginPage();
  List<SongModel> localSongs = [];

  @override
  void initState() {
    super.initState();
    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>loginScreen()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  LoginPage _loginController = LoginPage();
  var res=0;
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home:
      // Container(
      //   height: 100,
      //   width: 100,
      //   color: Colors.red,
      // ),
      // MaterialApp(
      title: 'Linkify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Proxima',
        canvasColor: Colors.transparent,
        shadowColor: Colors.transparent,
        highlightColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.black,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        progressIndicatorTheme: ProgressIndicatorThemeData(
          circularTrackColor: Colors.greenAccent[700],
          color: Colors.greenAccent[400],
          linearMinHeight: 10,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Proxima Bold',
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        primarySwatch: Colors.blue,
      ),

      home: FutureBuilder(future: _loginController.getLoginStatus(), 
        builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              // while data is loading:
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              // data loaded:
              final status = snapshot.data;
              return status==1?App():LoginScreen();
            }
          },
        ),
    );
  }
}
