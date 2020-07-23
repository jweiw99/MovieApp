import 'package:flutter/material.dart';

// external package
import 'package:fluttertoast/fluttertoast.dart';

class ErrorMsg {
  ErrorMsg._();

  static internetMsg() => Fluttertoast.showToast(
      msg: 'No Internet Access',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      textColor: Colors.white,
      fontSize: 16.0);
}
