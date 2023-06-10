import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Account {
  late final int currentId;
  final _authentication = FirebaseAuth.instance;

  // 추후 임시 idx가 아닌 firebase에서 제공하는 uid를 사용할 예정
  final Map<String, int> tmpEmailToIdx = {
    "test@email.com" : 1,
    "jin@email.com" : 2,
    "sim@email.com" : 3,
    "kwon@email.com" : 4,
  };

  Future<bool> checkIdPw(final String userId, final String userPw) async {
    try {
      final account = await _authentication.signInWithEmailAndPassword(
        email: userId,
        password: userPw,
      );

      if (account.user != null) {
        this.currentId = tmpEmailToIdx[account.user!.email]!;
        return true;
      }
    }
    catch (e) {
      print(e);
    }

    return false;
  }

  int getUserId() {
    return this.currentId;
  }
}