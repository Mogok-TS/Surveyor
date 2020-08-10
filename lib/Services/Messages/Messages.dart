import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void ShowToast(message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 15.0
  );
}

