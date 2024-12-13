// import 'package:linkify/controller/song_data_contoller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:vibe_link/controller/Authorization/webview.dart';
import 'package:vibe_link/controller/local_storing/read_write.dart';

import 'package:spotify/spotify.dart';
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
    if(await _readWrite.getEmail()==""){
      return 0;
    }
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
    return 1;
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
      if(await userExists(user.user?.email)==0){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const PickArtistPage()));
      }
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const App()));








    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PickArtistPage()));

  }
}