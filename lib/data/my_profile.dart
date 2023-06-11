import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pineapple_tok/data/profile.dart';

class MyProfile extends Profile {
  MyProfile(String thumbnail, String background, String name, String comment)
      : super(thumbnail, background, name, comment);

  factory MyProfile.getMyProfile(String thumbnail, String background, String name, String comment) {
    if (thumbnail == '') {
      thumbnail = 'assets/basic_profile_picture.png';
    }

    return MyProfile(thumbnail, background, name, comment);
  }
}

class MyProfileHandler {
  final _authentication = FirebaseAuth.instance;

  Future<MyProfile> updateMyProfile() async {
    final curUser = _authentication.currentUser;

    String jsonData = await rootBundle.loadString('dummy_data/user_profile.json');
    dynamic parsingData = jsonDecode(jsonData);

    String thumbnail = '';
    String background = '';
    String name = '';
    String comment = '';
    for (var x in parsingData['user_profile']) {
      if (x['uid'] == curUser!.uid) {
        thumbnail = x['thumbnail'];
        background = x['background'];
        name = x['name'];
        comment = x['comment'];

        break;
      }
    }

    return MyProfile.getMyProfile(thumbnail, background, name, comment);
  }
}