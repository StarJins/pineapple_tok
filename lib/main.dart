import 'package:flutter/material.dart';
import 'package:pineapple_tok/login_page/login_page.dart';
import 'package:pineapple_tok/friend_page/friend_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pineapple tok',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => LoginPage(),
        '/friend_page' : (context) => FriendPage(),
      },
    );
  }
}
