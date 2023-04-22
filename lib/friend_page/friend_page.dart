import 'package:flutter/material.dart';
import 'package:pineapple_tok/data/friend.dart';
import 'package:pineapple_tok/data/my_profile.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  late Future<MyProfile> myProfile;
  late Future<List<Friend>> friendList;

  // initState는 statefulWidget이 생성될 때 제일 처음에 호출된다.
  // initState와 반대의 개념인 deactivate도 존재한다.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // data load
    myProfile = loadMyProfile();
    myProfile = loadMyProfile();
    friendList = loadFriendList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend page'),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildMyProfile(),
            Divider(
              height: 20,
              thickness: 2.0,
            ),
            _buildFriendList(),
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<Friend>> _buildFriendList() {
    // Future 타입에 담아둔 값을 사용하기 위해 FutureBuilder 사용
    return FutureBuilder(
      future: friendList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Column안에 Listview를 다른 Widget가 같이 넣을 때, 높이를 지정해야 된다.
          // 이때 남은 공간을 다 차지하게 하기 위해 Expanded widget 사용
          return Expanded(
            child: ListView(
              children: [
                for (var x in snapshot.data!)
                  ListTile(
                    leading: Image.asset(x.picturePath),
                    title: Text(x.name),
                    subtitle: Text(x.id.toString()),
                  ),
              ],
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  FutureBuilder<MyProfile> _buildMyProfile() {
    // Future 타입에 담아둔 값을 사용하기 위해 FutureBuilder 사용
    return FutureBuilder(
      future: myProfile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListTile(
            leading: Image.asset(snapshot.data!.picturePath),
            title: Text(snapshot.data!.name),
          );
        }
        else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<MyProfile> loadMyProfile() async {
    MyProfileHandler p = MyProfileHandler();
    return p.updateMyProfile();
  }

  Future<List<Friend>> loadFriendList() async {
    FriendHandler f = FriendHandler();
    return f.updateFriendList();
  }
}
