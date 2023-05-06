import 'package:flutter/material.dart';

void main() => runApp(A());

class A extends StatelessWidget {
  int number = 1;
  A({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: B(number),
    );
  }
}

class B extends StatelessWidget {
  int number;
  B(this.number, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(number);
    return Text('b');
  }
}