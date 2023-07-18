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
    return Stack(
      children: [
        ListView(
          children: _buildProfileList(context),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () async {
                var checkedCount = this._checkboxValueList.values.where((c) => c == true).length;
                if (checkedCount == 0) {
                  _showSnackBar(context);
                  return;
                }

                await _createNewChattingRoom();
                Navigator.of(context).pop(true);
              },
              child: Text('채팅방 생성'),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _createNewChattingRoom() async {
    ChattingRoomHandler roomHandler = ChattingRoomHandler();

    String newChattingRoomId = await roomHandler.getNewChattingRoomId();

    List<String> chattingList = await roomHandler.getChattingList();
    chattingList.add(newChattingRoomId);

    await _firestore.collection('user').doc('chattings')
    .collection('data').doc(_authentication.currentUser!.uid)
    .set({
      'chatting_rooms' : chattingList
    });

    List<String> members = [];
    for (var selectedFriend in this._checkboxValueList.entries) {
      if (selectedFriend.value) {
        members.add(selectedFriend.key);
      }
    }

    ChattingType type = (members.length >= 3) ? ChattingType.group : ChattingType.individual;
    String chattingRoomName = (members.length >= 3) ? '단체방${newChattingRoomId}' : '개인방';

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

    // TODO: 이름 설정 할 수 있게 추가해야 함
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('채팅 만들 친구를 선택해 주세요'),
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