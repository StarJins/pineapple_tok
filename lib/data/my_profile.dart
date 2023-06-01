import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:pineapple_tok/data/profile.dart';
import 'dart:async';

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
  final currentId;

  MyProfileHandler(this.currentId);

  Future<MyProfile> updateMyProfile() async {
    String jsonData = await rootBundle.loadString('dummy_data/user_profile.json');
    dynamic parsingData = jsonDecode(jsonData);

    String thumbnail = '';
    String background = '';
    String name = '';
    String comment = '';
    for (var x in parsingData['user_profile']) {
      if (x['id'] == this.currentId) {
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