import 'package:Surveyor/Services/Loading/LoadingServices.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';
import 'package:Surveyor/outsideInsideNeighborhood.dart';
import 'package:Surveyor/stores.dart';
import 'package:Surveyor/stores_details.dart';
import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:localstorage/localstorage.dart';

import 'Services/GeneralUse/Geolocation.dart';
import 'Services/Messages/Messages.dart';
import 'assets/custom_icons_icons.dart';

class CheckNeighborhoodScreen extends StatefulWidget {
  final String shopName;
  final String shopPhone;
  final String address;
  final String regOrAss;
  var passData;

  CheckNeighborhoodScreen(
    this.shopName,
    this.shopPhone,
    this.address,
    this.regOrAss,
    this.passData,
  );

  @override
  _CheckNeighborhoodScreenState createState() =>
      _CheckNeighborhoodScreenState();
}

class _CheckNeighborhoodScreenState extends State<CheckNeighborhoodScreen> {
  OnlineSerives onlineSerives = new OnlineSerives();
  LocalStorage storage = new LocalStorage('Surveyor');
  var headerList = [];
  var completeStatus;

  Widget _listTileWidget(passData) {
    var isNeighborhood;
    var isOutside;
    var isInside;
    var isStoreOperater;
    print("data-->" + passData.toString());
    var header = passData;

    var secitons = passData["sections"];

    var section = [];
    print("1-->" + "$secitons");
    for (var i = 0; i < secitons.length; i++) {
      if (secitons[i]["sectionDescription"] == "Neighborhood Survey") {
        isNeighborhood = true;
        section = header["sections"];
      }
      if (secitons[i]["sectionDescription"] == "Store Operator Information") {
        isStoreOperater = true;
        section = header["sections"];
      }
      if (secitons[i]["sectionDescription"] == "Outside of Store") {
        isOutside = true;
        section = header["sections"];
      }
      if (secitons[i]["sectionDescription"] == "Inside of Store") {
        isInside = true;
        section = header["sections"];
      }
    }
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Card(
        child: ListTile(
          onTap: () {
            print("aa-->" + section.toString());

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => OutsideInsideNeighborhood(
                        isNeighborhood,
                        isOutside,
                        isInside,
                        isStoreOperater,
                        this.widget.shopName,
                        this.widget.shopPhone,
                        this.widget.address,
                        this.widget.regOrAss,
                        this.widget.passData,
                        section,
                        header,
                      )),
            );
          },
          title: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(passData["headerDescription"]),
              SizedBox(
                width: 5,
              ),
//              Text("(" + passData["headerSyskey"] + ")")
            ],
          )),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }

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

  @override
  void initState() {
    super.initState();
    completeStatus = this.storage.getItem("completeStatus");
    print("aa-->" + completeStatus.toString());
    Future.delayed(const Duration(milliseconds: 500), () {
      showLoading();
      _getData();
    });
  }

  bool complete = false;
  _getData() {
    var routeData = this.storage.getItem("Routebyuser");
    List category = this.storage.getItem("Category");
    print("answer-->" + category.toString() + " ___ " + routeData.toString());
    if (category == null) {
      category = [];
    }
    var answer;
    if (category.length > 0) {
      answer = category[0]["answer"];
    } else {
      answer = [];
    }

    var categories = [];
    var passData;
    var svrHdrSk = [];
    var surDetail = [];
    if (answer.length > 0) {
      final compileArray = answer.map((e) => e["category"]).toSet().toList();
      print("Set-->" +
          compileArray.toString() +
          "______" +
          compileArray.length.toString());
      if (compileArray.length <= 1 && compileArray[0].toString() == "0") {
        categories = [];
      } else {
        for (var q = 0; q < compileArray.length; q++) {
          categories.add(compileArray[q]);
        }
      }
    }
    print("aa1-->" +
        this.widget.regOrAss.toString() +
        " __ " +
        this.widget.passData.toString());
    // if (this.widget.regOrAss == "assign") {
    //   passData = this.widget.passData;
    //   // for (var i = 0; i < routeData.length; i++) {
    //   //   if (routeData[i]["regionId"].toString() ==
    //   //       passData[0]["regionsyskey"].toString()) {
    //   //     surDetail = routeData[i]["surDetail"];
    //   //   }
    //   // }
    //
    //   print(
    //       "30-->" + surDetail.toString() + "___" + passData[0]["regionsyskey"]);
    //
    //   if (surDetail.length == 0) {
    //   } else {
    //     for (var ss = 0; ss < surDetail.length; ss++) {
    //       svrHdrSk.add(surDetail[ss]["surveyId"]);
    //     }
    //   }
    // } else {}
    surDetail = this.storage.getItem("surDetail");
    print("aa3-->" + surDetail.toString());
    if (surDetail.length == 0) {
    } else {
      for (var ss = 0; ss < surDetail.length; ss++) {
        svrHdrSk.add(surDetail[ss]["surveyId"]);
      }
    }
    var shopSyskey = "";
    if (this.widget.regOrAss == "newStore" ||
        this.widget.regOrAss == "register") {
      shopSyskey = this.widget.passData[0]["id"].toString();
    } else {
      shopSyskey = this.widget.passData[0]["shopsyskey"].toString();
    }
    var params = {
      "shopSyskey": shopSyskey,
      "svrHdrSK": svrHdrSk,
      "CategorySK": categories
    };
    print("param1 -->" + params.toString());
    this
        .onlineSerives
        .getHeaderList(params)
        .then((result) => {
              if (result["status"] == true)
                {
                  setState(() => {
                        this.headerList = result["data"],
                        // for(var a = 0; a < 11; a++){
                        //   this.headerList.add(result["data"][0]),
                        // },
                        hideLoadingDialog(),
                      }),
                  for (var i = 0; i < headerList.length; i++)
                    {
                      if (headerList[i]["status"].toString() == "1.0")
                        {
                          setState(() => {
                                this.complete = true,
                              }),
                        }
                    },
                  print("res -->" + this.headerList.toString()),
                }
              else
                {
                  hideLoadingDialog(),
                }
            })
        .catchError((err) => hideLoadingDialog());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: LoadingProvider(
        child: Scaffold(
          backgroundColor: Color(0xFFF8F8FF),
          drawer: MainMenuWidget(),
          appBar: AppBar(
            backgroundColor: CustomIcons.appbarColor,
            title: Text("Surveyor Headers"),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 700,
                    color: Colors.grey[200],
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
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
                  // for (var i = 0; i < headerList.length; i++)
                  if (headerList.length > 0)
                    for (var i = 0; i < headerList.length; i++)
                      if (headerList[i] != null) _listTileWidget(headerList[i]),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: CustomIcons.appbarColor,
            height: 50.0,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      getGPSstatus().then((status) => {
                            if (status == true)
                              {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => StoreScreen(),
                                  ),
//                                  builder: (context) => StoresDetailsScreen(
//                                      this.widget.passData, false, "assign"),
//                                ),
                                ),
                              }
                            else
                              {ShowToast("Please open GPS")}
                          });
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
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (completeStatus != "Complete") {
                        if (complete != true) {
                          var passValue = this.widget.passData[0];
                          print("passVal-->" +
                              passValue.toString() +
                              "___" +
                              this.widget.regOrAss.toString());
                          var loginUser = this.storage.getItem("loginData");
                          var param;
                          if (this.widget.regOrAss == "newStore" ||
                              this.widget.regOrAss == "register") {
                            param = {
                              "lat": passValue["locationData"]["latitude"]
                                  .toString(),
                              "lon": passValue["locationData"]["longitude"]
                                  .toString(),
                              "address": passValue["address"].toString(),
                              "shopsyskey": passValue["id"].toString(),
                              "usersyskey": loginUser["syskey"],
                              "checkInType": "TEMPCHECKOUT",
                              "register": true,
                              "reason": "",
                              "task": "INCOMPLETE",
                            };
                          } else {
                            param = {
                              "lat": passValue["lat"].toString(),
                              "lon": passValue["long"].toString(),
                              "address": passValue["address"].toString(),
                              "shopsyskey": passValue["shopsyskey"].toString(),
                              "usersyskey": loginUser['syskey'],
                              "checkInType": "TEMPCHECKOUT",
                              "register": true,
                              "reason": "",
                              "task": "INCOMPLETE",
                            };
                          }
                          print("params-->" + param.toString());
                          this
                              .onlineSerives
                              .getSurveyor(param)
                              .then((value) => {
                                    if (value["status"] == true)
                                      {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StoreScreen()),
                                        ),
                                      }
                                  });
                        }
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 300,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Center(
                        child: completeStatus == "Complete" || complete
                            ? Text(
                                "Check Out",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white54,
                                ),
                              )
                            : Text(
                                "Check Out",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (completeStatus != "Complete") {
                        if (this.complete == true) {
                          var passValue = this.widget.passData[0];
                          print("passValue->" + passValue.toString());
                          var loginUser = this.storage.getItem("loginData");
                          var lat, lon, shopSyskey;
                          if (passValue["lat"] == null) {
                            lat = passValue["locationData"]["latitude"]
                                .toString();
                            lon = passValue["locationData"]["longitude"]
                                .toString();
                            shopSyskey = passValue["id"].toString();
                          } else {
                            lat = passValue["lat"].toString();
                            lon = passValue["long"].toString();
                            shopSyskey = passValue["shopsyskey"].toString();
                          }
                          var param;
                          param = {
                            "lat": lat,
                            "lon": lon,
                            "address": passValue["address"].toString(),
                            "shopsyskey": shopSyskey,
                            "usersyskey": loginUser['syskey'],
                            "checkInType": "CHECKOUT",
                            "register": true,
                            "reason": "",
                            "task": "INCOMPLETE",
                          };
                          print("params->" + param.toString());
                          this
                              .onlineSerives
                              .getSurveyor(param)
                              .then((value) => {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => StoreScreen()),
                                    ),
                                  });
                        }
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 300,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Center(
                        child: completeStatus == "Complete" || complete != true
                            ? Text(
                                "Complete",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54,
                                    fontSize: 15),
                              )
                            : Text(
                                "Complete",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
