import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pineapple_tok/friend_page/friend_page.dart';
import 'package:pineapple_tok/chatting_page/chatting_list_page.dart';

class CreditPage extends StatelessWidget {
  const CreditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('credit page'),
        ElevatedButton(
          onPressed: () {
            FriendPage.profileList = [];
            ChattingPage.chattingList = [];
            final _authentication = FirebaseAuth.instance;
            _authentication.signOut();
            Navigator.of(context).pop();
          },
          child: Text('logout'),
        ),
      ],
    );
  }
}
