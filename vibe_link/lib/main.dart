import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio_background/just_audio_background.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:vibe_link/controller/login/login.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
// import 'package:vibe_link/controller/local_songs/get_local_songs/permission/permission_handler.dart';
import 'package:vibe_link/model/search/song_model.dart';
import 'package:vibe_link/view/Login/login_screen.dart';
import 'package:vibe_link/view/home/bottom_nav_bar.dart';
import 'package:vibe_link/view/splash_screen/splash_screen.dart';
// import 'package:on_audio_query/on_audio_query.dart';

void main() async {
  // requestNotificationPermission();
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.vibelink.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,

  );

  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  
  // runApp(MyApp());
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // SongDataController c = SongDataController();
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

  // LoginPage _loginController = LoginPage();
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
      title: 'Vibe_link',
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

      home: FutureBuilder(future: loginController.getLoginStatus(), 
        builder: (BuildContext context, snapshot) {
          print('main is fine');
          print(snapshot.data);
            if (!snapshot.hasData) {
              // while data is loading:
              return MaterialApp(home: 
                Container(
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              );
              // return SplashScreen();
              // Center(
              //   child: CircularProgressIndicator(),
              // );
            } else {
              // data loaded:
              
              final status = snapshot.data;
              // status=1 means user is installed the app already and data is fetched
              // status=0 mwans either user is new or has unintalled the app
              return status==1?App():LoginScreen();
            }
          },
        ),
    );
  }
}
