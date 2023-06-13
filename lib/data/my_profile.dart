import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _firestore = FirebaseFirestore.instance;

  Future<MyProfile?> updateMyProfile() async {
    final curUser = _authentication.currentUser;

    final docRef = _firestore.collection('user').doc('profiles')
      .collection('data').doc(curUser!.uid);
    final doc = await docRef.get();

    if (doc.exists) {
      String thumbnail = doc['thumbnail'];
      String background = doc['background'];
      String name = doc['name'];
      String comment = doc['comment'];
      return MyProfile.getMyProfile(thumbnail, background, name, comment);
    }
    else {
      return null;
    }
  }
}