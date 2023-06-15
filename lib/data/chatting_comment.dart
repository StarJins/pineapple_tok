import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pineapple_tok/data/profile.dart';

class ChattingMessage {
  String uid, name, thumbnail, message, time;
  ChattingMessage(this.uid, this.name, this.thumbnail, this.message, this.time);

  factory ChattingMessage.getChattingComment(String uid, String name,
    String thumbnail, String message, String time) {
    if (thumbnail == '') {
      thumbnail = 'assets/basic_profile_picture.png';
    }
    return ChattingMessage(uid, name, thumbnail, message, time);
  }
}

class ChattingMessageHandler {
  final _firestore = FirebaseFirestore.instance;
  final currentChattingId;
  ProfileHandler profileHandler = ProfileHandler();

  ChattingMessageHandler(this.currentChattingId);

  Future<List<ChattingMessage>?> updateChattingMessages() async {
    final docRef = _firestore.collection('chatting').doc('messages')
        .collection('data').doc(this.currentChattingId);
    final doc = await docRef.get();

    Map<String, Profile?> userProfiles = {};
    List<ChattingMessage> chattingComments = [];
    for (var _message in doc['message_list']) {
      String uid = _message['uid'];
      if (userProfiles.containsKey(uid) == false) {
        userProfiles[uid] = await profileHandler.getProfile(uid);
      }
      String name = userProfiles[uid] == null ? 'error' : userProfiles[uid]!.name;
      String thumbnail = userProfiles[uid] == null ? '' : userProfiles[uid]!.thumbnail;
      String message = _message['message'];
      String time = _message['time'];
      chattingComments.add(ChattingMessage.getChattingComment(
        uid, name, thumbnail, message, time
      ));
    }

    if (chattingComments.length == 0) {
      return null;
    }
    else {
      return chattingComments;
    }
  }
}