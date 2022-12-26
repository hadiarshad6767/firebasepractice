import 'package:flutter/material.dart';

import '../FirebaseServices/firebase_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashService splashservice = SplashService();
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    splashservice.islogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return (const Scaffold(
      body: SafeArea(
          child: Center(
        child: Text(
          "Firebase Practice ",
          style: TextStyle(fontSize: 30),
        ),
      )),
    ));
  }
}
