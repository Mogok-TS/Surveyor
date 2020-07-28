import 'package:Surveyor/neighborhoodSurvey.dart';
import 'package:Surveyor/stores.dart';
import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';

import 'assets/custom_icons_icons.dart';

class StoreData extends StatefulWidget {
  final String name;
  final String shopName;
  final String phNumber;
  final String ownerName;
  final String ownerPhone;
  final String street;
  final String plusCode;
  var passData;

  StoreData(this.name, this.shopName, this.phNumber, this.ownerName,
      this.ownerPhone, this.street, this.plusCode, this.passData);

  @override
  _StoreDataState createState() => _StoreDataState();
}

class _StoreDataState extends State<StoreData> {
  String serveytype;
  OnlineSerives onlineSerives = new OnlineSerives();

  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(color: CustomIcons.dropDownHeader),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8FF),
      drawer: MainMenuWidget(),
      appBar: AppBar(
        backgroundColor: CustomIcons.appbarColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: 700,
                color: Colors.grey[200],
                child: Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        this.widget.shopName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        this.widget.phNumber,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        this.widget.street,
                        style: TextStyle(height: 1.3),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NeighborhoodSurveyScreen(
                                          this.widget.shopName,
                                          this.widget.phNumber,
                                          this.widget.street,
                                          "This is text for the instruciotns",
                                          "Neighborhood Survey"),
                                ),
                              );
                            },
                            title: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Neighborhood",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                      Expanded(
                                        child: Container(
                                          child: RaisedButton(
                                            color: Colors.white,
                                            shape: buttonShape(),
                                            onPressed: () {},
                                            child: Center(
                                              child: Text(
                                                "x Items remaining",
                                                style: TextStyle(
                                                    color: CustomIcons
                                                        .appbarColor),
                                              ),
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
              ),
              Container(
                child: Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NeighborhoodSurveyScreen(
                                          this.widget.shopName,
                                          this.widget.phNumber,
                                          this.widget.street,
                                          "This is text for the instruciotns",
                                          "Outside of Store"),
                                ),
                              );
                            },
                            title: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Outside of store",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                      Expanded(
                                        child: Container(
                                          child: RaisedButton(
                                            color: Colors.white,
                                            shape: buttonShape(),
                                            onPressed: () {},
                                            child: Center(
                                              child: Text(
                                                "x Items remaining",
                                                style: TextStyle(
                                                    color: CustomIcons
                                                        .appbarColor),
                                              ),
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
              ),
              Container(
                child: Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NeighborhoodSurveyScreen(
                                          this.widget.shopName,
                                          this.widget.phNumber,
                                          this.widget.street,
                                          "This is text for the instruciotns",
                                          "Inside of Store"),
                                ),
                              );
                            },
                            title: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Inside of Store",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                      Expanded(
                                        child: Container(
                                          child: RaisedButton(
                                            color: Colors.white,
                                            shape: buttonShape(),
                                            onPressed: () {},
                                            child: Center(
                                              child: Text(
                                                "x Items remaining",
                                                style: TextStyle(
                                                    color: CustomIcons
                                                        .appbarColor),
                                              ),
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
              ),
              Container(
                child: Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NeighborhoodSurveyScreen(
                                          this.widget.shopName,
                                          this.widget.phNumber,
                                          this.widget.street,
                                          "This is text for the instruciotns",
                                          "Store Operator"),
                                ),
                              );
                            },
                            title: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Store Operator",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                      Expanded(
                                        child: Container(
                                          child: RaisedButton(
                                            color: Colors.white,
                                            shape: buttonShape(),
                                            onPressed: () {},
                                            child: Center(
                                              child: Text(
                                                "x Items remaining",
                                                style: TextStyle(
                                                    color: CustomIcons
                                                        .appbarColor),
                                              ),
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
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: new BottomNavigationBar(
        backgroundColor: CustomIcons.appbarColor,
        items: [
          new BottomNavigationBarItem(
            icon: new Container(),
            title: InkWell(
              onTap: () {
                print("asdfasdfasdf");
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => StoreScreen()),
                );
              },
              child: Container(
                height: 40,
                width: 300,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Center(
                  child: new Text(
                    "Back",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          new BottomNavigationBarItem(
            icon: new Container(),
            title: new Container(),
          ),
          new BottomNavigationBarItem(
            icon: new Container(),
            title: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => StoreScreen()));
              },
              child: Container(
                height: 40,
                width: 300,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Center(
                  child: new Text(
                    "Done",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OutsideInsideNeighborhood extends StatefulWidget {
  final String storeName;
  final String storeNumber;
  final String address;
  final String surveyType;

  OutsideInsideNeighborhood(
      this.storeName, this.storeNumber, this.address, this.surveyType);

  @override
  _OutsideInsideNeighborhoodState createState() =>
      _OutsideInsideNeighborhoodState();
}

class _OutsideInsideNeighborhoodState extends State<OutsideInsideNeighborhood> {
  String serveytype;
  OnlineSerives onlineSerives = new OnlineSerives();

  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(color: CustomIcons.dropDownHeader),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8FF),
      drawer: MainMenuWidget(),
      appBar: AppBar(
        backgroundColor: CustomIcons.appbarColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.grey[200],
                child: Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        this.widget.storeName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        this.widget.storeNumber,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        this.widget.address,
                        style: TextStyle(height: 1.3),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NeighborhoodSurveyScreen(
                                          this.widget.storeName,
                                          this.widget.storeNumber,
                                          this.widget.address,
                                          "This is text for the instruciotns",
                                          "Neighborhood Survey"),
                                ),
                              );
                            },
                            title: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Neighborhood",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                      Expanded(
                                        child: Container(
                                          child: RaisedButton(
                                            color: Colors.white,
                                            shape: buttonShape(),
                                            onPressed: () {},
                                            child: Center(
                                              child: Text(
                                                "x Items remaining",
                                                style: TextStyle(
                                                    color: CustomIcons
                                                        .appbarColor),
                                              ),
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
              ),
              Container(
                child: Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NeighborhoodSurveyScreen(
                                          this.widget.storeName,
                                          this.widget.storeNumber,
                                          this.widget.address,
                                          "This is text for the instruciotns",
                                          "Outside of Store"),
                                ),
                              );
                            },
                            title: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Outside of store",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                      Expanded(
                                        child: Container(
                                          child: RaisedButton(
                                            color: Colors.white,
                                            shape: buttonShape(),
                                            onPressed: () {},
                                            child: Center(
                                              child: Text(
                                                "x Items remaining",
                                                style: TextStyle(
                                                    color: CustomIcons
                                                        .appbarColor),
                                              ),
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
              ),
              Container(
                child: Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NeighborhoodSurveyScreen(
                                          this.widget.storeName,
                                          this.widget.storeNumber,
                                          this.widget.address,
                                          "This is text for the instruciotns",
                                          "Inside of Store"),
                                ),
                              );
                            },
                            title: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Inside of Store",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                      Expanded(
                                        child: Container(
                                          child: RaisedButton(
                                            color: Colors.white,
                                            shape: buttonShape(),
                                            onPressed: () {},
                                            child: Center(
                                              child: Text(
                                                "x Items remaining",
                                                style: TextStyle(
                                                    color: CustomIcons
                                                        .appbarColor),
                                              ),
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
              ),
              Container(
                child: Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NeighborhoodSurveyScreen(
                                          this.widget.storeName,
                                          this.widget.storeNumber,
                                          this.widget.address,
                                          "This is text for the instruciotns",
                                          "Store Operator"),
                                ),
                              );
                            },
                            title: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Store Operator",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                                      Expanded(
                                        child: Container(
                                          child: RaisedButton(
                                            color: Colors.white,
                                            shape: buttonShape(),
                                            onPressed: () {},
                                            child: Center(
                                              child: Text(
                                                "x Items remaining",
                                                style: TextStyle(
                                                    color: CustomIcons
                                                        .appbarColor),
                                              ),
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
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: new BottomNavigationBar(
        backgroundColor: CustomIcons.appbarColor,
        items: [
          new BottomNavigationBarItem(
            icon: new Container(),
            title: InkWell(
              onTap: () {
                print("asdfasdfasdf");
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => StoreScreen()),
                );
              },
              child: Container(
                height: 40,
                width: 300,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Center(
                  child: new Text(
                    "Back",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white,fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
          new BottomNavigationBarItem(
            icon: new Container(),
            title: new Container(),
          ),
          new BottomNavigationBarItem(
            icon: new Container(),
            title: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => StoreScreen()));
              },
              child: Container(
                height: 40,
                width: 300,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Center(
                  child: new Text(
                    "Done",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white,fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
