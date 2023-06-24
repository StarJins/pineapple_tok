import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pineapple_tok/data/friend.dart';
import 'package:pineapple_tok/data/my_profile.dart';
import 'package:pineapple_tok/data/profile.dart';
import 'package:pineapple_tok/friend_page/profile_page.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  bool isDataLoading = true;
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

  void _loadData() async {
    this.myProfile = await this._loadMyProfile();
    this.friendList = await this._loadFriendList();
    setState(() {
      isDataLoading = false;
    });
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
    if (this.isDataLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    else {
      return Padding(
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
      );
    }
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

    return friendList;
  }

  List<Widget> _buildProfileList(BuildContext context) {
    if (this.myProfile == null || this.friendList == null) {
      return [
        Center(
          child: Text(
            'data load error, please re-load this page',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        )
      ];
    }

    List<Widget> tileList = [];
    tileList = _buildFriendProfiles(context);
    tileList.insert(0, Divider(
      height: 20,
      thickness: 2.0,
    ));
    tileList.insert(0, _buildMyProfile(context));
    return tileList;
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