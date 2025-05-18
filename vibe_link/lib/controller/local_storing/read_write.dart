import 'dart:async';
import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:linkify/controller/Authorization/webview.dart';
import 'package:path_provider/path_provider.dart';

// class CounterStorage {
  
// }

class ReadWrite{

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFileAccessToken async {
    final path = await _localPath;

    return File('$path/accessToken.txt');
  }


  Future<String> getAccessToken() async {
    try {
      final file = await _localFileAccessToken;

      // Read the file
      final accessToken = await file.readAsString();
      return accessToken;
    } catch (e) {
      // If encountering an error, return ""
      return "";
    }
  }

  Future<void> writeAccessToken(String accessToken) async {
    final file = await _localFileAccessToken;

    // Write the file
    file.writeAsString(accessToken);
  }

  Future<File> get _localFileRefreshToken async {
    final path = await _localPath;
    // print(path);

    return File('$path/refreshToken.txt');
  }
  Future<File> get _localEmailId async {
    final path = await _localPath;
    // print(path);

    return File('$path/email.txt');
  }

  Future<File> get _localDate async {
    final path = await _localPath;
    // print(path);

    return File('$path/date.txt');
  }

  Future<void> writeRefreshToken(String refreshToken) async {
    final file = await _localFileRefreshToken;

    // Write the file
    file.writeAsString(refreshToken);
  }
  
  Future<void> writeEmail(String email) async {
    final file = await _localEmailId;

    // Write the file
    file.writeAsString(email);
  }
  Future<void> writeDate(String date) async {
    final file = await _localDate;

    // Write the file
    file.writeAsString(date);
  }


  Future<String> getRefreshToken()async{
    try {
      final file = await _localFileRefreshToken;

      // Read the file
      final refreshToken = await file.readAsString();
      return refreshToken;
    } catch (e) {
      return "";
    }
  }
  Future<String> getEmail()async{
    try {
      final file = await _localEmailId;

      // Read the file
      final email = await file.readAsString();
      return email;
    } catch (e) {
      return "";
    }
  }
  Future<String> getDate()async{
    try {
      final file = await _localDate;

      // Read the file
      final date = await file.readAsString();
      return date;
    } catch (e) {
      return "";
    }
  }


  // Future<String> getAccessToken()async{
  //   return await readData();
  // }

}