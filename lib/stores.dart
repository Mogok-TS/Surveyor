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
import 'package:intl/intl.dart';
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

  List<String> _chooseList = ["CHECKIN", "STORECLOSED"];
  var _checkInType;

  var rating = "";
  TextEditingController reason = new TextEditingController();
  var _reasonText;
  List<String> _storeClosed = ["PERMANENT_CLOSE", "TEMPORARY_CLOSE"];
  var _selectType;
  var _checkClosed;

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('dd/MM/yyyy-h:m a');
  final String formatted = formatter.format(now);

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
    return Container(
      // margin: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 5, bottom: 10, left: 5, right: 5),
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
                      data["regionName"].toString(),
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
                  ? Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.grey[300],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            color: CustomIcons.dropDownHeader,
                            child: ListTile(
                              title: InkWell(
                                onTap: () {
                                  setState(() {
                                    data["existItem"] = !data["existItem"];
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Existing Store",
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
                                    icon: data["existItem"] == true
                                        ? Icon(Icons.keyboard_arrow_down)
                                        : Icon(Icons.chevron_right),
                                    onPressed: () {
                                      setState(() {
                                        // data["show"] = !data["show"];
                                        data["existItem"] = !data["existItem"];
                                      });
                                    },
                                  ) // icon-2
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  data["existItem"] = !data["existItem"];
                                });
                              },
                            ),
                          ),
                          if (data["existItem"] == true)
                            if (data["existingStore"].length == 0 &&
                                data["existItem"] == true)
                              Row(
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
                              ),
                          if (data["existingStore"].length > 0 &&
                              data["existItem"] == true)
                            for (var ii = 0;
                                ii < data["existingStore"].length;
                                ii++)
                              buildAssignItem(data["existingStore"][ii]),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: CustomIcons.dropDownHeader,
                            child: ListTile(
                              title: InkWell(
                                onTap: () {
                                  setState(() {
                                    data["flagItem"] = !data["flagItem"];
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "Flag Store",
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
                                    icon: data["flagItem"] == true
                                        ? Icon(Icons.keyboard_arrow_down)
                                        : Icon(Icons.chevron_right),
                                    onPressed: () {
                                      setState(() {
                                        // data["show"] = !data["show"];
                                        data["flagItem"] = !data["flagItem"];
                                      });
                                    },
                                  ) // icon-2
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  data["flagItem"] = !data["flagItem"];
                                });
                              },
                            ),
                          ),
                          if (data["flagItem"] == true)
                            if (data["flagStore"].length == 0 &&
                                data["flagItem"] == true)
                              Row(
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
                              ),
                          if (data["flagStore"].length > 0 &&
                              data["flagItem"] == true)
                            for (var ii = 0;
                                ii < data["flagStore"].length;
                                ii++)
                              buildAssignItem(data["flagStore"][ii]),
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
                                            if (status == true)
                                              {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        StoresDetailsScreen([],
                                                            false,
                                                            "newStore",
                                                            "null"),
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
                        ],
                      ),
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

  _showDialog(var data, var curPlace) {
    var shopData = [data];
    var param;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
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
                            size: 27,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              data["shopname"] + "(" + data["shopnamemm"] + ")",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black54),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.timelapse,
                            color: CustomIcons.iconColor,
                            size: 27,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "${this.formatted}",
                              style: TextStyle(fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: CustomIcons.iconColor,
                            size: 27,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "${curPlace.latitude}" +
                                  " " +
                                  "/" +
                                  " " +
                                  "${curPlace.longitude}",
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.select_all,
                            color: CustomIcons.iconColor,
                            size: 27,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Container(
                              width: 250,
                              child: DropdownButtonFormField<String>(
                                value: _checkInType,
                                items: _chooseList
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration:
                                    InputDecoration.collapsed(hintText: ''),
                                hint: Row(
                                  children: <Widget>[
                                    Text('Select Type'),
                                  ],
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _checkInType = value;
                                    if (_checkInType == "STORECLOSED")
                                      _checkClosed = "1";
                                    else
                                      _checkClosed = "2";
                                    _selectType = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (this._checkClosed == "1")
                      SizedBox(
                        height: 10,
                      ),
                    if (this._checkClosed == "1")
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.nfc,
                              color: CustomIcons.iconColor,
                              size: 27,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 250,
                              child: Container(
                                child: DropdownButtonFormField<String>(
                                  value: _selectType,
                                  items: _storeClosed
                                      .map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  decoration:
                                      InputDecoration.collapsed(hintText: ''),
                                  hint: Row(
                                    children: <Widget>[
                                      Text('Select Type'),
                                    ],
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectType = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (this._checkClosed == "1")
                      SizedBox(
                        height: 10,
                      ),
                    if (this._checkClosed == "1")
                      Container(
                        height: 10 * 20.0,
                        child: TextField(
                          controller: reason,
                          maxLines: 10,
                          onChanged: (value) {
                            this._reasonText = value.toString();
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: "Reason",
                            fillColor: Colors.grey[50],
                            filled: true,
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.map,
                            color: CustomIcons.iconColor,
                            size: 27,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              data["address"],
                              style: TextStyle(fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
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
                                  var loginUser =
                                      this.storage.getItem("loginData");
                                  var params = {
                                    "lat": "${curPlace.latitude}",
                                    "lon": "${curPlace.longitude}",
                                    "address": data["address"],
                                    "shopsyskey": data["shopsyskey"],
                                    "usersyskey": loginUser['syskey'],
                                    if (_checkInType == "CHECKIN")
                                      "checkInType": _checkInType
                                    else
                                      "checkInType": _selectType,
                                    "register": true,
                                    "reason": this._reasonText.toString(),
                                    "task": "INCOMPLETE"
                                  };
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
                                            this
                                                .onlineSerives
                                                .getSurveyor(params)
                                                .then(
                                                  (value) => {},
                                                ),
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
            );
          },
        );
      },
    );
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

  Widget buildAssignItem(data) {
    var shopData = [data];
    // print("99-->  ${shopData}");
    return Container(
      color: Colors.grey[200],
      child: Card(
        child: Container(
          decoration: flagDecoration(data["FlagCount"].toString()),
          child: Column(
            children: <Widget>[
              ListTile(
                  title: Text(
                    data["shopname"] + " ( " + data["shopnamemm"] + " )",
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
                        data["phoneno"],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      ),
                      Text(
                        data["address"],
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
                                    _getLocation().then(
                                      (value) => {
                                        _showDialog(
                                          data,
                                          value,
                                        ),
                                      },
                                    );
                                    _checkInType = null;
                                    _checkClosed = "2";
                                    _selectType = null;
                                    reason = null;
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

  var datalist = [
    {
      "id": "2009050541542600002",
      "recordStatus": 1,
      "saveStatus": 1,
      "toDate": "20200905",
      "fromDate": "20200901",
      "regionId": "2004241203562700068",
      "userDetail": [
        {
          "id": "2009050541565500007",
          "recordStatus": 1,
          "saveStatus": 1,
          "date": "20200905",
          "parentId": "2009050541542600002",
          "userId": "2007300654381400029"
        }
      ],
      "surDetail": [
        {
          "id": "2009050541565600008",
          "recordStatus": 1,
          "saveStatus": 1,
          "parentId": "2009050541542600002",
          "surveyId": "2009050522567300002",
          "flagStore": false,
          "existingStore": false,
          "newStore": false
        },
        {
          "id": "2009050541577500009",
          "recordStatus": 1,
          "saveStatus": 1,
          "parentId": "2009050541542600002",
          "surveyId": "2007300654381400027",
          "flagStore": false,
          "existingStore": false,
          "newStore": false
        }
      ],
      "existingStore": [
        {
          "tranid": "2008251409061800002",
          "address":
              "သရက်တောလမ်း,Tha Yet Taw (South) Ward,Kyeemyindaing,Kyeemyindaing,Yangon (West),ရန်ကုန်တိုင်းဒေသကြီး",
          "isFlagStore": 0,
          "regionsyskey": "2009050541542600002",
          "shopnamemm": "ပလက်စ်ကုတ်တက်စ်",
          "personph": "+959123456789",
          "stateid": "2",
          "pluscode": "7M8RQ4PH+58",
          "shopsyskey": "2008251409062300003",
          "townid": "2004241237194900113",
          "wardid": "2004241650513600233",
          "long": "96.12832",
          "phoneno": "+959987654321",
          "shopcode": "457288354484",
          "districtid": "8",
          "street": "သရက်တောလမ်း",
          "shopname": "Plus Code Test",
          "mimu": "",
          "FlagCount": 0,
          "townshipid": "2004241203562700068",
          "lat": "16.785425",
          "email": "",
          "personname": "ပလက်စ်ကုတ်"
        }
      ],
      "flagStore": [
        {
          "tranid": "2009030423162000180",
          "address":
              "12 test,Ma Gyi Tan (North/East) Ward,Kyeemyindaing,Kyeemyindaing,Yangon (West),ရန်ကုန်တိုင်းဒေသကြီး",
          "isFlagStore": 1,
          "regionsyskey": "2009050541542600002",
          "shopnamemm": "Test",
          "personph": "",
          "stateid": "2",
          "pluscode": "7M8RR4FG+VR",
          "shopsyskey": "2009030423165600181",
          "townid": "2004241237194900113",
          "wardid": "2004241648288400224",
          "long": "96.12708",
          "phoneno": "+95966666666",
          "shopcode": "899914631872",
          "districtid": "8",
          "street": "12 test",
          "shopname": "Test",
          "mimu": "",
          "FlagCount": 0,
          "townshipid": "2004241203562700068",
          "lat": "16.824665",
          "email": "",
          "personname": "QC"
        },
        {
          "tranid": "2009030423162000180",
          "address":
              "12 test,Ma Gyi Tan (North/East) Ward,Kyeemyindaing,Kyeemyindaing,Yangon (West),ရန်ကုန်တိုင်းဒေသကြီး",
          "isFlagStore": 1,
          "regionsyskey": "2009050541542600002",
          "shopnamemm": "Test",
          "personph": "",
          "stateid": "2",
          "pluscode": "7M8RR4FG+VR",
          "shopsyskey": "2009030423165600181",
          "townid": "2004241237194900113",
          "wardid": "2004241648288400224",
          "long": "96.12708",
          "phoneno": "+95966666666",
          "shopcode": "899914631872",
          "districtid": "8",
          "street": "12 test",
          "shopname": "Test",
          "mimu": "",
          "FlagCount": 0,
          "townshipid": "2004241203562700068",
          "lat": "16.824665",
          "email": "",
          "personname": "QC"
        },
        {
          "tranid": "2009030423162000180",
          "address":
              "12 test,Ma Gyi Tan (North/East) Ward,Kyeemyindaing,Kyeemyindaing,Yangon (West),ရန်ကုန်တိုင်းဒေသကြီး",
          "isFlagStore": 1,
          "regionsyskey": "2009050541542600002",
          "shopnamemm": "Test",
          "personph": "",
          "stateid": "2",
          "pluscode": "7M8RR4FG+VR",
          "shopsyskey": "2009030423165600181",
          "townid": "2004241237194900113",
          "wardid": "2004241648288400224",
          "long": "96.12708",
          "phoneno": "+95966666666",
          "shopcode": "899914631872",
          "districtid": "8",
          "street": "12 test",
          "shopname": "Test",
          "mimu": "",
          "FlagCount": 0,
          "townshipid": "2004241203562700068",
          "lat": "16.824665",
          "email": "",
          "personname": "QC"
        },
        {
          "tranid": "2009030423162000180",
          "address":
              "12 test,Ma Gyi Tan (North/East) Ward,Kyeemyindaing,Kyeemyindaing,Yangon (West),ရန်ကုန်တိုင်းဒေသကြီး",
          "isFlagStore": 1,
          "regionsyskey": "2009050541542600002",
          "shopnamemm": "Test",
          "personph": "",
          "stateid": "2",
          "pluscode": "7M8RR4FG+VR",
          "shopsyskey": "2009030423165600181",
          "townid": "2004241237194900113",
          "wardid": "2004241648288400224",
          "long": "96.12708",
          "phoneno": "+95966666666",
          "shopcode": "899914631872",
          "districtid": "8",
          "street": "12 test",
          "shopname": "Test",
          "mimu": "",
          "FlagCount": 0,
          "townshipid": "2004241203562700068",
          "lat": "16.824665",
          "email": "",
          "personname": "QC"
        },
        {
          "tranid": "2009030423162000180",
          "address":
              "12 test,Ma Gyi Tan (North/East) Ward,Kyeemyindaing,Kyeemyindaing,Yangon (West),ရန်ကုန်တိုင်းဒေသကြီး",
          "isFlagStore": 1,
          "regionsyskey": "2009050541542600002",
          "shopnamemm": "Test",
          "personph": "",
          "stateid": "2",
          "pluscode": "7M8RR4FG+VR",
          "shopsyskey": "2009030423165600181",
          "townid": "2004241237194900113",
          "wardid": "2004241648288400224",
          "long": "96.12708",
          "phoneno": "+95966666666",
          "shopcode": "899914631872",
          "districtid": "8",
          "street": "12 test",
          "shopname": "Test",
          "mimu": "",
          "FlagCount": 0,
          "townshipid": "2004241203562700068",
          "lat": "16.824665",
          "email": "",
          "personname": "QC"
        }
      ],
      "newStore": false
    }
  ];
  var allData = [];
  allDataFunction() {
    allData = [];
    var storeDatas = this.storage.getItem("storeData");
    print(".." + storeDatas.toString());
    for (var i = 0; i < storeDatas.length; i++) {
      var objData = {};
      var townShipData = {};
      objData["show"] = false;
      objData["regionId"] = storeDatas[i]["regionId"].toString();
      objData["regionName"] = storeDatas[i]["regionId"].toString();
      objData["existingStore"] = storeDatas[i]["existingStore"];
      objData["existItem"] = false;
      objData["flagStore"] = storeDatas[i]["flagStore"];
      objData["flagItem"] = false;
      var paramforTownshipName = {
        "id": storeDatas[i]["regionId"].toString(),
        "code": "",
        "description": "",
        "parentid": "",
        "n2": ""
      };

      this.onlineSerives.getTownship(paramforTownshipName).then((value) => {
            townShipData = value["data"][0],
            objData["regionName"] = value["data"][0]["description"],
            setState(() {
              allData.add(objData);
            }),
          });
    }
    print("after>>" + allData.toString());
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
                              print("hello data"),
                              this.assignStores =
                                  this.storage.getItem("storeData"),
                              setState(() {
                                this.count =
                                    this.assignStores.length.toString();
                              }),
                              allDataFunction(),
                              setState(() {
                                hideLoadingDialog();
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
                          if (status == true)
                            {
                              showLoading(),
                              _getLocation().then((value) async {
//                                setState(() {
                                if (value == null) {
                                } else {
//                                    _getAddress(value).then((val) async {
                                  if (value.latitude != null &&
                                      value.longitude != null) {
                                    localJsonData().then((val) {
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
                                  } else {}
//                                    }).catchError((error) {
//                                      print(error);
//                                    });
                                }
//                                });
                              }).catchError((error) {}),
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
                padding: EdgeInsets.all(5),
                child: Column(children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          // color: CustomIcons.iconColor,
                          child: Column(
                            children: <Widget>[
                              if (allData.length > 0)
                                for (var i = 0; i < allData.length; i++)
                                  assignStoreWidget(allData[i]),
                              // RaisedButton(
                              //   onPressed: () {
                              //     allDataFunction();
                              //   },
                              //   child: Text("text data"),
                              // )
                            ],
                          ),
                        ),
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
                          color: Colors.grey[300],
                        )
                      ],
                    ),
                  ),
                  // Container(
                  //   child: Row(
                  //     children: <Widget>[
                  //       Expanded(
                  //         child: Container(),
                  //       ),
                  //       Expanded(
                  //         child: RaisedButton(
                  //           color: Colors.white,
                  //           shape: buttonShape(),
                  //           onPressed: () {
                  //             getGPSstatus().then((status) => {
                  //                   if (status == true)
                  //                     {
                  //                       Navigator.of(context).pushReplacement(
                  //                         MaterialPageRoute(
                  //                           builder: (context) =>
                  //                               StoresDetailsScreen([], false,
                  //                                   "newStore", "null"),
                  //                         ),
                  //                       ),
                  //                     }
                  //                   else
                  //                     {ShowToast("Please open GPS")}
                  //                 });
                  //           },
                  //           child: Row(
                  //             children: <Widget>[
                  //               Icon(
                  //                 Icons.add_box,
                  //                 color: Colors.black,
                  //               ),
                  //               Text(" Add New Store",
                  //                   style: TextStyle(
                  //                     color: Colors.black,
                  //                   ))
                  //             ],
                  //           ),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // )
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
