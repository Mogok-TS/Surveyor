import 'package:Surveyor/outsideInsideNeighborhood.dart';
import 'package:Surveyor/stores.dart';
import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';

import 'assets/custom_icons_icons.dart';

class CheckNeighborhoodScreen extends StatefulWidget {
  final String shopName;
  final String shopPhone;
  final String address;
  final String regOrAss;
  final passData;
  CheckNeighborhoodScreen(
    this.shopName,
    this.shopPhone,
    this.address,
    this.regOrAss,
    this.passData,
  );
  @override
  _CheckNeighborhoodScreenState createState() => _CheckNeighborhoodScreenState();
}

class _CheckNeighborhoodScreenState extends State<CheckNeighborhoodScreen> {
  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => StoreScreen()),
                  );
    return false; // return true if the route to be popped
}
  TextStyle cardHeader(){
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
  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
          child: Scaffold(
        
        drawer: MainMenuWidget(),
        appBar: AppBar(
          backgroundColor: CustomIcons.appbarColor,
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 10),

                child:  Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: (){
                            Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => OutsideInsideNeighborhood(true,true,true,true,this.widget.shopName, this.widget.shopPhone, this.widget.address, this.widget.regOrAss, this.widget.passData)),
                    );
                          },
                                                child: ListTile(
                            title: Container(
                                      margin: EdgeInsets.only(top: 10, bottom: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Neighborhood"),
                                          Text("Outside of Store"),
                                          Text("Inside of Store"),
                                          Text("Store Operator"),
                                        ],
                                      ),
                                     
                          )
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),

                child:  Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        InkWell(
                         onTap: (){
                            Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => OutsideInsideNeighborhood(true,true,false,false,this.widget.shopName, this.widget.shopPhone, this.widget.address, this.widget.regOrAss, this.widget.passData)),
                    );
                          },
                                                child: ListTile(
                            title: Container(
                                      margin: EdgeInsets.only(top: 10, bottom: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Neighborhood"),
                                          Text("Outside of Store"),
                                        ],
                                      ),
                                     
                          )
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),

                child:  Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        InkWell(
                         onTap: (){
                            Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => OutsideInsideNeighborhood(true,true,true,false,this.widget.shopName, this.widget.shopPhone, this.widget.address, this.widget.regOrAss, this.widget.passData)),
                    );
                          },
                                                child: ListTile(
                            title: Container(
                                      margin: EdgeInsets.only(top: 10, bottom: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Neighborhood"),
                                          Text("Outside of Store"),
                                          Text("Inside of Store"),
                                         
                                        ],
                                      ),
                                     
                          )
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),

                child:  Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        InkWell(
                       
                            onTap: (){
                            Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => OutsideInsideNeighborhood(true,false,false,false,this.widget.shopName, this.widget.shopPhone, this.widget.address, this.widget.regOrAss, this.widget.passData)),
                    );
                          },
                          
                                                child: ListTile(
                            title: Container(
                                      margin: EdgeInsets.only(top: 10, bottom: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Neighborhood"),
                                          
                                        ],
                                      ),
                                     
                          )
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),

                child:  Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: (){
                            Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => OutsideInsideNeighborhood(false,true,true,true,this.widget.shopName, this.widget.shopPhone, this.widget.address, this.widget.regOrAss, this.widget.passData)),
                    );
                          },
                                                child: ListTile(
                            title: Container(
                                      margin: EdgeInsets.only(top: 10, bottom: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Outside of Store"),
                                          Text("Inside of Store"),
                                          Text("Store Operator"),
                                        ],
                                      ),
                                     
                          )
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
              title: new Container(),
            ),
          ],
        ),
      ),
        onWillPop: () async => false,

    );
  }
}