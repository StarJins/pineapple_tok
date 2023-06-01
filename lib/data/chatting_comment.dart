import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';

class ChattingComment {
  String name, thumbnail, comment, time;
  ChattingComment(this.name, this.thumbnail, this.comment, this.time);

  factory ChattingComment.getChattingComment(String name, String thumbnail, String comment, String time) {
    if (thumbnail == '') {
      thumbnail = 'assets/basic_profile_picture.png';
    }
    return ChattingComment(name, thumbnail, comment, time);
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
          String name = y['name'];
          String thumbnail = y['thumbnail'];
          String comment = y['comment'];
          String time = y['time'];
          chattingComments.add(ChattingComment.getChattingComment(name, thumbnail, comment, time));
        }
      }
    }

    return chattingComments;
  }
}