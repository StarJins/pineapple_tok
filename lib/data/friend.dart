import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _firestore = FirebaseFirestore.instance;

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
    final collectionRef = _firestore.collection('user').doc('Pcb6GpXLiBuBQtXXG1Vc').collection('profile');
    final querySnapshot = await collectionRef.get();

    List<String> friendIdList = await getFriendsList();

    List<Friend> friendList = [];
    for (var doc in querySnapshot.docs) {
      if (friendIdList.contains(doc['uid'])) {
        String thumbnail = doc['thumbnail'];
        String background = doc['background'];
        String name = doc['name'];
        String comment = doc['comment'];
        friendList.add(Friend.getFriendProfile(thumbnail, background, name, comment));
      }
    }
    return friendList;
  }
}