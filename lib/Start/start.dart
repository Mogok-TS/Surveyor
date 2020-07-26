import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';
import '../assets/custom_icons_icons.dart';

class Start extends StatefulWidget {
  final String storeName;
  final String storeNumber;
  final String hour;

  Start(this.storeName, this.storeNumber, this.hour);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(color: CustomIcons.dropDownHeader),
    );
  }

  Widget buildAssignItem(String storeName, String phone, String address) {
    return Container(
      color: Colors.grey[200],
      child: Card(
        child: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                  title: Text(storeName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(phone),
                      Text(address),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: RaisedButton(
                                  color: Colors.white,
                                  shape: buttonShape(),
                                  onPressed: () {},
                                  child: Center(
                                    child: Text(
                                      "Status",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: RaisedButton(
                                color: Colors.white,
                                shape: buttonShape(),
                                onPressed: () {},
                                child: Center(
                                  child: Text(
                                    "Items remaing",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainMenuWidget(),
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          Container(
            height: 100,
            color: Colors.grey[200],
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              child: ListView(
                children: <Widget>[
                  Text(
                    this.widget.storeName,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    this.widget.storeNumber,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "10:20 PM",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0),
            child: Column(
              children: <Widget>[
                Container(
                  color: CustomIcons.dropDownHeader,
                  child: ListTile(
                    title: InkWell(
                      onTap: () {},
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Neighborhood",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      buildAssignItem("Malar Myaing", "09771399559",
                          "Beside Mandalay Highway Pa/2-270, Panma Qtr, Kyatpyin, Mogok 05092"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
            child: Column(
              children: <Widget>[
                Container(
                  color: CustomIcons.dropDownHeader,
                  child: ListTile(
                    title: InkWell(
                      onTap: () {},
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Outside of Store",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      buildAssignItem("Malar Myaing", "09771399559",
                          "Beside Mandalay Highway Pa/2-270, Panma Qtr, Kyatpyin, Mogok 05092"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
            child: Column(
              children: <Widget>[
                Container(
                  color: CustomIcons.dropDownHeader,
                  child: ListTile(
                    title: InkWell(
                      onTap: () {},
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Inside of Store",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      buildAssignItem("Malar Myaing", "09771399559",
                          "Beside Mandalay Highway Pa/2-270, Panma Qtr, Kyatpyin, Mogok 05092"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
            child: Column(
              children: <Widget>[
                Container(
                  color: CustomIcons.dropDownHeader,
                  child: ListTile(
                    title: InkWell(
                      onTap: () {},
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Store Operator",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      buildAssignItem("Malar Myaing", "09771399559",
                          "Beside Mandalay Highway Pa/2-270, Panma Qtr, Kyatpyin, Mogok 05092"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        backgroundColor: CustomIcons.appbarColor,
        items: [
          new BottomNavigationBarItem(
            icon: new Container(),
            title: new Text(
              "Back",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          new BottomNavigationBarItem(
            icon: new Container(),
            title: new Container(),
          ),
          new BottomNavigationBarItem(
            icon: new Container(),
            title: new Text(
              "Done",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
