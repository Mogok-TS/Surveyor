
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';

void showLoading(){
  showCustomLoadingWidget(
    Center(
      child:Container(
        height: 85,
        width: 85,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Container(
            padding: const EdgeInsets.all(15),
            child: CircularProgressIndicator(
                strokeWidth: 3,
                backgroundColor: Color(0xFFCCCCCC),
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Colors.red)),
            color: Colors.white,
          ),
        ),
      ),

    ),
    tapDismiss: false,
  );
}