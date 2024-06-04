import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utility {

  void toastMessage(String message) {
    Fluttertoast.showToast(msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xff637A80),
      textColor: Colors.white,
      fontSize: 16.0,);
  }

}