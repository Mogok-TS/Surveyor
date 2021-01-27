import 'package:Surveyor/Map/map.dart';
import 'package:Surveyor/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:load/load.dart';

import 'Register/login.dart';
import 'assets/custom_icons_icons.dart';
import 'checkNeighborhood.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFab000d),
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Surveyor',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: CustomIcons.appbarColor),
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      home:Login(),
    );
  }
}
