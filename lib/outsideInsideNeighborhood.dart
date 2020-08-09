import 'package:Surveyor/checkNeighborhood.dart';
import 'package:Surveyor/neighborhoodSurvey.dart';
import 'package:Surveyor/stores.dart';
import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';

import 'assets/custom_icons_icons.dart';

class OutsideInsideNeighborhood extends StatefulWidget {
  final bool isNeighborhood;
  final bool isOutside;
  final bool isInside;
  final bool isStoreOperater;
  final String shopName;
  final String shopPhone;
  final String address;
  final String regOrAss;
  final passData;
  final question;
  OutsideInsideNeighborhood(
    this.isNeighborhood,
    this.isOutside,
    this.isInside,
    this.isStoreOperater,
    this.shopName,
    this.shopPhone,
    this.address,
    this.regOrAss,
    this.passData,
    this.question
  );

  @override
  _OutsideInsideNeighborhoodState createState() =>
      _OutsideInsideNeighborhoodState();
}

class _OutsideInsideNeighborhoodState extends State<OutsideInsideNeighborhood> {
  String serveytype;
  OnlineSerives onlineSerives = new OnlineSerives();
  TextStyle cardHeader() {
    return TextStyle(
      height: 1.2,
      letterSpacing: 2.0,
      fontSize: 30,
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
    );
  }

  Widget _statusButton(String text) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(9),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0XFFE0E0E0)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _remainButton(text) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(9),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Color(0XFFE0E0E0),
              width: 1.0,
            ),
            top: BorderSide(
              color: Color(0XFFE0E0E0),
              width: 1.0,
            ),
            bottom: BorderSide(
              color: Color(0XFFE0E0E0),
              width: 1.0,
            ),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: CustomIcons.appbarColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

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
                if(this.widget.isNeighborhood == true)
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
                                            this.widget.isNeighborhood,
                                            this.widget.isOutside,
                                            this.widget.isInside,
                                            this.widget.isStoreOperater,
                                            this.widget.shopName,
                                            this.widget.shopPhone,
                                            this.widget.address,
                                            "This is text for the instruciotns",
                                            "Neighborhood Survey",
                                            this.widget.regOrAss,
                                            this.widget.passData,
                                            this.widget.question
                                            ),
                                  ),
                                );
                              },
                              title: Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 10),
                                  child: Text(
                                    "Neighborhood",
                                    style: cardHeader(),
                                  )),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: _statusButton("Status"),
                                        ),
                                        Expanded(
                                            child: _remainButton(
                                                "x Items remaining")),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                if(this.widget.isOutside == true)
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
                                            this.widget.isNeighborhood,
                                            this.widget.isOutside,
                                            this.widget.isInside,
                                            this.widget.isStoreOperater,
                                            this.widget.shopName,
                                            this.widget.shopPhone,
                                            this.widget.address,
                                            "This is text for the instruciotns",
                                            "Outside of store",
                                            this.widget.regOrAss,
                                            this.widget.passData,
                                            this.widget.question
                                            ),
                                  ),
                                );
                              },
                              title: Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 10),
                                  child: Text(
                                    "Outside of store",
                                    style: cardHeader(),
                                  )),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: _statusButton("Status"),
                                        ),
                                        Expanded(
                                            child: _remainButton(
                                                "x Items remaining")),
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
                if(this.widget.isInside == true)
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
                                            this.widget.isNeighborhood,
                                            this.widget.isOutside,
                                            this.widget.isInside,
                                            this.widget.isStoreOperater,
                                            this.widget.shopName,
                                            this.widget.shopPhone,
                                            this.widget.address,
                                            "This is text for the instruciotns",
                                            "Inside of Store",
                                            this.widget.regOrAss,
                                            this.widget.passData,
                                            this.widget.question
                                            ),
                                  ),
                                );
                              },
                              title: Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 10),
                                  child: Text(
                                    "Inside of Store",
                                    style: cardHeader(),
                                  )),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: _statusButton("Status"),
                                        ),
                                        Expanded(
                                            child: _remainButton(
                                                "x Items remaining")),
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
                if(this.widget.isStoreOperater == true)
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
                                            this.widget.isNeighborhood,
                                            this.widget.isOutside,
                                            this.widget.isInside,
                                            this.widget.isStoreOperater,
                                            this.widget.shopName,
                                            this.widget.shopPhone,
                                            this.widget.address,
                                            "This is text for the instruciotns",
                                            "Store Operator",
                                            this.widget.regOrAss,
                                            this.widget.passData,
                                            this.widget.question),
                                  ),
                                );
                              },
                              title: Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 10),
                                  child: Text(
                                    "Store Operator",
                                    style: cardHeader(),
                                  )),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: _statusButton("Status"),
                                        ),
                                        Expanded(
                                            child: _remainButton(
                                                "x Items remaining")),
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
                    MaterialPageRoute(builder: (context) => CheckNeighborhoodScreen(this.widget.shopName,this.widget.shopPhone,this.widget.address,this.widget.regOrAss,this.widget.passData)),
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
