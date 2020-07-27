import 'package:flutter/material.dart';
import 'package:Surveyor/Services/Messages/Messages.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';
import 'package:Surveyor/assets/custom_icons_icons.dart';
import 'package:localstorage/localstorage.dart';

class URL extends StatefulWidget {
  @override
  _myURL createState() => _myURL();
}

// ignore: camel_case_types
class _myURL extends State<URL> {
  OnlineSerives onlineSerives = new OnlineSerives();
  TextEditingController url = new TextEditingController();
  LocalStorage storage = new LocalStorage('Surveyor');

  @override
  void initState() {
    super.initState();
    this.url.text = this.storage.getItem("URL");
    if (this.url.text == null || this.url.text.isEmpty) {
      this.url.text =
          "http://52.255.142.115:8084/madbrepositorydev/";
      this.storage.setItem('URL', "http://52.255.142.115:8084/madbrepositorydev/");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8FF),
      appBar: AppBar(
        backgroundColor: CustomIcons.appbarColor,
        title: Text("URL"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            child: TextField(
              controller: url,
              cursorColor: CustomIcons.textField,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                focusColor: CustomIcons.textField,
                hintText: 'URL',
                hintStyle: TextStyle(fontSize: 15, height: 1.4),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomIcons.textField),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 15, 20, 20),
            child: FlatButton(
              color: CustomIcons.buttonColor,
              padding: EdgeInsets.all(10),
              child: Text(
                "Update",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                if(this.url.text == "" || this.url.text == null || this.url.text.isEmpty){
                  ShowToast("Please fill URL field");
                }else{
                  this.storage.setItem("URL", this.url.text);
                  Navigator.pop(context);
                }
              },
              textColor: CustomIcons.buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
