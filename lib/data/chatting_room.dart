import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';

enum ChattingType {
  individual, // 0
  group,  // 1
}

class ChattingRoom {
  int id;
  ChattingType chattingRoomType;
  String thumbnail;
  String chattingRoomName;
  int numOfPeople;
  String lastChat;
  String lastChatTime;
  List<int> members;

  ChattingRoom(this.id, this.chattingRoomType, this.thumbnail, this.chattingRoomName,
    this.numOfPeople, this.lastChat, this.lastChatTime, this.members);

  factory ChattingRoom.getChattingRoom(int id, ChattingType chattingRoomType,
    String thumbnail, String chattingRoomName, int numOfPeople, String lastChat,
    String lastChatTime, List<int> members) {
    return ChattingRoom(id, chattingRoomType, thumbnail, chattingRoomName,
      numOfPeople, lastChat, lastChatTime, members);
  }
}

class ChattingRoomHandler {
  final currentUserId;

  ChattingRoomHandler(this.currentUserId);

  Future<List<int>> getChattingList() async {
    String jsonData = await rootBundle.loadString('dummy_data/user_chatting.json');
    dynamic parsingData = jsonDecode(jsonData);

    List<int> chattingList = [];
    for (var x in parsingData['user_chatting']) {
      if (x['id'] == this.currentUserId) {
        for (var y in x['chatting_rooms']) {
          chattingList.add(y);
        }
      }
    }

    return chattingList;
  }

  Future<List<ChattingRoom>> updateChattingRoomList() async {
    String jsonData = await rootBundle.loadString('dummy_data/chatting_info.json');
    dynamic parsingData = jsonDecode(jsonData);

    List<int> chattingRoomIdList = await getChattingList();

    List<ChattingRoom> chattingRoomList = [];
    for (var x in parsingData['chatting_info']) {
      if (chattingRoomIdList.contains(x['id'])) {
        int id = x['id'];
        ChattingType chattingRoomType = ChattingType.values[x['type']];
        String thumbnail = x['thumbnail'];
        if (thumbnail == '') {
          thumbnail = 'assets/basic_profile_picture.png';
        }
        String chattingRoomName = x['name'];
        int numOfPeople = x['count'];
        String lastChat = x['lastChat'];
        String lastChatTime = x['lastChatTime'];
        List<int> members = [];
        for (var y in x['member']) {
          members.add(y);
        }

        chattingRoomList.add(ChattingRoom.getChattingRoom(id, chattingRoomType,
          thumbnail, chattingRoomName, numOfPeople, lastChat, lastChatTime,
          members));
      }
    }
    return chattingRoomList;
  }
}