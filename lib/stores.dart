import 'package:Surveyor/outsideInsideNeighborhood.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'Map/map.dart';
import 'assets/custom_icons_icons.dart';
import 'stores_details.dart';
import 'widgets/mainmenuwidgets.dart';


class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final LocalStorage storage = new LocalStorage('Surveyor');
  var storeData, storeRegistration, assignStores;
  bool showAssignStore = false;
  bool showRegisterStore = false;

  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(color: CustomIcons.dropDownHeader),
    );
  }

  Widget buildAssignItem(
      String storeName, String phone, String address, dynamic data) {
    return Container(
      color: Colors.grey[200],
      child: Card(
        child: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                  title: Text(
                    storeName,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      ),
                      Text(
                        phone,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Text(
                        address,
                        style: TextStyle(height: 1.3),
                      ),
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
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OutsideInsideNeighborhood(storeName, phone, address,"none"),
                                      ),
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      "Start",
                                      style: TextStyle(),
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
    );
  }

  Widget buildRegisterItem(String storeName, String phone, String address) {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(1),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(2),
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
                                      style: TextStyle(),
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
                                      "Continue",
                                      style: TextStyle(),
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
    );
  }

  @override
  void initState() {
    super.initState();
    this.storeData = this.storage.getItem("storeData");
    this.assignStores = this.storeData["shopsByUser"];
//    this.assignStores = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainMenuWidget(),
        appBar: AppBar(
          backgroundColor: CustomIcons.appbarColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.map),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Gmap(),
                  ),
                );
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: CustomIcons.dropDownHeader,
                      child: ListTile(
                        title: InkWell(
                          onTap: () {
                            setState(() {
                              showAssignStore = !showAssignStore;
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Assign Stores",
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "5/" + this.assignStores.length.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            showAssignStore = !showAssignStore;
                          });
                        },
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                          children: <Widget>[
                            IconButton(
                              color: Colors.black,
                              icon: Icon(Icons.sort),
                              onPressed: () {},
                            ), // icon-1
                            IconButton(
                              color: Colors.black,
                              icon: showAssignStore == true
                                  ? Icon(Icons.keyboard_arrow_down)
                                  : Icon(Icons.chevron_right),
                              onPressed: () {
                                setState(() {
                                  showAssignStore = !showAssignStore;
                                });
                              },
                            ) // icon-2
                          ],
                        ),
                      ),
                    ),
                    Container(
                        child: showAssignStore == true
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  this.assignStores.length == 0
                                      ? Row(
                                          children: <Widget>[
                                            Expanded(
                                              child:Container(
                                                height: 50,
                                                color: Colors.grey[200],
                                                child: Center(
                                                  child: Text(
                                                    "No Data",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Column(
                                          children: <Widget>[
                                            for (var i = 0;
                                                i < this.assignStores.length;
                                                i++)
                                              buildAssignItem(
                                                  this
                                                          .assignStores[i]
                                                              ["shopname"]
                                                          .toString() +
                                                      "( " +
                                                      this
                                                          .assignStores[i]
                                                              ["shopnamemm"]
                                                          .toString() +
                                                      " )",
                                                  this
                                                      .assignStores[i]
                                                          ["phoneno"]
                                                      .toString(),
                                                  this
                                                      .assignStores[i]
                                                          ["address"]
                                                      .toString(),
                                                  this.assignStores[i])
                                          ],
                                        ),
                                ],
                              )
                            : new Container())
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: CustomIcons.dropDownHeader,
                      child: ListTile(
                        title: InkWell(
                          onTap: () {
                            setState(() {
                              showRegisterStore = !showRegisterStore;
                            });
                          },
                          child: Text(
                            "Store Registration",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            showRegisterStore = !showRegisterStore;
                          });
                        },
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                          children: <Widget>[
                            IconButton(
                              color: Colors.black,
                              icon: Icon(Icons.sort),
                              onPressed: () {},
                            ), // icon-1
                            IconButton(
                              color: Colors.black,
                              icon: showRegisterStore == true
                                  ? Icon(Icons.keyboard_arrow_down)
                                  : Icon(Icons.chevron_right),
                              onPressed: () {
                                setState(() {
                                  showRegisterStore = !showRegisterStore;
                                });
                              },
                            ) // icon-2
                          ],
                        ),
                      ),
                    ),
                    Container(
                        child: showRegisterStore == true
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  buildRegisterItem(
                                      "Malar Myaing",
                                      "09771399559",
                                      "Beside Mandalay Highway Pa/2-270, Panma Qtr, Kyatpyin, Mogok 05092"),
                                  buildRegisterItem(
                                      "Malar Myaing",
                                      "09771399559",
                                      "Beside Mandalay Highway Pa/2-270, Panma Qtr, Kyatpyin, Mogok 05092"),
                                ],
                              )
                            : new Container())
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Colors.white,
                        shape: buttonShape(),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StoresDetailsScreen()));
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add_box,
                              color: Colors.black,
                            ),
                            Text(" Add New Store",
                                style: TextStyle(
                                  color: Colors.black,
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
        ));
  }
}
