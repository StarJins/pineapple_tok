import 'package:flutter/material.dart';
import 'package:pineapple_tok/login_page/login_page.dart';
import 'package:pineapple_tok/layout/main_page.dart';
import 'package:pineapple_tok/friend_page/friend_page.dart';
import 'package:pineapple_tok/chatting_page/chatting_page.dart';
import 'package:pineapple_tok/credit_page/credit_page.dart';

void main() => runApp(MyApp());

class Page {
  final String pageName;
  final String pageUrl;
  final Widget pageWidget;

  Page(this.pageName, this.pageUrl, this.pageWidget);
}

final Map<int, Page> pageList = {
  -2 : Page('login page', '/', LoginPage()),
  -1 : Page('main page', '/main_page', MainPage()),
  0 : Page('friend page', '/friend_page', FriendPage()),
  1 : Page('chatting page', '/chatting_page', ChattingPage()),
  2 : Page('credit page', '/credit_page', CreditPage()),
};

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  Map<String, Widget Function(BuildContext)> setRouteMap() {
    Map<String, Widget Function(BuildContext)> tmp = {};
    pageList.forEach((key, value) {
      tmp[value.pageUrl] = (context) => value.pageWidget;
    });

    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pineapple tok',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      initialRoute: '/',
      routes: setRouteMap(),
    );
  }
}
