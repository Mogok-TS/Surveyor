import 'package:Surveyor/Services/GeneralUse/Geolocation.dart';
import 'package:Surveyor/Services/Loading/LoadingServices.dart';
import 'package:Surveyor/Services/Messages/Messages.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';
import 'package:Surveyor/outsideInsideNeighborhood.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:localstorage/localstorage.dart';

import 'Map/map.dart';
import 'Services/GeneralUse/TodayDate.dart';
import 'assets/custom_icons_icons.dart';
import 'stores_details.dart';
import 'widgets/mainmenuwidgets.dart';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>  {
  final LocalStorage storage = new LocalStorage('Surveyor');
  var storeData;
  var assignStores = [];
  var storeRegistration = [];
  var count = "0";
  bool showAssignStore = false;
  bool showRegisterStore = false;
  var performType, performTypearray;
  OnlineSerives onlineSerives = new OnlineSerives();

  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(color: CustomIcons.dropDownHeader),
    );
  }

  Widget buildStatusText(array) {
    var status;
    Color textColor;
    for (var q = 0; q < array.length; q++) {
      if (array[q].toString() == "CHECKIN") {
        status = "In Progress";
        textColor = Color(0xFFe0ac08);
        break;
      } else {
        status = "Not Started";
        textColor = Colors.blue;
      }
    }
    return Text(
      status,
      style: TextStyle(
        color: textColor,
      ),
    );
  }

  Widget buildAssignItem(
      String storeName, String phone, String address, data) {
    this.performType = data["status"];
    this.performTypearray = this.performType["performType"];
//    print("${performTypearray}");
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
                                    child: Column(
                                      children: <Widget>[
                                        buildStatusText(this.performTypearray)
                                      ],
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
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OutsideInsideNeighborhood(storeName,
                                                phone, address, "none",[data]),
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

  Widget buildRegisterItem(
      String storeName, String phone, String address, data) {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(1),
      child: Card(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StoresDetailsScreen([data], false,"register"),
                                      ),
                                    );
                                  },
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
    var shopParam = {
      "spsyskey": "",
      "teamsyskey": "",
      "usertype": "",
      "date": ""
    };
    var loginData, newParam;
    loginData = this.storage.getItem("loginData");
    newParam = {"usersyskey": loginData["syskey"].toString()};
    shopParam["spsyskey"] = loginData["syskey"];
    shopParam["teamsyskey"] = loginData["teamSyskey"];
    shopParam["usertype"] = loginData["userType"];
    shopParam["date"] = getTodayDate();
    print("${shopParam}");
    Future.delayed(const Duration(milliseconds: 500), () {
      showLoading();
          this
              .onlineSerives
              .getStores(shopParam)
              .then((result) => {
            if (result == true)
              {
                this.onlineSerives.getsvrShoplist(newParam).then((res) => {
                  if (res == true)
                    {
                      this.storeData = this.storage.getItem("storeData"),
                      this.storeRegistration =
                          this.storage.getItem("storeReg"),
                      print("${storeRegistration}"),
                      this.assignStores = this.storeData["shopsByUser"],
                      setState(() {
                        this.count = this.assignStores.length.toString();
                      }),
                      hideLoadingDialog(),
                    }
                  else
                    {
                      this.assignStores = [],
                      hideLoadingDialog(),
                    }
                }),
              }
            else
              {
                this.storeRegistration = [],
                this.assignStores = [],
                hideLoadingDialog()
              }
          })
              .catchError((onError) => {hideLoadingDialog()});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingProvider(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Color(0xFFF8F8FF),
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
                                    "x/" + this.count,
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
                                                  child: Container(
                                                    height: 50,
                                                    color: Colors.grey[200],
                                                    child: Center(
                                                      child: Text(
                                                        "No Data",
                                                        textAlign:
                                                            TextAlign.center,
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
                                      this.storeRegistration.length == 0
                                          ? Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    height: 50,
                                                    color: Colors.grey[200],
                                                    child: Center(
                                                      child: Text(
                                                        "No Data",
                                                        textAlign:
                                                            TextAlign.center,
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
                                                    i <
                                                        this
                                                            .storeRegistration
                                                            .length;
                                                    i++)
                                                  buildRegisterItem(
                                                      this
                                                              .storeRegistration[
                                                                  i]["name"]
                                                              .toString() +
                                                          "( " +
                                                          this
                                                              .storeRegistration[
                                                                  i]["mmName"]
                                                              .toString() +
                                                          " )",
                                                      this
                                                          .storeRegistration[i]
                                                              ["phoneNumber"]
                                                          .toString(),
                                                      this
                                                          .storeRegistration[i]
                                                              ["address"]
                                                          .toString(),
                                                      this.storeRegistration[i])
                                              ],
                                            ),
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
                              getGPSstatus().then((status) => {
                                    print("$status"),
                                    if (status == true)
                                      {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StoresDetailsScreen([], false,"register"),
                                          ),
                                        ),
                                      }
                                    else
                                      {ShowToast("Please open GPS")}
                                  });
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
            )),
      ),
    );
  }
}
