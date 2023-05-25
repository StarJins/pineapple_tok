import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';

class Account {
  late final int currentId;

  Future<bool> checkIdPw(final String userId, final String userPw) async {
    String jsonData = await rootBundle.loadString('dummy_data/user_account.json');
    dynamic account = jsonDecode(jsonData);

    for (var x in account['user_account']) {
      if (x['email'] == userId && x['password'] == userPw) {
        this.currentId = x['id'];
        return true;
      }
    }

    return false;
  }

  int getUserId() {
    return this.currentId;
  }
}