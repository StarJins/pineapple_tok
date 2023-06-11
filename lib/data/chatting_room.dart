import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:tuple/tuple.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  List<String> members;

  ChattingRoom(this.id, this.chattingRoomType, this.thumbnail, this.chattingRoomName,
    this.numOfPeople, this.lastChat, this.lastChatTime, this.members);

  factory ChattingRoom.getChattingRoom(int id, ChattingType chattingRoomType,
    String thumbnail, String chattingRoomName, int numOfPeople, String lastChat,
    String lastChatTime, List<String> members) {
    if (thumbnail == '') {
      thumbnail = 'assets/basic_profile_picture.png';
    }

    return ChattingRoom(id, chattingRoomType, thumbnail, chattingRoomName,
      numOfPeople, lastChat, lastChatTime, members);
  }
}

class ChattingRoomHandler {
  final _authentication = FirebaseAuth.instance;

  Future<List<int>> getChattingList() async {
    final curUser = _authentication.currentUser;

    String jsonData = await rootBundle.loadString('dummy_data/user_chatting.json');
    dynamic parsingData = jsonDecode(jsonData);

    List<int> chattingList = [];
    for (var x in parsingData['user_chatting']) {
      if (x['uid'] == curUser!.uid) {
        for (var y in x['chatting_rooms']) {
          chattingList.add(y);
        }
      }
    }

    return chattingList;
  }

  Future<Tuple2<String, String>> getUserThumbnailAndName(String uid) async {
    String jsonData = await rootBundle.loadString('dummy_data/user_profile.json');
    dynamic parsingData = jsonDecode(jsonData);

    String thumbnail = "", name = "";
    for (var x in parsingData['user_profile']) {
      if (x['uid'] == uid) {
        thumbnail = x['thumbnail'];
        if (thumbnail == '') {
          thumbnail = 'assets/basic_profile_picture.png';
        }
        name = x['name'];
      }
    }

    Tuple2<String, String> userInfo = Tuple2<String, String>(thumbnail, name);
    return userInfo;
  }

  Future<Tuple2<String, String>> setThumbnailAndNameValue(List<String> members) async {
    final curUser = _authentication.currentUser;

    String otherUid = "";
    for (var y in members) {
      if (y != curUser!.uid) {
        otherUid = y;
      }
    }
    return await getUserThumbnailAndName(otherUid);
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
        String chattingRoomName = x['name'];
        int numOfPeople = x['count'];
        String lastChat = x['lastChat'];
        String lastChatTime = x['lastChatTime'];
        List<String> members = [];
        for (var y in x['member']) {
          members.add(y);
        }

        if (chattingRoomType == ChattingType.individual) {
          Tuple2<String, String> userInfo = await setThumbnailAndNameValue(members);
          thumbnail = userInfo.item1;
          chattingRoomName = userInfo.item2;
        }

        chattingRoomList.add(ChattingRoom.getChattingRoom(id, chattingRoomType,
          thumbnail, chattingRoomName, numOfPeople, lastChat, lastChatTime,
          members));
      }
    }
    return chattingRoomList;
  }
}