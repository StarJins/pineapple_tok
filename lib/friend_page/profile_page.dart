import 'package:flutter/material.dart';
import 'package:pineapple_tok/data/profile.dart';

class ProfilePage extends StatelessWidget {
  final Profile profileInfo;
  const ProfilePage({Key? key, required this.profileInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: _buildProfileBody(),
    );
  }

  Column _buildProfileBody() {
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: SizedBox(),
        ),
        Expanded(
          flex: 7,
          child: _profilePageMainColumn(),
        ),
      ],
    );
  }

  Column _profilePageMainColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _profileInfo(),
        _bottomButton(),
      ],
    );
  }

  Column _profileInfo() {
    return Column(
      children: [
        Image.asset(
          this.profileInfo.thumbnail,
          height: 150.0,
          width: 150.0,
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          '${this.profileInfo.name}',
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        Text(
          '${this.profileInfo.comment}',
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Column _bottomButton() {
    return Column(
      children: [
        Divider(
          height: 40.0,
          thickness: 2.5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _BottomButton(Icons.chat_bubble, '1:1 채팅'),
            _BottomButton(Icons.call, '통화'),
            _BottomButton(Icons.video_call, '페이스톡'),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Column _BottomButton(IconData icon, String label) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            print('click');
          },
          child: Column(
            children: [
              Icon(
                icon,
                size: 30.0,
                color: Colors.black54,
              ),
              Text(
                '${label}',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
