import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:pineapple_tok/data/profile.dart';
import 'dart:async';

class MyProfile extends Profile {
  MyProfile(String picturePath, String name) : super(picturePath, name);

  factory MyProfile.getMyProfile(String picturePath, String name) {
    return MyProfile(picturePath, name);
  }
}

class MyProfileHandler {
  Future<MyProfile> updateMyProfile() async {
    String jsonData = await rootBundle.loadString('dummy_data/my_profile.txt');
    dynamic parsingData = jsonDecode(jsonData);
    return MyProfile.getMyProfile(parsingData['myProfile']['picturePath'], parsingData['myProfile']['name']);
  }
}