import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';

enum ChattingType {
  individual, // 0
  group,  // 1
}

class ChattingRoom {
  ChattingType chattingRoomType;
  String picturePath;
  String chattingRoomName;
  String lastChat;
  String lastTime;
  int numOfPeople;
  List<int> peopleList;

  ChattingRoom(this.chattingRoomType, this.picturePath, this.chattingRoomName,
    this.lastChat, this.lastTime, this.numOfPeople, this.peopleList);

  factory ChattingRoom.getChattingRoom(ChattingType chattingRoomType,
    String picturePath, String chattingRoomName,
    String lastChat, String lastTime, int numOfPeople,
    List<int> peopleList) {
    return ChattingRoom(chattingRoomType, picturePath, chattingRoomName,
        lastChat, lastTime, numOfPeople, peopleList);
  }
}

class ChattingRoomHandler {
  Future<List<ChattingRoom>> updateChattingRoomList() async {
    String jsonData = await rootBundle.loadString('dummy_data/chatting_list.txt');
    dynamic parsingData = jsonDecode(jsonData);

    List<ChattingRoom> chattingRoomList = [];
    for (var x in parsingData['chattingRoomList']) {
      print(x);
      chattingRoomList.add(ChattingRoom.getChattingRoom(
        ChattingType.values[x['type']], x['path'], x['name'], x['lastChat'], x['lastTime'],
        x['numOfPeople'], x['peopleList'].cast<int>()
      ));
    }
    return chattingRoomList;
  }
}