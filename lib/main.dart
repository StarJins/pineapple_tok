import 'package:flutter/material.dart';
import 'package:pineapple_tok/login_page/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pineapple tok',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: LoginPage(),
    );
  }
}
