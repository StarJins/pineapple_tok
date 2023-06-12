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

  Future<MyProfile> updateMyProfile() async {
    final curUser = _authentication.currentUser;

    final collectionRef = _firestore.collection('user').doc('Pcb6GpXLiBuBQtXXG1Vc').collection('profile');
    final querySnapshot = await collectionRef.get();

    String thumbnail = '';
    String background = '';
    String name = '';
    String comment = '';
    for (var doc in querySnapshot.docs) {
      if (doc['uid'] == curUser!.uid) {
        thumbnail = doc['thumbnail'];
        background = doc['background'];
        name = doc['name'];
        comment = doc['comment'];

        break;
      }
    }

    return MyProfile.getMyProfile(thumbnail, background, name, comment);
  }
}