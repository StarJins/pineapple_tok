import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pineapple_tok/data/friend.dart';
import 'package:pineapple_tok/data/chatting_room.dart';

class NewChattingPage extends StatelessWidget {
  const NewChattingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅방 생성'),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: NewChattingListView(),
          ),
        ],
      ),
    );
  }
}

class NewChattingListView extends StatefulWidget {
  const NewChattingListView({
    super.key,
  });

  @override
  State<NewChattingListView> createState() => _NewChattingListViewState();
}

class _NewChattingListViewState extends State<NewChattingListView> {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  List<Friend>? _friendList = null;
  Map<String, bool> _checkboxValueList = {};
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    this._loadData();
  }

  void _loadData() async {
    this._friendList = await this._loadFriendList();
    if (this._friendList != null) {

      for(var friend in _friendList!) {
        _checkboxValueList[friend.uid] = false;
      }
    }
    setState(() {});
  }

  Future<List<Friend>?> _loadFriendList() async {
    FriendHandler f = FriendHandler();
    return f.updateFriendList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: _buildProfileList(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '입력 안할 시 기본 이름으로 설정',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  ),
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  var checkedCount = this._checkboxValueList.values.where((c) => c == true).length;
                  if (checkedCount == 0) {
                    _showSnackBar(context, '채팅 만들 친구를 선택해 주세요');
                    return;
                  }

                  await _createNewChattingRoom();
                  Navigator.of(context).pop(true);
                },
                child: Text('채팅방 생성'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _createNewChattingRoom() async {
    ChattingRoomHandler roomHandler = ChattingRoomHandler();

    String newChattingRoomId = await roomHandler.getNewChattingRoomId();

    // 전체 채팅 리스트에 추가
    List<String> members = await _addTotalChattingList(newChattingRoomId);

    // 각 유저의 채팅 리스트에 추가
    await _addEachUserChattingList(members, newChattingRoomId);
  }

  Future<void> _addEachUserChattingList(List<String> members, String newChattingRoomId) async {
    ChattingRoomHandler roomHandler = ChattingRoomHandler();
    for (var uid in members) {
      List<String> chattingList = await roomHandler.getChattingList(uid);
      chattingList.add(newChattingRoomId);

      await _firestore.collection('user').doc('chattings')
      .collection('data').doc(uid)
      .set({
        'chatting_rooms' : chattingList
      });
    }
  }

  Future<List<String>> _addTotalChattingList(String newChattingRoomId) async {
    List<String> members = [];
    for (var selectedFriend in this._checkboxValueList.entries) {
      if (selectedFriend.value) {
        members.add(selectedFriend.key);
      }
    }
    members.add(_authentication.currentUser!.uid);

    ChattingType type = (members.length >= 3) ? ChattingType.group : ChattingType.individual;
    String chattingRoomName = '';
    if (this.nameController.text.isEmpty) {
      chattingRoomName = (members.length >= 3) ? '단체방${newChattingRoomId}' : '개인방';
    }
    else {
      chattingRoomName = this.nameController.text;
    }

    ChattingRoom newChattingRoom = ChattingRoom.getChattingRoom(
      newChattingRoomId, type, '', chattingRoomName, members.length, '', DateTime(0), members
    );

    await _firestore.collection('chatting').doc('rooms')
    .collection('data').doc(newChattingRoomId)
    .set({
      'count' : newChattingRoom.numOfPeople,
      'members' : newChattingRoom.members,
      'name' : newChattingRoom.chattingRoomName,
      'thumbnail' : newChattingRoom.thumbnail,
      'type' : newChattingRoom.chattingRoomType.index
    });
    return members;
  }

  void _showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }

  List<Widget> _buildFriendProfiles(BuildContext context) {
    this._friendList!.sort((a, b) => a.name.compareTo(b.name));
    List<Widget> friendList = List.generate(
      this._friendList!.length,
      (index) => makeProfileTile(this._friendList![index])
    );

    return friendList;
  }

  List<Widget> _buildProfileList(BuildContext context) {
    if (this._friendList == null) {
      return [];
    }

    return _buildFriendProfiles(context);
  }

  Widget makeProfileTile(Friend data) {
    return CheckboxListTile(
      title: Text(data.name),
      subtitle: Text(data.comment),
      activeColor: Colors.deepOrangeAccent,
      checkColor: Colors.black,
      controlAffinity: ListTileControlAffinity.leading,
      value: _checkboxValueList[data.uid],
      onChanged: (value) {
        setState(() {
          _checkboxValueList[data.uid] = value!;
        });
      },
    );
  }
}