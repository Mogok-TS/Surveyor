import 'package:Surveyor/Services/GeneralUse/Geolocation.dart';
import 'package:Surveyor/Services/Loading/LoadingServices.dart';
import 'package:Surveyor/Services/Messages/Messages.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';
import 'package:Surveyor/checkNeighborhood.dart';
import 'package:Surveyor/outsideInsideNeighborhood.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:load/load.dart';
import 'package:localstorage/localstorage.dart';

import 'Map/map.dart';
import 'Services/GeneralUse/TodayDate.dart';
import 'Services/GeneralUse/CommonArray.dart';
import 'assets/custom_icons_icons.dart';
import 'stores_details.dart';
import 'widgets/mainmenuwidgets.dart';
import 'dart:async';
import 'dart:convert';

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final LocalStorage storage = new LocalStorage('Surveyor');
  var storeData;
  var assignStores = [];
  var storeRegistration = [];
  var _assignShop = [];
  var _storeShop = [];
  var count = "0";
  var _status;
  bool showAssignStore = false;
  bool showRegisterStore = false;
  var performType, performTypearray;
  OnlineSerives onlineSerives = new OnlineSerives();
  Geolocator geolocator = Geolocator();

  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(color: CustomIcons.dropDownHeader),
    );
  }

  RoundedRectangleBorder alertButtonShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
      side: BorderSide(color: CustomIcons.appbarColor),
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

  Widget assignStoreWidget(var data) {
    print(">>>" + data.toString());
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Container(
            color: CustomIcons.dropDownHeader,
            child: ListTile(
              title: InkWell(
                onTap: () {
                  setState(() {
                    data["show"] = !data["show"];
                  });
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      data["townshipname"].toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              trailing: Wrap(
                spacing: 12, // space between two icons
                children: <Widget>[
                  // icon-1
                  IconButton(
                    color: Colors.black,
                    icon: data["show"] == true
                        ? Icon(Icons.keyboard_arrow_down)
                        : Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        data["show"] = !data["show"];
                      });
                    },
                  ) // icon-2
                ],
              ),
              onTap: () {
                setState(() {
                  data["show"] = !data["show"];
                });
              },
            ),
          ),
          Container(
              child: data["show"] == true
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            for (var i = 0; i < data["childData"].length; i++)
                              buildAssignItem(
                                  data["childData"][i]["shopname"].toString() +
                                      "( " +
                                      data["childData"][i]["shopnamemm"]
                                          .toString() +
                                      " )",
                                  data["childData"][i]["phoneno"].toString(),
                                  data["childData"][i]["address"].toString(),
                                  data["childData"][i])
                          ],
                        ),
                      ],
                    )
                  : new Container())
        ],
      ),
    );
  }

  BoxDecoration flagDecoration(var check) {
    if (check != "0" && check != "0.0") {
      return BoxDecoration(
        border: Border.all(
          color: CustomIcons.appbarColor,
        ),
        borderRadius: BorderRadius.circular(0.0),
      );
    } else {
      return BoxDecoration();
    }
  }

  Widget storeRegWIdget(var data) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Container(
            color: CustomIcons.dropDownHeader,
            child: ListTile(
              title: InkWell(
                onTap: () {
                  setState(() {
                    data["show"] = !data["show"];
                  });
                },
                child: Text(
                  data["townshipname"],
                  style: TextStyle(color: Colors.black),
                ),
              ),
              onTap: () {
                setState(() {
                  data["show"] = !data["show"];
                });
              },
              trailing: Wrap(
                spacing: 12, // space between two icons
                children: <Widget>[
                  // icon-1
                  IconButton(
                    color: Colors.black,
                    icon: data["show"] == true
                        ? Icon(Icons.keyboard_arrow_down)
                        : Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        data["show"] = !data["show"];
                      });
                    },
                  ) // icon-2
                ],
              ),
            ),
          ),
          Container(
              child: data["show"] == true
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
                                      i < data["childData"].length;
                                      i++)
                                    buildRegisterItem(
                                        data["childData"][i]["name"]
                                                .toString() +
                                            "( " +
                                            data["childData"][i]["mmName"]
                                                .toString() +
                                            " )",
                                        data["childData"][i]["phoneNumber"]
                                            .toString(),
                                        data["childData"][i]["address"]
                                            .toString(),
                                        data["childData"][i])
                                ],
                              ),
                      ],
                    )
                  : new Container())
        ],
      ),
    );
  }

  _showDialog(var data) {
    var shopData = [data];
    var param;
    showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text("Check In"),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.store,
                        color: CustomIcons.iconColor,
                        size: 35,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                            data["shopname"] + "(" + data["shopnamemm"] + ")"),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: RaisedButton(
                            color: Colors.white,
                            shape: alertButtonShape(),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Center(
                              child: Column(
                                children: <Widget>[
//                                        buildStatusText(this.performTypearray)
                                  Text("Cancel")
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: RaisedButton(
                            color: Colors.white,
                            shape: alertButtonShape(),
                            onPressed: () {
                              getGPSstatus().then((status) => {
                                    print("$status"),
                                    if (status == true)
                                      {
                                        param = {
                                          "shopsyskey": shopData[0]
                                              ["shopsyskey"]
                                        },
                                        this
                                            .onlineSerives
                                            .getCategory(param)
                                            .then((value) => {
                                                  print("98->" +
                                                      value.toString()),
                                                  if (value == true)
                                                    {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(),
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              StoresDetailsScreen(
                                                                  shopData,
                                                                  false,
                                                                  "assign",
                                                                  "null"),
                                                        ),
                                                      ),
                                                    }
                                                  else
                                                    {
                                                      hideLoadingDialog,
                                                    },
                                                }),
                                      }
                                    else
                                      {ShowToast("Please open GPS")}
                                  });
                            },
                            child: Center(
                              child: Column(
                                children: <Widget>[
//                                        buildStatusText(this.performTypearray)
                                  Text("Next")
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _showDialog2(var data) {
    var shopData = [data];
    var param;
    showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text("Check In"),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.store,
                        color: CustomIcons.iconColor,
                        size: 35,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                            data["shopname"] + "(" + data["shopnamemm"] + ")"),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: RaisedButton(
                            color: Colors.white,
                            shape: alertButtonShape(),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Center(
                              child: Column(
                                children: <Widget>[
//                                        buildStatusText(this.performTypearray)
                                  Text("Cancel")
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: RaisedButton(
                            color: Colors.white,
                            shape: alertButtonShape(),
                            onPressed: () {
                              getGPSstatus().then((status) => {
                                    print("$status"),
                                    if (status == true)
                                      {
                                        param = {
                                          "shopsyskey": shopData[0]
                                              ["shopsyskey"]
                                        },
                                        this
                                            .onlineSerives
                                            .getCategory(param)
                                            .then((value) => {
                                                  print("98->" +
                                                      value.toString()),
                                                  if (value == true)
                                                    {
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              StoresDetailsScreen(
                                                                  shopData,
                                                                  false,
                                                                  "assign",
                                                                  "null"),
                                                        ),
                                                      ),
                                                    }
                                                  else
                                                    {
                                                      hideLoadingDialog,
                                                    },
                                                }),
                                      }
                                    else
                                      {ShowToast("Please open GPS")}
                                  });
                            },
                            child: Center(
                              child: Column(
                                children: <Widget>[
//                                        buildStatusText(this.performTypearray)
                                  Text("Next")
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildAssignItem(String storeName, String phone, String address, data) {
    var param;
    var shopData = [data];
    print("99-->  ${shopData}");
    return Container(
      color: Colors.grey[200],
      child: Card(
        child: Container(
          decoration: flagDecoration(data["FlagCount"].toString()),
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
//                                        buildStatusText(this.performTypearray)
                                        Text("In Progress")
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
//                                    _showDialog(data);
                                    getGPSstatus().then((status) => {
                                          print("$status"),
                                          if (status == true)
                                            {
                                              param = {
                                                "shopsyskey": shopData[0]
                                                    ["shopsyskey"]
                                              },
                                              this
                                                  .onlineSerives
                                                  .getCategory(param)
                                                  .then((value) => {
                                                        print("98->" +
                                                            value.toString()),
                                                        if (value == true)
                                                          {
                                                            Navigator.of(
                                                                    context)
                                                                .pushReplacement(
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    StoresDetailsScreen(
                                                                        shopData,
                                                                        false,
                                                                        "assign",
                                                                        "null"),
                                                              ),
                                                            ),
                                                          }
                                                        else
                                                          {
                                                            hideLoadingDialog,
                                                          },
                                                      }),
                                            }
                                          else
                                            {ShowToast("Please open GPS")}
                                        });
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
    var params;
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(1),
      child: Card(
        child: Container(
          decoration: flagDecoration(data["FlagCount"].toString()),
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
                                    getGPSstatus().then((status) => {
                                          print("$status"),
                                          if (status == true)
                                            {
                                              params = {
                                                "shopsyskey": data["id"]
                                              },
                                              this
                                                  .onlineSerives
                                                  .getCategory(params)
                                                  .then((value) => {
                                                        if (value == true)
                                                          {
                                                            print("33->" +
                                                                data.toString()),
                                                            Navigator.of(
                                                                    context)
                                                                .pushReplacement(
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    StoresDetailsScreen(
                                                                        [data],
                                                                        false,
                                                                        "register",
                                                                        "null"),
                                                              ),
                                                            ),
                                                          }
                                                        else
                                                          {
                                                            hideLoadingDialog(),
                                                          }
                                                      }),
                                            }
                                          else
                                            {
                                              {ShowToast("Please open GPS")}
                                            }
                                        });
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

  var assignStoreData = [];
  var storeRegisterData = [];
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
    var commonAssign = [];
    var commonAssignwithName = [];
    var commonStorereg = [];
    var commonStoreregwithName = [];
    var paramforTownshipName;
    var assignData = {};
    var storeRegwithHeader = [];
    var assignstorewithHeader = [];
    var _childArray = [];
    loginData = this.storage.getItem("loginData");
    newParam = {"usersyskey": loginData["syskey"].toString()};
    shopParam["spsyskey"] = loginData["syskey"];
    shopParam["teamsyskey"] = loginData["teamSyskey"];
    shopParam["usertype"] = loginData["userType"];
    shopParam["date"] = getTodayDate();
    print("${shopParam}");

    Future.delayed(const Duration(milliseconds: 500), () {
//      setState(() {
      showLoading();
//      });
      this
          .onlineSerives
          .getStores(shopParam)
          .then((result) => {
                if (result == true)
                  {
                    this.onlineSerives.getsvrShoplist(newParam).then((res) => {
                          if (res == true)
                            {
//                      this.storeData = this.storage.getItem("storeData"),
                              this.storeRegistration =
                                  this.storage.getItem("storeReg"),
                              print("${storeRegistration}"),
                              commonStorereg = getCommonshop(
                                  this.storeRegistration, "storeReg"),
                              print("--3-->" + commonStorereg.toString()),
                              for (var qp = 0; qp < commonStorereg.length; qp++)
                                {
                                  paramforTownshipName = {
                                    "id": commonStorereg[qp]["townshipid"],
                                    "code": "",
                                    "description": "",
                                    "parentid": "",
                                    "n2": ""
                                  },
                                  this
                                      .onlineSerives
                                      .getTownship(paramforTownshipName)
                                      .then((returnData) => {
                                            if (returnData["status"] == true)
                                              {
                                                assignData =
                                                    returnData["data"][0],
                                                commonStoreregwithName.add({
                                                  "townshipid":
                                                      assignData["id"],
                                                  "townshipName":
                                                      assignData["description"],
                                                  "show": false,
                                                }),
                                              }
                                          }),
                                },
                              this.assignStores =
                                  this.storage.getItem("storeData"),
                              print("${this.assignStores}"),
                              commonAssign = getCommonshop(
                                  this.assignStores, "assignStore"),
                              print("--4-->" + commonAssign.toString()),
                              for (var qp = 0; qp < commonAssign.length; qp++)
                                {
                                  paramforTownshipName = {
                                    "id": commonAssign[qp]["townshipid"],
                                    "code": "",
                                    "description": "",
                                    "parentid": "",
                                    "n2": ""
                                  },
                                  this
                                      .onlineSerives
                                      .getTownship(paramforTownshipName)
                                      .then((returnData) => {
                                            print("as-->" +
                                                returnData.toString()),
                                            if (returnData["status"] == true)
                                              {
                                                assignData =
                                                    returnData["data"][0],
                                                commonAssignwithName.add({
                                                  "townshipid":
                                                      assignData["id"],
                                                  "townshipName":
                                                      assignData["description"],
                                                  "show": false,
                                                }),
                                              }
                                          }),
                                },
                              setState(() {
                                this.count =
                                    this.assignStores.length.toString();
                              }),
                              Future.delayed(const Duration(seconds: 4), () {
                                print(
                                    "-1->" + commonStoreregwithName.toString());
                                for (var t = 0;
                                    t < commonStoreregwithName.length;
                                    t++) {
                                  _childArray = [];
                                  for (var r = 0;
                                      r < this.storeRegistration.length;
                                      r++) {
                                    if (commonStoreregwithName[t]
                                            ["townshipid"] ==
                                        this.storeRegistration[r]
                                            ["townshipId"]) {
                                      _childArray
                                          .add(this.storeRegistration[r]);
                                    }
                                  }
                                  storeRegwithHeader.add({
                                    "townshipid": commonStoreregwithName[t]
                                        ["townshipid"],
                                    "townshipname": commonStoreregwithName[t]
                                        ["townshipName"],
                                    "show": false,
                                    "childData": _childArray
                                  });
                                }
                                print("02->" + storeRegwithHeader.toString());

                                print("-0->" + commonAssignwithName.toString());
                                for (var t = 0;
                                    t < commonAssignwithName.length;
                                    t++) {
                                  _childArray = [];
                                  for (var r = 0;
                                      r < this.assignStores.length;
                                      r++) {
                                    if (commonAssignwithName[t]["townshipid"] ==
                                        this.assignStores[r]["townshipid"]) {
                                      _childArray.add(this.assignStores[r]);
                                    }
                                  }
                                  assignstorewithHeader.add({
                                    "townshipid": commonAssignwithName[t]
                                        ["townshipid"],
                                    "townshipname": commonAssignwithName[t]
                                        ["townshipName"],
                                    "show": false,
                                    "childData": _childArray
                                  });
                                }
                                print(
                                    "01->" + assignstorewithHeader.toString());
//                                Future.delayed(const Duration(seconds: 5), () {
//
//                                });
                                setState(() {
                                  this.assignStoreData = assignstorewithHeader;
                                  this.storeRegisterData = storeRegwithHeader;
                                  if (this.assignStoreData.length > 0 ||
                                      this.storeRegisterData.length > 0) {
                                    hideLoadingDialog();
                                  }
                                  print("1233113");
                                });
                              }),
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

  List data;

  Future<void> localJsonData() async {
    var jsonText = await rootBundle.loadString("assets/township.json");
    setState(() {
      data = json.decode(jsonText);
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
                    getGPSstatus().then((status) => {
                          print("$status"),
                          if (status == true)
                            {
                              showLoading(),
                              _getLocation().then((value) async {
//                                setState(() {
                                if (value == null) {
                                  print(value);
                                } else {
//                                    _getAddress(value).then((val) async {
                                  if (value.latitude != null &&
                                      value.longitude != null) {
                                    localJsonData().then((val) {
                                      print(value);
                                      hideLoadingDialog();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => GmapS(
                                            lati: value.latitude,
                                            long: value.longitude,
                                            regass: 'Map',
                                            passLength: null,
                                            updateStatus: false,
                                            data: data,
                                            shopkey: value,
                                          ),
                                        ),
                                      );
                                    });
                                  } else {
                                    print(value);
                                  }
//                                    }).catchError((error) {
//                                      print(error);
//                                    });
                                }
//                                });
                              }).catchError((error) {
                                print(error);
                              }),
                            }
                          else
                            {ShowToast("Please open GPS")}
                        });
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
                                    "0/" + this.count,
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
                            color: Colors.grey[300],
                            child: showAssignStore == true
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      this.assignStoreData.length == 0
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
                                                            .assignStoreData
                                                            .length;
                                                    i++)
                                                  assignStoreWidget(
                                                      assignStoreData[i]),
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
                            color: Colors.grey[300],
                            child: showRegisterStore == true
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                            .storeRegisterData
                                                            .length;
                                                    i++)
                                                  storeRegWIdget(
                                                      storeRegisterData[i])
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
                                                StoresDetailsScreen([], false,
                                                    "newStore", "null"),
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

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Future<String> _getAddress(Position pos) async {
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      return pos.thoroughfare + ', ' + pos.locality;
    }
    return "";
  }
}
