import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pineapple_tok/data/profile.dart';

class Friend extends Profile {
  String uid;
  Friend(this.uid, String thumbnail, String background, String name, String comment)
      : super(thumbnail, background, name, comment);

  factory Friend.getFriendProfile(String uid, String thumbnail, String background, String name, String comment) {
    if (thumbnail == '') {
      thumbnail = 'assets/basic_profile_picture.png';
    }

    return Friend(uid, thumbnail, background, name, comment);
  }
}

class FriendHandler {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<List<String>> getFriendsList() async {
    final curUser = _authentication.currentUser;

    final docRef = _firestore.collection('user').doc('friends')
        .collection('data').doc(curUser!.uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      return [];
    }

    List<String> friendList = [];
    for (var x in doc['friends']) {
      friendList.add(x);
    }

    return friendList;
  }

  Future<List<Friend>?> updateFriendList() async {
    final collectionRef = _firestore.collection('user').doc('profiles')
      .collection('data');
    final querySnapshot = await collectionRef.get();

    List<String> friendIdList = await getFriendsList();

    List<Friend> friendList = [];
    for (var doc in querySnapshot.docs) {
      if (friendIdList.contains(doc.id)) {
        String thumbnail = doc['thumbnail'];
        String background = doc['background'];
        String name = doc['name'];
        String comment = doc['comment'];

        print(doc.id);
        friendList.add(Friend.getFriendProfile(doc.id, thumbnail, background, name, comment));
      }
    }

    if (friendList.length == 0) {
      return null;
    }
    else {
      return friendList;
    }
  }

  Future<List<Friend>?> updateNewFriendList() async {
    final collectionRef = _firestore.collection('user').doc('profiles')
        .collection('data');
    final querySnapshot = await collectionRef.get();
    final curUser = _authentication.currentUser;

    List<Friend> newFriendList = [];
    for (var doc in querySnapshot.docs) {
      if (doc.id != curUser!.uid) {
        String thumbnail = doc['thumbnail'];
        String background = doc['background'];
        String name = doc['name'];
        String comment = doc['comment'];

        print(doc.id);
        newFriendList.add(Friend.getFriendProfile(doc.id, thumbnail, background, name, comment));
      }
    }

    if (newFriendList.length == 0) {
      return null;
    }
    else {
      return newFriendList;
    }
  }
}