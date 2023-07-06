import 'package:flutter/material.dart';
import 'package:pineapple_tok/data/friend.dart';

class NewFriendPage extends StatelessWidget {
  const NewFriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 추가'),
        elevation: 0.0,
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
    return ListView(
      children: _buildProfileList(context),
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