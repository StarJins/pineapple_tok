import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

class Account {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

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

  Future<Tuple2<bool, String>> createAccount(String name, String userId, String userPw) async {
    String err = '';
    try {
      final newAccount = await _authentication.createUserWithEmailAndPassword(
        email: userId,
        password: userPw,
      );

      if (newAccount.user != null) {
        await _firestore.collection('user').doc('profiles').collection('data')
        .doc(newAccount.user!.uid).set({
          'name' : name,
          'comment' : '',
          'thumbnail' : '',
          'background' : '',
        });
        return Tuple2(true, '');
      }
    }
    catch (e) {
      err = e.toString();
      print(err);
    }

    return Tuple2(false, err);
  }
}