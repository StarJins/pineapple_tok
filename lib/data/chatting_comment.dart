import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  ChattingMessageHandler(this.currentChattingId);

  Future<List<ChattingMessage>?> updateChattingMessages() async {
    final docRef = _firestore.collection('chatting').doc('messages')
        .collection('data').doc(this.currentChattingId);
    final doc = await docRef.get();

    List<ChattingMessage> chattingComments = [];
    for (var _message in doc['message_list']) {
      String uid = _message['uid'];
      String name = _message['name'];
      String thumbnail = _message['thumbnail'];
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