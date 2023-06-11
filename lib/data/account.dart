import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Account {
  final _authentication = FirebaseAuth.instance;

  Future<bool> checkIdPw(final String userId, final String userPw) async {
    try {
      final account = await _authentication.signInWithEmailAndPassword(
        email: userId,
        password: userPw,
      );

      if (account.user != null) {
        return true;
      }
    }
    catch (e) {
      print(e);
    }

    return false;
  }
}