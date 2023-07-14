import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pineapple_tok/data/friend.dart';

class NewFriendPage extends StatelessWidget {
  const NewFriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 추가'),
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
            child: NewFriendListView(),
          ),
        ],
      ),
    );
  }
}

class NewFriendListView extends StatefulWidget {
  const NewFriendListView({
    super.key,
  });

  @override
  State<NewFriendListView> createState() => _NewFriendListViewState();
}

class _NewFriendListViewState extends State<NewFriendListView> {
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
    return f.updateNewFriendList();
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

                await _setNewFriendsList();
                Navigator.of(context).pop(true);
              },
              child: Text('친구 추가'),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _setNewFriendsList() async {
    FriendHandler f = FriendHandler();
    List<String> newFriendsList = await f.getFriendsList();

    for (var newFriend in this._checkboxValueList.entries) {
      if (newFriend.value) {
        newFriendsList.add(newFriend.key);
      }
    }

    await _firestore.collection('user').doc('friends')
    .collection('data').doc(_authentication.currentUser!.uid)
    .set({
      'friends' : newFriendsList
    });
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('추가할 친구를 선택해 주세요.'),
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