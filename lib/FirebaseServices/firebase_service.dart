// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ui/Auth/login_phn_screen.dart';
import '../ui/Auth/login_screen.dart';
import '../ui/firestore/firestore_list_screen.dart';

class SplashService {
  void islogin(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    if (user != null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const FireStoreScreen())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPhnScreen())));
    }
  }
}
