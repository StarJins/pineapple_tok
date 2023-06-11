import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pineapple_tok/data/profile.dart';

class Friend extends Profile {
  Friend(String thumbnail, String background, String name, String comment)
      : super(thumbnail, background, name, comment);

  factory Friend.getFriendProfile(String thumbnail, String background, String name, String comment) {
    if (thumbnail == '') {
      thumbnail = 'assets/basic_profile_picture.png';
    }

    return Friend(thumbnail, background, name, comment);
  }
}

class FriendHandler {
  final _authentication = FirebaseAuth.instance;

  Future<List<String>> getFriendsList() async {
    final curUser = _authentication.currentUser;

    String jsonData = await rootBundle.loadString('dummy_data/user_friends.json');
    dynamic parsingData = jsonDecode(jsonData);

    List<String> friendList = [];
    for (var x in parsingData['user_friends']) {
      if (x['uid'] == curUser!.uid) {
        for (var y in x['friends']) {
          friendList.add(y);
        }
      }
    }

    return friendList;
  }

  Future<List<Friend>> updateFriendList() async {
    String jsonData = await rootBundle.loadString('dummy_data/user_profile.json');
    dynamic parsingData = jsonDecode(jsonData);

    List<String> friendIdList = await getFriendsList();

    List<Friend> friendList = [];
    for (var x in parsingData['user_profile']) {
      if (friendIdList.contains(x['uid'])) {
        String thumbnail = x['thumbnail'];
        String background = x['background'];
        String name = x['name'];
        String comment = x['comment'];
        friendList.add(Friend.getFriendProfile(thumbnail, background, name, comment));
      }
    }
    return friendList;
  }
}