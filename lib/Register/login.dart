import 'package:Surveyor/Services/GeneralUse/PhoneNumber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Surveyor/Register/register.dart';
import 'package:Surveyor/Services/GeneralUse/TodayDate.dart';
import 'package:Surveyor/Services/Loading/LoadingServices.dart';
import 'package:Surveyor/Services/Messages/Messages.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';
import 'package:Surveyor/URL/url.dart';
import 'package:Surveyor/assets/custom_icons_icons.dart';
import 'package:Surveyor/stores.dart';
import 'package:Surveyor/Services/GeneralUse/Geolocation.dart';
import 'package:Surveyor/Services/Messages/Messages.dart';
import 'package:load/load.dart';
import 'package:localstorage/localstorage.dart';
import 'package:geolocator/geolocator.dart';

import '../URL/url.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  final LocalStorage storage = new LocalStorage('Surveyor');
  TextEditingController userID = new TextEditingController();
  TextEditingController password = new TextEditingController();
  OnlineSerives onlineSerives = new OnlineSerives();
  bool isBackButtonActivated = false;
  String latitude;
  String longitude;

  @override
  void initState() {
    super.initState();
    isBackButtonActivated = false;
    WidgetsBinding.instance.addObserver(this);
    latitude = "";
    longitude = "";
    getCurrentLocation().then((k) {
      latitude = k.latitude.toString();
      longitude = k.longitude.toString();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingProvider(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Color(0xFFF8F8FF),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(30.0),
            child: AppBar(
              backgroundColor: Colors.white30,
              elevation: 0,
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5.0, top: 10.0),
                  child: PopupMenuButton(
                    itemBuilder: (context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        enabled: false,
                        child: Center(
                          child: Text(
                            "Settings",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: "URL",
                        child: Text('URL'),
                      ),
                      const PopupMenuItem<String>(
                        child: Text('Version 1.0.3'),
                      ),
                    ],
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                    onSelected: (value) {
                      if (value == "URL") {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => URL(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          body: ListView(
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage(
                    'assets/logo.png',
                  ),
                  height: 250,
                  width: 400,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                child: Text(
                  "Login Now",
                  style: TextStyle(
                    height: 1.2,
                    letterSpacing: 2.0,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(1.0, 0.0),
                        blurRadius: 0.0,
                        color: Colors.black,
                      ),
                      Shadow(
                        offset: Offset(1.0, 2.0),
                        blurRadius: 2.0,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 0, 10),
                child: Text(
                  "Please sign in to continue",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFFCCCCCC),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: userID,
                  cursorColor: CustomIcons.textField,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    focusColor: CustomIcons.textField,
                    prefixIcon: Icon(
                      CustomIcons.person,
                      color: CustomIcons.iconColor,
                    ),
                    hintText: 'User ID',
                    hintStyle: TextStyle(fontSize: 15, height: 1.4),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: CustomIcons.textField),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: TextField(
                  controller: password,
                  cursorColor: CustomIcons.textField,
                  obscureText: true,
                  decoration: InputDecoration(
                    focusColor: CustomIcons.textField,
                    prefixIcon: Icon(
                      CustomIcons.lock,
                      color: CustomIcons.iconColor,
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(fontSize: 15, height: 1.5),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: CustomIcons.textField),
                    ),
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: CustomIcons.buttonColor),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 20, 20),
                child: FlatButton(
                  color: CustomIcons.buttonColor,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    if (userID.text == "" ||
                        userID.text == null ||
                        userID.text.isEmpty ||
                        password.text == "" ||
                        password.text == null ||
                        password.text.isEmpty) {
                      ShowToast("Please, fill all fields");
                    } else {
                      this.userID.text = getPhoneNumber(this.userID.text);
                      var param = {
                        "userId": userID.text.toString(),
                        "password": password.text.toString()
                      };
                      showLoading();
                      this
                          .onlineSerives
                          .loginData(param)
                          .then((data) => {
                                if (data == true)
                                  {
                                    hideLoadingDialog(),
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => StoreScreen(),
                                      ),
                                    )
                                  }
                                else
                                  {
                                    hideLoadingDialog(),
                                  }
                              })
                          .catchError((err) => {hideLoadingDialog()});
                    }
                  },
                  textColor: CustomIcons.buttonText,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account?",
                      style:
                          TextStyle(color: CustomIcons.iconColor, fontSize: 15),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => Register(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: CustomIcons.buttonColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
