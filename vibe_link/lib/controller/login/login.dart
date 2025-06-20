// import 'package:linkify/controller/song_data_contoller.dart';
// import 'dart:convert';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:vibe_link/controller/Authorization/webview.dart';
import 'package:vibe_link/controller/local_storing/read_write.dart';

import 'package:spotify/spotify.dart';
import 'package:vibe_link/controller/firebase/firebase_call.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/view/home/bottom_nav_bar.dart';
import 'package:vibe_link/view/pick_artists.dart';
// import 'package:vibe_link/view/pick_artists.dart';
// import 'package:linkify/controller/local_storing/read_write.dart';
// import 'package:linkify/controller/Authorization/webview.dart';

class LoginPage {
  FirebaseFirestore con = FirebaseFirestore.instance;
  ReadWrite _readWrite = ReadWrite();
  // void storeLoginTime(){
  //   FirebaseFirestore.instance
  //     .collection('users')
  //     .doc(userId)
  //     .update({'lastActive': FieldValue.serverTimestamp()});
  // }
  void uploadToFirestore(userId) {
    FirebaseFirestore.instance.collection('users').doc(userId).update(
        {'lastActive': FieldValue.serverTimestamp()}).catchError((error) {
      print('Upload login time failed: $error');
    });
  }

  Future<int> getLoginStatus() async {
    // print('came in getLoginStatus');
    if (await _readWrite.getEmail() == "") {
      return 0;
    }
    String email = await _readWrite.getEmail();
    uploadToFirestore(email);
    print('checking');
    return 1;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<int> userExists(email) async {
    // var res = await con.collection('users').get(email);
    // print(res);
    try {
      // Reference to Firestore
      var collection = FirebaseFirestore.instance.collection('users');

      // Query to check if a document with email ID exists
      var querySnapshot =
          await collection.where('email', isEqualTo: email).get();

      // Return true if a document is found, otherwise false
      if (querySnapshot.docs.isNotEmpty == true) {
        return 1;
      }

      return 0;
    } catch (e) {
      print("Error checking user existence: $e");
      return 0;
    }
    // return 0;
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> login(context) async {
    /* Storing accessToken */
    String clientId = '97c3e7bd62554a2089e037cb7c1f8836';
    String clientSecret = 'b6609e7258154766822ca43565fa8932';
    final credentials = SpotifyApiCredentials(clientId, clientSecret);
    final spotify = SpotifyApi(credentials);
    final accessToken = (await spotify.getCredentials()).accessToken;
    // print(accessToken);
    if (accessToken != null) {
      await _readWrite.writeAccessToken(accessToken);
    }

    /* Firebase login/signup process */
    UserCredential? user;
    LoginPage _loginController = LoginPage();
    if (await _loginController.getLoginStatus() == 0) {
      user = await signInWithGoogle();
      await _readWrite.writeEmail((user.user?.email).toString());
      // store date too in local storage here
      DateTime now = DateTime.now();
      String date = '${now.day}/${now.month}/${now.year}';
      await _readWrite.writeDate(date);
      await requestNotificationPermission();
      if (await userExists(user.user?.email) == 0) {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              PickArtistPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration:
              Duration(milliseconds: 400), // Smooth fade duration
        ));
        return;
      }
    }
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const App(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
      // MaterialPageRoute(
      //     builder: (context) => const App()), // Replace with your screen
      (Route<dynamic> route) => false, // This removes all previous routes
    );
  }
}
