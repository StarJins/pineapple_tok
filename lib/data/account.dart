import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';

class Account {
  Future<bool> checkIdPw(final String userId, final String userPw) async {
    String jsonData = await rootBundle.loadString('dummy_data/account_list.txt');
    dynamic account = jsonDecode(jsonData);

    for (var x in account['accountList']) {
      if (x['id'] == userId && x['password'] == userPw) {
        return true;
      }
    }

    return false;
  }
}