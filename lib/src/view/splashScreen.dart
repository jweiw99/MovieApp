import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:movieapp/src/utils/errorMsg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    try {
      await InternetAddress.lookup('google.com');
    } on SocketException catch (_) {
      ErrorMsg.internetMsg();
    }
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/homeScreen', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Image.asset(
            'assets/images/logo/logo.gif',
            fit: BoxFit.scaleDown,
          ),
        ));
  }
}
