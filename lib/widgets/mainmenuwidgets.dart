import 'package:Surveyor/Profile/profile.dart';
import 'package:Surveyor/assets/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:Surveyor/Register/login.dart';
import 'package:localstorage/localstorage.dart';

class MainMenuWidget extends StatelessWidget {
  final LocalStorage storage = new LocalStorage('Surveyor');
  Widget buildListTile(String title, IconData icon, Function tabHandler) {
    return Card(
      elevation: 5,
      color: CustomIcons.appbarColor,
      child: ListTile(
        leading: Icon(
          icon,
          size: 26,
          color: Colors.white,
        ),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onTap: () {
          tabHandler();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Column(
              children: <Widget>[
                Container(
                  color: CustomIcons.appbarColor,
                  width: 305,
                  height: 200,
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/logo.png'),
                      height: 80,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: Colors.black26),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => Profile(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Profile"),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border(
                //       bottom: BorderSide(width: 1, color: Colors.black26),
                //     ),
                //   ),
                //   child: ListTile(
                //     leading: Icon(Icons.shopping_basket),
                //     title: Text("Order List"),
                //     trailing: Icon(Icons.chevron_right),
                //   ),
                // ),
              ],
            )),
            Container(
              color: CustomIcons.appbarColor,
              height: 50,
              child: OutlineButton(
                onPressed: () {
                  this.storage.deleteItem("Surveyor");
                  this.storage.deleteItem("storeData");
                  this.storage.deleteItem("storeReg");
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Log Out",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                highlightedBorderColor: Colors.orange,
                color: CustomIcons.appbarColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
