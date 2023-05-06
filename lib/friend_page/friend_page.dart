import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pineapple_tok/data/friend.dart';
import 'package:pineapple_tok/data/my_profile.dart';
import 'package:pineapple_tok/friend_page/profile_page.dart';

class FriendPage extends StatefulWidget {
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

  void _loadData() async {
    this.myProfile = await this._loadMyProfile();
    this.friendList = await this._loadFriendList();
    setState(() {});
  }

  Future<MyProfile> _loadMyProfile() async {
    MyProfileHandler p = MyProfileHandler();
    return p.updateMyProfile();
  }

  Future<List<Friend>> _loadFriendList() async {
    FriendHandler f = FriendHandler();
    return f.updateFriendList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: _buildFriendList(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyProfile(BuildContext context) {
    if (this.myProfile != null) {
      return ListTile(
        leading: Image.asset(this.myProfile!.picturePath),
        title: Text(this.myProfile!.name),
        onTap: () {
          Navigator.of(context).push(
            PageTransition(
              type: PageTransitionType.bottomToTop,
              child: ProfilePage(profileInfo: this.myProfile!),
            ),
          );
        },
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  List<Widget> _buildFriendList(BuildContext context) {
    if (this.friendList != null) {
      List<Widget> tileList =  List.generate(
        this.friendList!.length,
        (index) => ListTile(
          leading: Image.asset(this.friendList![index].picturePath),
          title: Text(this.friendList![index].name),
          subtitle: Text(this.friendList![index].id.toString()),
          onTap: () {
            Navigator.of(context).push(
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: ProfilePage(profileInfo: this.friendList![index]),
              ),
            );
          },
        )
      );
      tileList.insert(0, Divider(
        height: 20,
        thickness: 2.0,
      ));
      tileList.insert(0, _buildMyProfile(context));

      return tileList;
    } else {
      return [ CircularProgressIndicator() ];
    }
  }
}