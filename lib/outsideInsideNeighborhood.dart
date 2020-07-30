import 'package:Surveyor/neighborhoodSurvey.dart';
import 'package:Surveyor/stores.dart';
import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';

import 'assets/custom_icons_icons.dart';

class OutsideInsideNeighborhood extends StatefulWidget {
  final String shopName;
  final String shopPhone;
  final String address;
  final String regOrAss;
  var passData;

  OutsideInsideNeighborhood(
    this.shopName,
    this.shopPhone,
    this.address,
    this.regOrAss,
    this.passData,
  );

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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xFFF8F8FF),
        drawer: MainMenuWidget(),
        appBar: AppBar(
          backgroundColor: CustomIcons.appbarColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                
                Container(
                  width: 700,
                  color: Colors.grey[200],
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    child: Column(
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
                          this.widget.shopPhone,
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
                                            this.widget.shopName,
                                            this.widget.shopPhone,
                                            this.widget.address,
                                            "This is text for the instruciotns",
                                            "Neighborhood Survey",
                                            this.widget.regOrAss,
                                            this.widget.passData),
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
                                            this.widget.shopPhone,
                                            this.widget.address,
                                            "This is text for the instruciotns",
                                            "Neighborhood Survey",
                                            this.widget.regOrAss,
                                            this.widget.passData),
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
                                            this.widget.shopPhone,
                                            this.widget.address,
                                            "This is text for the instruciotns",
                                            "Neighborhood Survey",
                                            this.widget.regOrAss,
                                            this.widget.passData),
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
                                            this.widget.shopPhone,
                                            this.widget.address,
                                            "This is text for the instruciotns",
                                            "Neighborhood Survey",
                                            this.widget.regOrAss,
                                            this.widget.passData),
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
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15),
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
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
