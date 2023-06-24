import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pineapple_tok/data/profile.dart';

class ChattingMessage {
  String uid, name, thumbnail, message;
  DateTime dateTime;
  ChattingMessage(this.uid, this.name, this.thumbnail, this.message, this.dateTime);

  factory ChattingMessage.getChattingComment(String uid, String name,
    String thumbnail, String message, DateTime dateTime) {
    if (thumbnail == '') {
      thumbnail = 'assets/basic_profile_picture.png';
    }
    return ChattingMessage(uid, name, thumbnail, message, dateTime);
  }

  String getTime() {
    return DateFormat('HH:mm').format(this.dateTime);
  }
}

class ChattingMessageHandler {
  final currentChattingId;
  ProfileHandler profileHandler = ProfileHandler();

  ChattingMessageHandler(this.currentChattingId);

  Future<List<ChattingMessage>?> getChattingMessages(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> messageList
  ) async {
    Map<String, Profile?> userProfiles = {};
    List<ChattingMessage> chattingComments = [];

    for (var _message in messageList) {
      String uid = _message['uid'];
      if (userProfiles.containsKey(uid) == false) {
        userProfiles[uid] = await profileHandler.getProfile(uid);
      }
      String name = userProfiles[uid] == null ? 'error' : userProfiles[uid]!.name;
      String thumbnail = userProfiles[uid] == null ? '' : userProfiles[uid]!.thumbnail;
      String message = _message['message'];
      DateTime dateTime = _message['time'].toDate();
      chattingComments.add(ChattingMessage.getChattingComment(
          uid, name, thumbnail, message, dateTime
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