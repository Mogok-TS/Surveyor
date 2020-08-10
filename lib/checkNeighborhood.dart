import 'package:Surveyor/Services/Loading/LoadingServices.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';
import 'package:Surveyor/outsideInsideNeighborhood.dart';
import 'package:Surveyor/stores.dart';
import 'package:Surveyor/stores_details.dart';
import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';

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

//  var headerList = [
//    {
//      "fromDate": "20200101",
//      "toDate": "20201231",
//      "headerSyskey": "1",
//      "headerCode": "",
//      "headerDescription": "Surveyor Header Test Data 1",
//      "sections": [
//        {
//          "questions": [
//            {
//              "questionDescription": "Neighborhood Type",
//              "questionSyskey": "2007261736169400018"
//            },
//            {
//              "questionDescription": "Store Type",
//              "questionSyskey": "2007261737373700022"
//            },
//            {
//              "questionDescription": "Road Access Type",
//              "questionSyskey": "2007261738472600026"
//            },
//            {
//              "questionDescription": "Building Material Type",
//              "questionSyskey": "2007261740291000030"
//            },
//            {
//              "questionDescription": "Building Type",
//              "questionSyskey": "2007271813568900006"
//            },
//            {
//              "questionDescription": "Building Size",
//              "questionSyskey": "2007271814326800007"
//            },
//            {
//              "questionDescription": "Store outlet of occupation(s) of patrons",
//              "questionSyskey": "2007271827442300008"
//            },
//            {
//              "questionDescription": "Store outlet of average income of patrons",
//              "questionSyskey": "2007271829526300009"
//            },
//            {
//              "questionDescription": "Store outlet of frequency of passerbys",
//              "questionSyskey": "2007271830243000010"
//            }
//          ],
//          "sectionSyskey": "1",
//          "sectionDescription": "Neighborhood Survey"
//        },
//        {
//          "questions": [
//            {
//              "questionDescription": "Operation date and time",
//              "questionSyskey": "2007270617116200035"
//            },
//            {
//              "questionDescription": "NRC number",
//              "questionSyskey": "2007270623216600040"
//            },
//            {
//              "questionDescription": "Date of Birth",
//              "questionSyskey": "2007270624116400041"
//            },
//            {
//              "questionDescription": "Number of workers",
//              "questionSyskey": "2007270654306100042"
//            }
//          ],
//          "sectionSyskey": "4",
//          "sectionDescription": "Store Operator Information"
//        },
//        {
//          "questions": [
//            {
//              "questionDescription": "Take a photo store sign board",
//              "questionSyskey": "2007271803224200002"
//            },
//            {
//              "questionDescription": "Take a photo the whole of store",
//              "questionSyskey": "2007271809254900004"
//            }
//          ],
//          "sectionSyskey": "2",
//          "sectionDescription": "Outside of Store"
//        },
//        {
//          "questions": [
//            {
//              "questionDescription": "Store Type(On premise/Off premise)",
//              "questionSyskey": "2007270536087300029"
//            },
//            {
//              "questionDescription": "Store Type(Modern trade /Traditional trade)",
//              "questionSyskey": "2007270537288800031"
//            },
//            {
//              "questionDescription": "Display material type",
//              "questionSyskey": "2007270538561800033"
//            }
//          ],
//          "sectionSyskey": "3",
//          "sectionDescription": "Inside of Store"
//        }
//      ],
//      "status": "1"
//    },
//    {
//      "fromDate": "20200101",
//      "toDate": "20201231",
//      "headerSyskey": "2",
//      "headerCode": "",
//      "headerDescription": "Surveyor Header Test Data 2",
//      "sections": [
//        {
//          "questions": [],
//          "sectionSyskey": "2",
//          "sectionDescription": "Outside of Store"
//        },
//        {
//          "questions": [],
//          "sectionSyskey": "3",
//          "sectionDescription": "Inside of Store"
//        }
//      ],
//      "status": "1"
//    }
//  ];
  var headerList = [];

  Widget _listTileWidget(var passData) {
//    print("${passData}");
    var isNeighborhood;
    var isOutside;
    var isInside;
    var isStoreOperater;
    var secitons = passData["sections"];
    var section;
    for (var i = 0; i < secitons.length; i++) {
      section = secitons[i];
      if (secitons[i]["sectionDescription"] == "Neighborhood Survey") {
        isNeighborhood = true;
      }
      if (secitons[i]["sectionDescription"] == "Store Operator Information") {
        isStoreOperater = true;
      }
      if (secitons[i]["sectionDescription"] == "Outside of Store") {
        isOutside = true;
      }
      if (secitons[i]["sectionDescription"] == "Inside of Store") {
        isInside = true;
      }
    }
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Card(
        child: ListTile(
          onTap: () {
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
    Future.delayed(const Duration(milliseconds: 500), () {
      showLoading();
      _getData();
    });
  }

  _getData() {
    var params = {
      "svrHdrSK": ["2", "1", "3"],
      "CategorySK": []
    };
    this
        .onlineSerives
        .getHeaderList(params)
        .then((result) => {
//              print(">>>>" + result.toString()),
              if (result["status"] == true)
                {
                  setState(() => {
                        this.headerList = result["data"],
                        print("${this.headerList.length}"),
                        hideLoadingDialog(),
                      }),
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
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                // for (var i = 0; i < headerList.length; i++)
                if (headerList.length > 0)
                  for (var i = 0; i < headerList.length; i++)
                    _listTileWidget(headerList[i]),
              ],
            ),
          ),
          bottomNavigationBar: new BottomNavigationBar(
            backgroundColor: CustomIcons.appbarColor,
            items: [
              new BottomNavigationBarItem(
                icon: new Container(),
                title: new Container(),
              ),
              new BottomNavigationBarItem(
                icon: new Container(),
                title: InkWell(
                  onTap: () {
                    getGPSstatus().then((status) => {
                          print("$status"),
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
              new BottomNavigationBarItem(
                icon: new Container(),
                title: new Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
