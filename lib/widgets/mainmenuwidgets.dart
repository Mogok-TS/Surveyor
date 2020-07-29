import 'package:flutter/material.dart';
import 'package:Surveyor/Register/login.dart';
import 'package:localstorage/localstorage.dart';

class MainMenuWidget extends StatelessWidget {
  final LocalStorage storage = new LocalStorage('Surveyor');
  Widget buildListTile(String title, IconData icon, Function tabHandler) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: Icon(
          icon,
          size: 26,
          color: Colors.blue,
        ),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
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
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 25,
            ),

            SizedBox(
              height: 5,
            ),
            // buildListTile('Setting', Icons.settings, () {}),
            // buildListTile('Pravicy', Icons.security, () {}),
            // buildListTile('Notifications', Icons.notifications, () {}),
            // buildListTile('Useful Links', Icons.stars, () {}),
            // buildListTile('Report An Issue', Icons.bug_report, () {}),
            buildListTile('Log Out', Icons.input, () {
              this.storage.deleteItem("Surveyor");
              this.storage.deleteItem("storeData");
              this.storage.deleteItem("storeReg");
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
