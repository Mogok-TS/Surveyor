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
import 'package:load/load.dart';
import 'package:localstorage/localstorage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var items = [
    {'name': 'Settings', 'value': 0},
    {'name': 'URL', 'value': 1},
    {'name': 'Version 1.0.0', 'value': 2}
  ];

  final LocalStorage storage = new LocalStorage('Surveyor');
  TextEditingController userID = new TextEditingController();
  TextEditingController password = new TextEditingController();
  OnlineSerives onlineSerives = new OnlineSerives();

  @override
  Widget build(BuildContext context) {
    return LoadingProvider(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.topRight,
                child: PopupMenuButton(
                  itemBuilder: (context) {
                    var list = List<PopupMenuEntry<Object>>();
                    list.add(
                      PopupMenuItem(
                        enabled: false,  
                        child: Center(
                          child: Text(
                            "Settings",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    );
                    list.add(
                      PopupMenuDivider(
                        height: 10,
                      ),
                    );
                    list.add(
                      PopupMenuItem(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => URL(),
                              ),
                            );
                          },
                          child: Text("URL"),
                        ),
                      ),
                    );
                    list.add(
                      PopupMenuItem(
                        child: Text("Version 1.0.0"),
                      ),
                    );
                    return list;
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                ),
              ),
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
                      var phone = this.userID.text.substring(0, 4);
                      print("data->" + phone);
                      if (phone.contains("+959")) {
                      } else if (phone.contains("959")) {
                        this.userID.text = "+" + this.userID.text;
                      } else if (phone.contains("09")) {
                        this.userID.text = "+959" +
                            this
                                .userID
                                .text
                                .substring(2, this.userID.text.length);
                      } else {
                        this.userID.text = "+959" + this.userID.text;
                      }
                      var param = {
                        "userId": userID.text.toString(),
                        "password": password.text.toString()
                      };
                      var shopParam = {
                        "spsyskey": "",
                        "teamsyskey": "",
                        "usertype": "",
                        "date": ""
                      };
                      var loginData;
                      print('data-> $param');
                      showLoading();
                      this.onlineSerives.loginData(param).then((data) => {
                        if (data == true)
                          {
                            loginData = this.storage.getItem("loginData"),
                            shopParam["spsyskey"] = loginData["syskey"],
                            shopParam["teamsyskey"] = loginData["teamSyskey"],
                            shopParam["usertype"] = loginData["userType"],
                            shopParam["date"] = getTodayDate(),
                            print("${shopParam}"),
                            this.onlineSerives.getStores(shopParam).then((result) => {
                              hideLoadingDialog(),
                              if(result == true){
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => StoreScreen(),
                                  ),
                                )
                              }
                            }).catchError((onError)=> hideLoadingDialog()),
                          }else{
                          hideLoadingDialog(),
                        }
                      }).catchError((err)=>{
                        hideLoadingDialog()
                      });
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
