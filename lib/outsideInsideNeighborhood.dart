import 'package:Surveyor/neighborhoodSurvey.dart';
import 'package:Surveyor/stores.dart';
import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';

import 'assets/custom_icons_icons.dart';

class OutsideInsideNeighborhood extends StatefulWidget {
  final String storeName;
  final String storeNumber;
  final String address;
  OutsideInsideNeighborhood(this.storeName, this.storeNumber, this.address);
  @override
  _OutsideInsideNeighborhoodState createState() =>
      _OutsideInsideNeighborhoodState();
}

class _OutsideInsideNeighborhoodState extends State<OutsideInsideNeighborhood> {
  
  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(color: CustomIcons.dropDownHeader),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainMenuWidget(),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
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
                    this.widget.address,
                    style: TextStyle(fontWeight: FontWeight.w600),
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
                          onTap: (){
                            Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NeighborhoodSurveyScreen("Satisfied","This is text for the instruciotns"),
                                      ),
                                    );
                          },
                            title: Container(
                              margin: EdgeInsets.only(top: 10,bottom: 10),
                                child: Text(
                              "Neighborhood",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                                                "13 Items remaining",
                                                style: TextStyle(color: CustomIcons.appbarColor),
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
                            title: Container(
                              margin: EdgeInsets.only(top: 10,bottom: 10),
                                child: Text(
                              "Outside of store",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                                                "3 Items remaining",
                                                style: TextStyle(color: CustomIcons.appbarColor),
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
                            title: Container(
                              margin: EdgeInsets.only(top: 10,bottom: 10),
                                child: Text(
                              "Inside of store",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                                                "4 Items remaining",
                                                style: TextStyle(color: CustomIcons.appbarColor),
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
                            title: Container(
                              margin: EdgeInsets.only(top: 10,bottom: 10),
                                child: Text(
                              "Store Operator",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                                                "1 Items remaining",
                                                style: TextStyle(color: CustomIcons.appbarColor),
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
              onTap: (){
                Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StoreScreen(),
                                      ),
                                    );
              },
                          child: new Text(
                "Back",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
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
