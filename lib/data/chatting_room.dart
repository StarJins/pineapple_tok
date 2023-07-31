import 'dart:async';
import 'package:tuple/tuple.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pineapple_tok/data/profile.dart';
import 'package:pineapple_tok/data/chatting_comment.dart';

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
  DateTime lastChatTime;
  List<String> members;

  ChattingRoom(this.cid, this.chattingRoomType, this.thumbnail, this.chattingRoomName,
    this.numOfPeople, this.lastChat, this.lastChatTime, this.members);

  factory ChattingRoom.getChattingRoom(String cid, ChattingType chattingRoomType,
    String thumbnail, String chattingRoomName, int numOfPeople, String lastChat,
    DateTime lastChatTime, List<String> members) {
    if (thumbnail == '') {
      thumbnail = 'assets/basic_profile_picture.png';
    }

    return ChattingRoom(cid, chattingRoomType, thumbnail, chattingRoomName,
      numOfPeople, lastChat, lastChatTime, members);
  }

  String getStrTimeToPrint() {
    int currentDay = DateTime.now().day;
    int currentYear = DateTime.now().year;

    int targetDay = this.lastChatTime.day;
    int targetMonth = this.lastChatTime.month;
    int targetYear = this.lastChatTime.year;

    if (currentDay == targetDay) {
      return DateFormat('HH:mm').format(this.lastChatTime);
    }
    else if (currentDay - targetDay == 1) {
      return '어제';
    }
    else if (currentYear == targetYear) {
      return targetMonth.toString() + '월 ' + targetDay.toString() + '일';
    }
    else if (this.lastChatTime == DateTime(0)) {
      return '';
    }
    else {
      return targetYear.toString() + '. ' + targetMonth.toString() + '. ' +
          targetDay.toString() + '.';
    }
  }
}

class ChattingRoomHandler {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<String> getNewChattingRoomId() async {
    final collectionRef = _firestore.collection('chatting').doc('rooms').collection('data');
    final querySnapshot = await collectionRef.get();
    String newId = querySnapshot.docs.length.toString();

    return newId;
  }

  Future<List<String>> getChattingList(String uid) async {
    final docRef = _firestore.collection('user').doc('chattings')
        .collection('data').doc(uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      return [];
    }

    List<String> chattingList = [];
    for (var room in doc['chatting_rooms']) {
      chattingList.add(room);
    }

    return chattingList;
  }

  Future<Tuple2<String, String>> setThumbnailAndNameValue(List<String> members) async {
    final curUser = _authentication.currentUser;

    String otherUid = "";
    for (var member in members) {
      if (member != curUser!.uid) {
        otherUid = member;
      }
    }

    ProfileHandler profileHandler = ProfileHandler();
    Profile? userProfile = await profileHandler.getProfile(otherUid);
    if (userProfile == null) {
      userProfile = Profile.getProfile('', '', 'error', '');
    }
    return Tuple2<String, String>(userProfile.thumbnail, userProfile.name);
  }

  Future<List<ChattingRoom>?> updateChattingRoomList() async {
    final collectionRef = _firestore.collection('chatting').doc('rooms')
        .collection('data');
    final querySnapshot = await collectionRef.get();

    List<String> chattingRoomIdList = await getChattingList(_authentication.currentUser!.uid);
    if (chattingRoomIdList.length == 0) {
      return [];
    }

    List<ChattingRoom> chattingRoomList = [];
    for (var doc in querySnapshot.docs) {
      if (chattingRoomIdList.contains(doc.id)) {
        ChattingType chattingRoomType = ChattingType.values[doc['type']];
        String thumbnail = doc['thumbnail'];
        String chattingRoomName = doc['name'];
        int numOfPeople = doc['count'];

        ChattingMessageHandler messageHandler = ChattingMessageHandler(doc.id);
        var lastChatInfo = await messageHandler.getLastChatInfo();
        String lastChat = lastChatInfo.item1;
        DateTime lastChatTime = lastChatInfo.item2;

        List<String> members = [];
        for (var member in doc['members']) {
          members.add(member);
        }

        if (chattingRoomType == ChattingType.individual && chattingRoomName == '개인방') {
          Tuple2<String, String> userInfo = await setThumbnailAndNameValue(members);
          thumbnail = userInfo.item1;
          chattingRoomName = userInfo.item2;
        }

        chattingRoomList.add(ChattingRoom.getChattingRoom(doc.id, chattingRoomType,
          thumbnail, chattingRoomName, numOfPeople, lastChat, lastChatTime,
          members));
      }
    }

    if (chattingRoomList.length == 0) {
      return null;
    }
    else {
      return chattingRoomList;
    }
  }
}