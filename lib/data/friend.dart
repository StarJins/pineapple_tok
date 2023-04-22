import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:pineapple_tok/data/profile.dart';
import 'dart:async';


class Friend extends Profile {
  late int id;

  Friend(this.id, String picturePath, String name) : super(picturePath, name);

  @override
  String toString() {
    return 'id: $id, path: $picturePath, name: $name';
  }

  factory Friend.getMyProfile(int id, String picturePath, String name) {
    return Friend(id, picturePath, name);
  }
}

class FriendHandler {
  Future<List<Friend>> updateFriendList() async {
    String jsonData = await rootBundle.loadString('dummy_data/friend_list.txt');
    dynamic parsingData = jsonDecode(jsonData);

    List<Friend> friendList = [];
    for (var x in parsingData['friendList']) {
      friendList.add(Friend.getMyProfile(x['id'], x['picturePath'], x['name']));
    }
    return friendList;
  }
}