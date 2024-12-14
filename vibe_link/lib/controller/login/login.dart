// import 'package:linkify/controller/song_data_contoller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:vibe_link/controller/Authorization/webview.dart';
import 'package:vibe_link/controller/local_storing/read_write.dart';

import 'package:spotify/spotify.dart';
import 'package:vibe_link/controller/store_to_firebase/firebase_call.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/view/home/bottom_nav_bar.dart';
import 'package:vibe_link/view/pick_artists.dart';
// import 'package:vibe_link/view/pick_artists.dart';
// import 'package:linkify/controller/local_storing/read_write.dart';
// import 'package:linkify/controller/Authorization/webview.dart';

class LoginPage{
  FirebaseFirestore con = FirebaseFirestore.instance;
  ReadWrite _readWrite = ReadWrite();
  Future<int> getLoginStatus() async {
    // print('came in getLoginStatus');
    if(await _readWrite.getEmail()==""){
      return 0;
    }
    // FirebaseCall _firebaseCall = FirebaseCall();

    // // if date more than 2 then
    // DateTime now = DateTime.now();
    // String date = '${now.day}/${now.month}/${now.year}';
    // // fetching stored date
    // String dateStored = await  _readWrite.getDate();

    // DateTime date1 = DateTime.parse(date);
    // DateTime date2 = DateTime.parse(dateStored);
    
    // // Calculate the difference
    // Duration difference = date2.difference(date1);
    


    // if(difference.inDays>2){
    //  _readWrite.writeDate(date);
    //   await _firebaseCall.getUserArtistsWithGenrePercentage();
    //   await _firebaseCall.storeUserWithGenrePercentage();
    // }
    print('checking');
    return 1;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<int> userExists(email)async{
    // var res = await con.collection('users').get(email);
    return 0;
  }
  
  Future<void> login(context)async {
    /* Storing accessToken */
    String clientId = '97c3e7bd62554a2089e037cb7c1f8836';
    String clientSecret = 'b6609e7258154766822ca43565fa8932';
    final credentials = SpotifyApiCredentials(clientId, clientSecret);
    final spotify = SpotifyApi(credentials);
    final accessToken = (await spotify.getCredentials()).accessToken;
    // print(accessToken);
    if(accessToken!=null){
      await _readWrite.writeAccessToken(accessToken);
    }

    /* Firebase login/signup process */
    UserCredential? user;
    LoginPage _loginController = LoginPage();
    if(await _loginController.getLoginStatus()==0){
      user = await signInWithGoogle();
      await _readWrite.writeEmail((user.user?.email).toString());
      // store date too in local storage here
      DateTime now = DateTime.now();
      String date = '${now.day}/${now.month}/${now.year}';
      await _readWrite.writeDate(date);
      if(await userExists(user.user?.email)==0){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const PickArtistPage()));
        return;

      }
    }
    Navigator.pop(context); // For removing the previous login screen
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const App()));
  }
}