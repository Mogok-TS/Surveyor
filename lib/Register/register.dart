import 'package:flutter/material.dart';
import 'package:Surveyor/Register/login.dart';
import 'package:Surveyor/Services/Loading/LoadingServices.dart';
import 'package:Surveyor/Services/Messages/Messages.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';
import 'package:Surveyor/assets/custom_icons_icons.dart';
import 'package:load/load.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController userName = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();
  OnlineSerives onlineSerives = new OnlineSerives();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white10,
        leading: IconButton(
          iconSize: 25,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Text(
                "Create Account",
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
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: userName,
                cursorColor: CustomIcons.textField,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    CustomIcons.person,
                    color: CustomIcons.iconColor,
                  ),
                  hintText: 'Name',
                  hintStyle: TextStyle(fontSize: 15, height: 1.4),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CustomIcons.textField),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                controller: phoneNumber,
                cursorColor: CustomIcons.textField,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    CustomIcons.phonenumber,
                    color: CustomIcons.iconColor,
                  ),
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(fontSize: 15, height: 1.4),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CustomIcons.textField),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                controller: password,
                cursorColor: CustomIcons.textField,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    CustomIcons.lock,
                    color: CustomIcons.iconColor,
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(fontSize: 15, height: 1.4),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CustomIcons.textField),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                controller: confirmPassword,
                cursorColor: CustomIcons.textField,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    CustomIcons.lock,
                    color: CustomIcons.iconColor,
                  ),
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(fontSize: 15, height: 1.4),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CustomIcons.textField),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: FlatButton(
                color: CustomIcons.buttonColor,
                padding: EdgeInsets.all(10),
                child: Text(
                  "SING UP",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  if (this.userName.text == "" ||
                      this.userName.text == null ||
                      this.userName.text.isEmpty ||
                      this.phoneNumber.text == "" ||
                      this.phoneNumber.text == null ||
                      this.phoneNumber.text.isEmpty ||
                      this.password.text == "" ||
                      this.password.text == null ||
                      this.password.text.isEmpty ||
                      this.confirmPassword.text == "" ||
                      this.confirmPassword.text == null ||
                      this.confirmPassword.text.isEmpty) {
                    ShowToast("Please, fill all fields");
                  } else {
                    if (this.password.text != this.confirmPassword.text) {
                      ShowToast("Password doesn't match.");
                    } else {
                      var phone = this.phoneNumber.text.substring(0, 4);
                      print("data->" + phone);
                      if (phone.contains("+959")) {
                      } else if (phone.contains("959")) {
                        this.phoneNumber.text = "+" + this.phoneNumber.text;
                      } else if (phone.contains("09")) {
                        this.phoneNumber.text = "+959" +
                            this
                                .phoneNumber
                                .text
                                .substring(2, this.phoneNumber.text.length);
                      } else {
                        this.phoneNumber.text = "+959" + this.phoneNumber.text;
                      }
                      var data = {
                        "userId": this.phoneNumber.text.toString(),
                        "userName": this.userName.text.toString(),
                        "password": this.confirmPassword.text.toString(),
                      };
                      print('data-> $data');
                      showLoading();
                      this
                          .onlineSerives
                          .createNewUser(data)
                          .then((data) => {
                        hideLoadingDialog(),
                        if (data == true)
                          {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            )
                          }
                      })
                          .catchError((err) => {print(err)});
                    }
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
                    "Already have an account?",
                    style: TextStyle(color: CustomIcons.iconColor, fontSize: 15),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Login now",
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
    );
  }
}
