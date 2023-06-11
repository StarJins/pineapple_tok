import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';

class ChattingComment {
  String uid, name, thumbnail, comment, time;
  ChattingComment(this.uid, this.name, this.thumbnail, this.comment, this.time);

  factory ChattingComment.getChattingComment(String uid, String name,
    String thumbnail, String comment, String time) {
    if (thumbnail == '') {
      thumbnail = 'assets/basic_profile_picture.png';
    }
    return ChattingComment(uid, name, thumbnail, comment, time);
  }
}

class ChattingCommentHandler {
  final currentChattingId;

  ChattingCommentHandler(this.currentChattingId);

  Future<List<ChattingComment>> updateChattingComments() async {
    String jsonData = await rootBundle.loadString('dummy_data/chatting_comment.json');
    dynamic parsingData = jsonDecode(jsonData);

    List<ChattingComment> chattingComments = [];
    for (var x in parsingData['chatting_comment']) {
      if (x['id'] == this.currentChattingId) {
        for (var y in x['chat_list']) {
          String uid = y['uid'];
          String name = y['name'];
          String thumbnail = y['thumbnail'];
          String comment = y['comment'];
          String time = y['time'];
          chattingComments.add(ChattingComment.getChattingComment(
            uid, name, thumbnail, comment, time
          ));
        }
      }
    }

    return chattingComments;
  }
}