import 'package:Surveyor/assets/custom_icons_icons.dart';
import 'package:Surveyor/stores.dart';
import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:localstorage/localstorage.dart';



class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var appBar = AppBar();
  LocalStorage storage = new LocalStorage('Surveyor');
  var userData = {};

  @override
  void initState() {
    super.initState();
    userData = this.storage.getItem("loginData");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomIcons.appbarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => StoreScreen(),
              ),
            );
          },
        ),
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Row(children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [ CustomIcons.appbarColor, Colors.yellow])),
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height) /
                      3,
                ),
                FittedBox(
                  child: Container(
                    transform: Matrix4.translationValues(
                        0.0, -appBar.preferredSize.height, 0.0),
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Column(
                        children: [
                          Container(
                            transform: Matrix4.translationValues(
                                0.0, -appBar.preferredSize.height, 0.0),
                            width: 150,
                            height: 150,
                            child: Card(
                              color: Colors.white10,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    AssetImage('assets/profile.png'),
                              ),
                            ),
                          ),
                          Container(
                            transform: Matrix4.translationValues(
                                0.0, -appBar.preferredSize.height, 0.0),
                            padding: EdgeInsets.only(top: 0, left: 50),
                            // color: Colors.red,
                            child: Column(
                              children: [
                                SizedBox(height: appBar.preferredSize.height - 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name",
                                      style: TextStyle(color: Colors.black,fontSize: 19),

                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                        ":",
                                      style: TextStyle(color: Colors.black,fontSize: 19),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      userData["userName"],
                                      style: TextStyle(fontSize: 18, color: Colors.black54),
                                    )
                                  ],
                                ),
                                SizedBox(height: appBar.preferredSize.height - 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Phone",
                                      style: TextStyle(color: Colors.black,fontSize: 19),

                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      ":",
                                      style: TextStyle(color: Colors.black,fontSize: 19),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "+" + userData["userId"],
                                      style: TextStyle(fontSize: 18, color: Colors.black54),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
