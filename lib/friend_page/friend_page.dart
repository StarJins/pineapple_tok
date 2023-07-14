import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pineapple_tok/data/friend.dart';
import 'package:pineapple_tok/data/my_profile.dart';
import 'package:pineapple_tok/data/profile.dart';
import 'package:pineapple_tok/friend_page/profile_page.dart';
import 'package:pineapple_tok/friend_page/new_friend_page.dart';

class FriendPage extends StatefulWidget {
  static List<Widget> profileList = [];

  const FriendPage({Key? key}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  MyProfile? myProfile = null;
  List<Friend>? friendList = null;

  // initState는 statefulWidget이 생성될 때 제일 처음에 호출된다.
  // initState와 반대의 개념인 deactivate도 존재한다.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // initState가 끝나기 전에 build가 호출될 수 있다.
    // 따라서 변수가 초기화 되기 전에 build가 실행될 수 있는 것
    // 이전 version에서는 FutureBuilder를 통해 이를 제어
    // 현재 version에서는 if문과 null을 통해 이를 제어
    // 변수 초기화 후 widget을 rebuild하기 위해 loadData 내에서 setState 호출
    this._loadData();
  }

  Future<void> _loadData() async {
    this.myProfile = await this._loadMyProfile();
    this.friendList = await this._loadFriendList();
    setState(() {});
  }

  Future<MyProfile?> _loadMyProfile() async {
    MyProfileHandler p = MyProfileHandler();
    return p.updateMyProfile();
  }

  Future<List<Friend>?> _loadFriendList() async {
    FriendHandler f = FriendHandler();
    return f.updateFriendList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('friend page'),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () async {
                dynamic result = await Navigator.of(context).push(
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: NewFriendPage(),
                  ),
                );

                if (result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('친구추가 성공'),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.lightBlue,
                    ),
                  );
                }

                await this._loadData();
              },
              icon: Icon(Icons.person_add_alt_1),
              splashRadius: 20.0,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: _buildProfileList(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyProfile(BuildContext context) {
    return makeProfileTile(this.myProfile!);
  }

  List<Widget> _buildFriendProfiles(BuildContext context) {
    this.friendList!.sort((a, b) => a.name.compareTo(b.name));
    List<Widget> friendList = List.generate(
      this.friendList!.length,
      (index) => makeProfileTile(this.friendList![index])
    );

    _numOfFriends(friendList, this.friendList!.length);
    return friendList;
  }

  void _numOfFriends(List<Widget> friendList, int numOfFriends) {
    friendList.insert(0, Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Text(
        '친구: ${numOfFriends}',
        style: TextStyle(
          fontSize: 14.0,
        ),
      ),
    ));
  }

  List<Widget> _buildProfileList(BuildContext context) {
    if (this.myProfile == null && this.friendList == null) {
      return FriendPage.profileList;
    }

    FriendPage.profileList = [];

    if (this.friendList != null) {
      FriendPage.profileList = _buildFriendProfiles(context);
    }
    else {
      _numOfFriends(FriendPage.profileList, 0);
      FriendPage.profileList.add(
        ListTile(
          title: Text('친구가 없습니다.'),
        ),
      );
    }

    if (this.myProfile != null) {
      FriendPage.profileList.insert(0, Divider(
        height: 20,
        thickness: 2.0,
      ));
      FriendPage.profileList.insert(0, _buildMyProfile(context));
    }

    return FriendPage.profileList;
  }

  ListTile makeProfileTile(Profile data) {
    return ListTile(
      leading: Image.asset(data.thumbnail),
      title: Text(data.name),
      subtitle: Text(data.comment),
      onTap: () {
        Navigator.of(context).push(
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: ProfilePage(profileInfo: data),
          ),
        );
      },
    );
  }
}