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
              width: MediaQuery.of(context).size.width,
              color: CustomIcons.appbarColor,
              height: 50,
              child: OutlineButton(
                color: CustomIcons.appbarColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Log Out",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
