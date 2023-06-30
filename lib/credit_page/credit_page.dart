import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreditPage extends StatelessWidget {
  const CreditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('credit page'),
        ElevatedButton(
          onPressed: () {
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
