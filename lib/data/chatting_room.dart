import 'dart:async';
import 'package:tuple/tuple.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ChattingType {
  individual, // 0
  group,  // 1
}

class ChattingRoom {
  String cid;
  ChattingType chattingRoomType;
  String thumbnail;
  String chattingRoomName;
  int numOfPeople;
  String lastChat;
  String lastChatTime;
  List<String> members;

  ChattingRoom(this.cid, this.chattingRoomType, this.thumbnail, this.chattingRoomName,
    this.numOfPeople, this.lastChat, this.lastChatTime, this.members);

  factory ChattingRoom.getChattingRoom(String cid, ChattingType chattingRoomType,
    String thumbnail, String chattingRoomName, int numOfPeople, String lastChat,
    String lastChatTime, List<String> members) {
    if (thumbnail == '') {
      thumbnail = 'assets/basic_profile_picture.png';
    }

    return ChattingRoom(cid, chattingRoomType, thumbnail, chattingRoomName,
      numOfPeople, lastChat, lastChatTime, members);
  }
}

class ChattingRoomHandler {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<List<String>> getChattingList() async {
    final curUser = _authentication.currentUser;

    final docRef = _firestore.collection('user').doc('chattings')
        .collection('data').doc(curUser!.uid);
    final doc = await docRef.get();

    List<String> chattingList = [];
    for (var room in doc['chatting_rooms']) {
      chattingList.add(room);
    }

    return chattingList;
  }

  Future<Tuple2<String, String>> getUserThumbnailAndName(String uid) async {
    final docRef = _firestore.collection('user').doc('profiles')
        .collection('data').doc(uid);
    final doc = await docRef.get();

    String thumbnail = doc['thumbnail'];
    if (thumbnail == '') {
      thumbnail = 'assets/basic_profile_picture.png';
    }
    String name = doc['name'];

    Tuple2<String, String> userInfo = Tuple2<String, String>(thumbnail, name);
    return userInfo;
  }

  Future<Tuple2<String, String>> setThumbnailAndNameValue(List<String> members) async {
    final curUser = _authentication.currentUser;

    String otherUid = "";
    for (var member in members) {
      if (member != curUser!.uid) {
        otherUid = member;
      }
    }
    return await getUserThumbnailAndName(otherUid);
  }

  Future<List<ChattingRoom>> updateChattingRoomList() async {
    final collectionRef = _firestore.collection('chatting').doc('rooms')
        .collection('data');
    final querySnapshot = await collectionRef.get();

    List<String> chattingRoomIdList = await getChattingList();

    List<ChattingRoom> chattingRoomList = [];
    for (var doc in querySnapshot.docs) {
      if (chattingRoomIdList.contains(doc.id)) {
        ChattingType chattingRoomType = ChattingType.values[doc['type']];
        String thumbnail = doc['thumbnail'];
        String chattingRoomName = doc['name'];
        int numOfPeople = doc['count'];
        String lastChat = doc['lastChat'];
        String lastChatTime = doc['lastChatTime'];
        List<String> members = [];
        for (var member in doc['members']) {
          members.add(member);
        }

        if (chattingRoomType == ChattingType.individual) {
          Tuple2<String, String> userInfo = await setThumbnailAndNameValue(members);
          thumbnail = userInfo.item1;
          chattingRoomName = userInfo.item2;
        }

        chattingRoomList.add(ChattingRoom.getChattingRoom(doc.id, chattingRoomType,
          thumbnail, chattingRoomName, numOfPeople, lastChat, lastChatTime,
          members));
      }
    }
    return chattingRoomList;
  }
}