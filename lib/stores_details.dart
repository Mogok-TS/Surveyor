import 'dart:io' as io;
import 'package:Surveyor/assets/circle_icons.dart';
import 'package:Surveyor/assets/location_icons.dart';
import 'package:Surveyor/stores.dart';
import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';
import 'package:Surveyor/Services/GeneralUse/Geolocation.dart';
import 'package:Surveyor/Services/Messages/Messages.dart';
import 'package:Surveyor/Services/Loading/LoadingServices.dart';
import 'package:image_picker/image_picker.dart';
import 'package:load/load.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'Services/GeneralUse/PhoneNumber.dart';
import 'assets/custom_icons_icons.dart';
import 'checkNeighborhood.dart';

class StoresDetailsScreen extends StatefulWidget {
  final String regOrAss;
  var passData, updateStatuspass;

  StoresDetailsScreen(this.passData, this.updateStatuspass, this.regOrAss);

  @override
  _StoresDetailsScreenState createState() => _StoresDetailsScreenState();
}

class _StoresDetailsScreenState extends State<StoresDetailsScreen> {
  io.File _image;
  var updateStatus;
  var shopSyskey;
  OnlineSerives onlineSerives = new OnlineSerives();

//  TextEditingController shopCode = new TextEditingController();
  TextEditingController shopName = new TextEditingController();
  TextEditingController shopNamemm = new TextEditingController();
  TextEditingController shopPhoneNo = new TextEditingController();
  TextEditingController ownerName = new TextEditingController();
  TextEditingController ownerPhoneNo = new TextEditingController();
  TextEditingController state = new TextEditingController();
  TextEditingController district = new TextEditingController();
  TextEditingController townShip = new TextEditingController();
  TextEditingController townorVillagetract = new TextEditingController();
  TextEditingController town = new TextEditingController();
  TextEditingController villageorWard = new TextEditingController();
  TextEditingController ward = new TextEditingController();
  TextEditingController street = new TextEditingController();

  var geolocator = Geolocator();
  Future<bool> gpsCheck;
  var googlePlusparam;
  var updateDataarray = [];

  var plusCode, storeRegistration;
  double longitude = 0;
  double latitude = 0;
  var createRegistration;
  @override
  void initState() {
    super.initState();

    setState(() {
      print("??>> ${this.widget.passData}");
      this.storeRegistration = this.widget.passData;
      if (this.storeRegistration.length == 0) {
        this.updateStatus = this.widget.updateStatuspass;
        if (this.updateStatus == true) {
          this.updateDataarray = this.createRegistration;
        }
      } else {
        this.updateDataarray = this.storeRegistration;
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        showLoading();
      });
      getCurrentLocation().then((k) {
        print({"$k"});
        latitude = k.latitude;
        longitude = k.longitude;
        googlePlusparam = {"lat": latitude, "lng": longitude};
        this.onlineSerives.getGooglePlusCode(googlePlusparam).then(
              (value1) => {
                setState(() {
                  this.plusCode = "${value1["data"]["plusCode"]}";
                  hideLoadingDialog();
                }),
              },
            );
      });
      if (this.updateDataarray.length == 0) {
        this.updateStatus = false;
      } else {
        this.updateStatus = true;
        if (this.widget.regOrAss == "assign") {
          this.shopSyskey =
              this.updateDataarray[0]["2006260508497800827"].toString();
          this.shopName.text = this.updateDataarray[0]["shopname"].toString();
          this.shopNamemm.text =
              this.updateDataarray[0]["shopnamemm"].toString();
          this.shopPhoneNo.text = this.updateDataarray[0]["phoneno"].toString();
          this.ownerName.text =
              this.updateDataarray[0]["personname"].toString();
          this.ownerPhoneNo.text =
              this.updateDataarray[0]["personph"].toString();
          this.street.text = this.updateDataarray[0]["street"].toString();
        } else if (this.widget.regOrAss == "register") {
          this.updateStatus = true;
          this.shopSyskey = this.updateDataarray[0]["id"].toString();
          this.shopName.text = this.updateDataarray[0]["name"].toString();
          this.shopNamemm.text = this.updateDataarray[0]["mmName"].toString();
          this.shopPhoneNo.text =
              this.updateDataarray[0]["phoneNumber"].toString();
          this.ownerName.text =
              this.updateDataarray[0]["personName"].toString();
          this.ownerPhoneNo.text =
              this.updateDataarray[0]["personPhoneNumber"].toString();
          this.street.text = this.updateDataarray[0]["street"].toString();
        }

        print("shopSyskey--> $shopSyskey");
      }
      _getState();
    });
//    });
  }

  _getState() {
    var params = {
      "id": "",
      "code": "",
      "description": "",
      "parentid": "",
      "n2": ""
    };
    onlineSerives.getState(params).then((value) => {
          stateObject = value["data"],
          for (var i = 0; i < stateObject.length; i++)
            {
              _stateList.add(stateObject[i]["description"]),
            }
        });
  }

  _getDistrict(params) {
    _districtList = [
      "District",
    ];
    _district = "District";
    _townShip = "TownShip";
    _townShipList = ["TownShip"];
    if (params != null) {
      onlineSerives.getDistrict(params).then((val) => {
            print(val.toString()),
            districtObject = val["data"],
            for (var i = 0; i < districtObject.length; i++)
              {
                setState(() {
                  _districtList.add(districtObject[i]["description"]);
                }),
              },
          });
    } else {
      setState(() {
        _districtList = [
          "District",
        ];
      });
    }
  }

  _getTownShip(params) {
    _townShip = "TownShip";
    _townShipList = [
      "TownShip",
    ];
    print("All Code" + allCode.toString());
    print("All Address" + allAddress.toString());
    if (params != null) {
      onlineSerives.getTownship(params).then((val) => {
            print(val.toString()),
            townShipObject = val["data"],
            for (var i = 0; i < townShipObject.length; i++)
              {
                setState(() {
                  _townShipList.add(townShipObject[i]["description"]);
                  print("Hello" + townShipObject[i]["id"]);
                }),
              },
          });
    } else {
      setState(() {
        _townShipList = [
          "District",
        ];
      });
    }
  }

  _getTown(params) {
    if (params != null) {
      onlineSerives.getTown(params).then(
            (value) => {
              townData = value['data'],
              for (var i = 0; i < townData.length; i++)
                {
                  setState(() {
                    _townList.add(townData[i]["description"]);
                  }),
                }
            },
          );
    }
  }

  _getWard(params) {
    if (params != null) {
      onlineSerives.getWard(params).then(
            (value) => {
              wardData = value['data'],
              print("Value" + wardData.toString()),
              for (var i = 0; i < wardData.length; i++)
                {
                  setState(() {
                    _wardList.add(wardData[i]["description"]);
                    print("Ward List" + _wardList.toString());
                  })
                }
            },
          );
    }
  }

  _getVillageTract(params) {
    if (params != null) {
      onlineSerives.getTown(params).then((value) => {
            _villageTractData = value['data'],
            for (var i = 0; i < _villageTractData.length; i++)
              {
                setState(() {
                  _villageTractList.add(_villageTractData[i]["description"]);
                })
              }
          });
    }
  }

  _getVillage(params) {
    if (params != null) {
      onlineSerives.getTown(params).then((value) => {
            _villageData = value['data'],
            for (var i = 0; i < _villageData.length; i++)
              {
                setState(() {
                  _villageList.add(_villageData[i]["description"]);
                })
              }
          });
    }
  }

  Future getImageFromCamera() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future getImageFromGallery() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  _showAlert() {
    Alert(
      context: context,
      title: "Add Image!",
      buttons: [
        DialogButton(
          child: Text(
            "Camera",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: () {
            getImageFromCamera();
            Navigator.pop(context);
          },
          color: CustomIcons.dropDownHeader,
        ),
        DialogButton(
          child: Text(
            "Gallery",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          onPressed: () {
            getImageFromGallery();
            Navigator.pop(context);
          },
          color: CustomIcons.dropDownHeader,
        ),
      ],
    ).show();
  }

  Widget storeImage() {
    if (_image == null) {
      return GestureDetector(
        onTap: () {
          _showAlert();
        },
        child: Container(
          height: 200,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Card(
            color: CustomIcons.dropDownHeader,
            child: Center(
              child: Icon(
                Icons.add,
                size: 100,
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        height: 200,
        child: Card(
          color: CustomIcons.dropDownHeader,
          child: Center(
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  child: Image(
                    image: FileImage(_image),
                    height: 200,
                    width: 400,
                  ),
                ),
                Positioned(
                  right: 2,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _image = null;
                      });
                    },
                    child: Image(
                      image: AssetImage('assets/close.png'),
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  var allCode;
  var allAddress;

  List<String> _stateList = ['State'];
  String _state = 'State';
  var stateObject;
  var _stateCode;
  var _stateId;

  List<String> _districtList = [
    'District',
  ];
  String _district = "District";
  var districtObject;
  var _districtCode;
  var _districtId;

  List<String> _townShipList = [
    'TownShip',
  ];
  String _townShip = 'TownShip';
  var townShipObject;
  var _townShipCode;
  var _townShipId;

  var _townOrVillagetractList = [
    'Town/Village Tract?',
    'Town',
    'Village Tract',
  ];
  String _townOrVillagetract = "Town/Village Tract?";

  var townCode;
  var _townId;
  var townData;
  List<String> _townList = ['Town'];
  String _town = "Town";

  var wardCode;
  var wardData;
  var wardId;
  List<String> _wardList = ["Ward"];
  String _ward = "Ward";

  var villageTractCode;
  var villageTractId;
  var _villageTractData;
  List<String> _villageTractList = ["Village Tract"];
  String _villageTract = "Village Tract";

  var villageCode;
  var _villageData;
  var villageId;
  List<String> _villageList = ["Village"];
  String _village = "Village";
  var n2Code;

  @override
  Widget build(BuildContext context) {
    return LoadingProvider(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          drawer: MainMenuWidget(),
          backgroundColor: Color(0xFFF8F8FF),
          appBar: AppBar(
            backgroundColor: CustomIcons.appbarColor,
            title: Text("Store Detail"),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20.0,
                        ),
                        IconButton(
                          icon: Icon(
                            Location.my_location,
                            color: CustomIcons.iconColor,
                            size: 25,
                          ),
                          onPressed: null,
                        ),
                        // Text(this.latitude),
                        Text(
                          "${latitude}" + " / " + "${longitude}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20.0,
                        ),
                        IconButton(
                          icon: Icon(
                            Circle.gplus_circled,
                            color: CustomIcons.iconColor,
                            size: 25,
                          ),
                          onPressed: null,
                        ),
                        // Text(this.latitude),
                        Text(
                          "Plus Code :",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        if (plusCode == null)
                          Text('')
                        else
                          Text(this.plusCode,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: TextField(
                      controller: shopName,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        prefixIcon: Icon(
                          Icons.store,
                          color: CustomIcons.iconColor,
                        ),
                        hintText: 'Name',
                        hintStyle: TextStyle(fontSize: 18, height: 1.5),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: TextField(
                      controller: shopNamemm,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        prefixIcon: Icon(
                          Icons.store,
                          color: CustomIcons.iconColor,
                        ),
                        hintText: 'ဆိုင်နာမည်',
                        hintStyle: TextStyle(fontSize: 18, height: 1.5),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: shopPhoneNo,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: CustomIcons.iconColor,
                        ),
                        hintText: 'Shop Phone No',
                        hintStyle: TextStyle(fontSize: 18, height: 1.5),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: TextField(
                      controller: ownerName,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: CustomIcons.iconColor,
                        ),
                        hintText: 'Owner Name',
                        hintStyle: TextStyle(fontSize: 18, height: 1.5),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: ownerPhoneNo,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: CustomIcons.iconColor,
                        ),
                        hintText: 'Owner Phone No',
                        hintStyle: TextStyle(fontSize: 18, height: 1.5),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 44.0),
                        margin:
                            EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
                        // margin: EdgeInsets.fromLTRB(left, top, right, bottom),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            items: _stateList.map(
                              (val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            value: _state,
                            onChanged: (value) {
                              setState(() {
                                _state = value;
                                for (var i = 0; i < stateObject.length; i++) {
                                  if (_state == stateObject[i]["description"]) {
                                    var data = {
                                      "id": "0",
                                      "code": "",
                                      "description": "",
                                      "parentid": stateObject[i]["id"]
                                    };
                                    print(data.toString());
                                    _stateId = stateObject[i]["id"];
                                    _stateCode = stateObject[i]["code"];
                                    _getDistrict(data);
                                    break;
                                  } else if (_state == "State") {
                                    n2Code = "0";
                                    _townOrVillagetract = "Town/Village Tract?";
                                    _getDistrict(null);
                                    break;
                                  }
                                }
                                _townOrVillagetract = "Town/Village Tract?";
                                n2Code = "0";
                                _town = "Town";
                                _townList = ['Town'];
                                _ward = "Ward";
                                _wardList = ['Ward'];
                                _villageTract = "Village Tract";
                                _villageTractList = ["Village Tract"];
                                _village = "Village";
                                _villageList = ["Village"];
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15.0, left: 28.0),
                        child: Icon(
                          Icons.location_on,
                          color: CustomIcons.iconColor,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 44.0),
                        margin:
                            EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            items: _districtList.map(
                              (val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            value: _district,
                            onChanged: (value) {
                              setState(() {
                                _district = value;
                                for (var i = 0;
                                    i < districtObject.length;
                                    i++) {
                                  if (_district ==
                                      districtObject[i]["description"]) {
                                    var data = {
                                      "id": "0",
                                      "code": "",
                                      "description": "",
                                      "parentid": districtObject[i]["id"]
                                    };
                                    print(data.toString());
                                    _districtId = districtObject[i]["id"];
                                    _districtCode = districtObject[i]["code"];
                                    _getTownShip(data);
                                    break;
                                  } else if (_district == "District") {
                                    _districtId = "";
                                    _districtCode = "";
                                    n2Code = "0";
                                    _townOrVillagetract = "Town/Village Tract?";
                                    _getTownShip(null);
                                    break;
                                  }
                                }
                                _townOrVillagetract = "Town/Village Tract?";
                                n2Code = "0";
                                _town = "Town";
                                _townList = ['Town'];
                                _ward = "Ward";
                                _wardList = ['Ward'];
                                _villageTract = "Village Tract";
                                _villageTractList = ["Village Tract"];
                                _village = "Village";
                                _villageList = ["Village"];
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 35.0, left: 28.0),
                        child: Icon(
                          Icons.location_on,
                          color: CustomIcons.iconColor,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 44.0),
                        margin:
                            EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            items: _townShipList.map(
                              (val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            value: _townShip,
                            onChanged: (value) {
                              setState(() {
                                _townShip = value;
                                for (var i = 0;
                                    i < townShipObject.length;
                                    i++) {
                                  if (_townShip ==
                                      townShipObject[i]["description"]) {
                                    var data = {
                                      "id": "0",
                                      "code": "",
                                      "description": "",
                                      "parentid": townShipObject[i]["id"]
                                    };
                                    _townShipId = townShipObject[i]["id"];
                                    _townShipCode = townShipObject[i]["code"];
                                    break;
                                  } else if (_townShip == "TownShip") {
                                    _townShipId = "";
                                    _townShipCode = "";
                                    break;
                                  }
                                }
                                _townOrVillagetract = "Town/Village Tract?";
                                n2Code = "0";
                                _town = "Town";
                                _townList = ['Town'];
                                _ward = "Ward";
                                _wardList = ['Ward'];
                                _villageTract = "Village Tract";
                                _villageTractList = ["Village Tract"];
                                _village = "Village";
                                _villageList = ["Village"];
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 35.0, left: 28.0),
                        child: Icon(
                          Icons.location_on,
                          color: CustomIcons.iconColor,
                        ),
                      ),
                    ],
                  ),
                  if (_townShip != "TownShip")
                    Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 44.0),
                          margin: EdgeInsets.only(
                              top: 20.0, left: 16.0, right: 16.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              items: _townOrVillagetractList.map(
                                (val) {
                                  return DropdownMenuItem(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList(),
                              value: _townOrVillagetract,
                              onChanged: (value) {
                                setState(() {
                                  _townOrVillagetract = value;
                                  for (var i = 0;
                                      i < townShipObject.length;
                                      i++) {
                                    if (value == "Town") {
                                      n2Code = "1";
                                      var paramsTown = {
                                        "id": "0",
                                        "code": "",
                                        "description": "",
                                        "parentid": townShipObject[i]["id"],
                                        "n2": "1"
                                      };
                                      _getTown(paramsTown);
                                    } else {
                                      _town = "Town";
                                      _ward = "Ward";
                                    }
                                    if (value == "Village Tract") {
                                      n2Code = "2";
                                      var paramsTract = {
                                        "id": "0",
                                        "code": "",
                                        "description": "",
                                        "parentid": townShipObject[i]["id"],
                                        "n2": "2"
                                      };
                                      _getVillageTract(paramsTract);
                                    } else {
                                      _villageTract = "Village Tract";
                                      _village = "Village";
                                    }
                                    if (value == "Town/Village Tract?") {
                                      n2Code = "0";
                                      _town = "Town";
                                      _ward = "Ward";
                                      _villageTract = "Village Tract";
                                      _village = "Village";
                                    }
                                  }
                                  _town = "Town";
                                  _townList = ['Town'];
                                  _ward = "Ward";
                                  _wardList = ['Ward'];
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 35.0, left: 28.0),
                          child: Icon(
                            Icons.not_listed_location,
                            color: CustomIcons.iconColor,
                          ),
                        ),
                      ],
                    ),
                  if (n2Code == "1")
                    Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 44.0),
                          margin: EdgeInsets.only(
                              top: 20.0, left: 16.0, right: 16.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              items: _townList.map(
                                (val) {
                                  return DropdownMenuItem(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList(),
                              value: _town,
                              onChanged: (value) {
                                setState(() {
                                  _town = value;
                                  for (var i = 0; i < townData.length; i++) {
                                    var params = {
                                      "id": "0",
                                      "code": "",
                                      "description": "",
                                      "parentid": townData[i]["id"],
                                      "n2": "1"
                                    };
                                    print("this is townId" + townData[i]["id"]);
                                    townCode = townData[i]["code"];
                                    _townId = townData[i]["id"];
                                    _getWard(params);
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 35.0, left: 28.0),
                          child: Icon(
                            Icons.location_on,
                            color: CustomIcons.iconColor,
                          ),
                        ),
                      ],
                    ),
                  if (n2Code == "1")
                    Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 44.0),
                          margin: EdgeInsets.only(
                              top: 20.0, left: 16.0, right: 16.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              items: _wardList.map(
                                (val) {
                                  return DropdownMenuItem(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList(),
                              value: _ward,
                              onChanged: (value) {
                                setState(() {
                                  _ward = value;
                                  for (var i = 0; i < wardData.length; i++) {
                                    wardCode = wardData[i]["code"];
                                    wardId = wardData[i]["id"];
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 35.0, left: 28.0),
                          child: Icon(
                            Icons.location_on,
                            color: CustomIcons.iconColor,
                          ),
                        ),
                      ],
                    ),
                  if (n2Code == "2")
                    Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 44.0),
                          margin: EdgeInsets.only(
                              top: 20.0, left: 16.0, right: 16.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              items: _villageTractList.map(
                                (val) {
                                  return DropdownMenuItem(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList(),
                              value: _villageTract,
                              onChanged: (value) {
                                setState(() {
                                  _villageTract = value;
                                  for (var i = 0;
                                      i < _villageTractData.length;
                                      i++) {
                                    villageTractCode =
                                        _villageTractData[i]["code"];
                                    villageTractId = _villageTractData[i]["id"];
                                    var params = {
                                      "id": "0",
                                      "code": "",
                                      "description": "",
                                      "parentid": _villageTractData[i]["id"],
                                      "n2": "2"
                                    };
                                    _getVillage(params);
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 35.0, left: 28.0),
                          child: Icon(
                            Icons.location_on,
                            color: CustomIcons.iconColor,
                          ),
                        ),
                      ],
                    ),
                  if (n2Code == "2")
                    Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 44.0),
                          margin: EdgeInsets.only(
                              top: 20.0, left: 16.0, right: 16.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              items: _villageList.map(
                                (val) {
                                  return DropdownMenuItem(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList(),
                              value: _village,
                              onChanged: (value) {
                                setState(() {
                                  _village = value;
                                  for (var i = 0;
                                      i < _villageData.length;
                                      i++) {
                                    villageCode = _villageData[i]["code"];
                                    villageId = _villageData[i]["id"];
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 35.0, left: 28.0),
                          child: Icon(
                            Icons.location_on,
                            color: CustomIcons.iconColor,
                          ),
                        ),
                      ],
                    ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    // margin: EdgeInsets.fromLTRB(23, 20, 20, 20),
                    child: TextField(
                      controller: street,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: CustomIcons.iconColor,
                        ),
                        hintText: 'Street',
                        hintStyle: TextStyle(fontSize: 18, height: 1.5),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  // Container(

                  //   margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  //   child: Column(
                  //     children: <Widget>[
                  //       Card(
                  //         child: Row(children: <Widget>[
                  //           Text("Latitude :",style: TextStyle(
                  //             fontSize: 20,
                  //           ),),
                  //           SizedBox(width: 10,),
                  //           Text(latitude,style: TextStyle(
                  //             fontSize: 20,
                  //           ),),
                  //         ],)
                  //       ),
                  //       Card(
                  //         child: Row(children: <Widget>[
                  //           Text("Longitude :",style: TextStyle(
                  //             fontSize: 20,
                  //           ),),
                  //           SizedBox(width: 10,),
                  //           Text(longitude,style: TextStyle(
                  //             fontSize: 20,
                  //           ),),
                  //         ],)
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // storeImage(),
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
//                  showLoading();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => StoreScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 40,
                    width: 300,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Center(
                      child: Text("Back",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15)),
                    ),
                  ),
                ),
              ),
              new BottomNavigationBarItem(
                icon: new Container(),
                title: InkWell(
                  onTap: () {
                    var param;
                    if (this.shopName.text == "" ||
                        this.shopName.text == null ||
                        this.shopName.text.isEmpty ||
                        this.shopNamemm.text == "" ||
                        this.shopNamemm.text == null ||
                        this.shopNamemm.text.isEmpty ||
                        this.shopPhoneNo.text == "" ||
                        this.shopPhoneNo.text == null ||
                        this.shopPhoneNo.text.isEmpty ||
                        this.ownerName.text == "" ||
                        this.ownerName.text == null ||
                        this.ownerName.text.isEmpty ||
                        this.ownerPhoneNo.text == "" ||
                        this.ownerPhoneNo.text == null ||
                        this.ownerPhoneNo.text.isEmpty ||
                        this.street.text == "" ||
                        this.street.text == null ||
                        this.street.text.isEmpty) {
                      ShowToast("Please fill all fields");
                    } else {
                      showLoading();
                      this.shopPhoneNo.text =
                          getPhoneNumber(this.shopPhoneNo.text);
                      this.ownerPhoneNo.text =
                          getPhoneNumber(this.ownerPhoneNo.text);
                      if (this.updateStatus == true) {
                        param = {
                          "id": this.shopSyskey,
                          "active": true,
                          "name": this.shopName.text.toString(),
                          "mmName": this.shopNamemm.text.toString(),
                          "personName": this.ownerName.text.toString(),
                          "personPhoneNumber":
                              this.ownerPhoneNo.text.toString(),
                          "phoneNumber": this.shopPhoneNo.text.toString(),
                          "stateId": _stateId,
                          "districtId": _districtId,
                          "townshipId": _townShipId,
                          "townId": _townId,
                          "wardId": "0",
                          "address": this.allAddress,
                          "street": this.street.text.toString(),
                          "t12": "",
                          "locationData": {
                            "latitude": latitude,
                            "longitude": longitude,
                            "plusCode": this.plusCode.toString(),
                            "minuCode": '',
                          }
                        };
                      } else {
                        allCode = townCode +
                            "," +
                            _townShipCode +
                            "," +
                            _districtCode +
                            "," +
                            _stateCode;
                        allAddress = street.text +
                            "" +
                            _town +
                            "" +
                            _townShip +
                            "" +
                            _district +
                            "" +
                            _state;
                        param = {
                          "active": true,
                          "name": this.shopName.text.toString(),
                          "mmName": this.shopNamemm.text.toString(),
                          "personName": this.ownerName.text.toString(),
                          "personPhoneNumber":
                              this.ownerPhoneNo.text.toString(),
                          "phoneNumber": this.shopPhoneNo.text.toString(),
                          "stateId": _stateId,
                          "districtId": _districtId,
                          "townshipId": _townShipId,
                          "townId": _townId,
                          "wardId": "0",
                          "address": this.allAddress,
                          "street": this.street.text.toString(),
                          "t12": "",
                          "locationData": {
                            "latitude": latitude,
                            "longitude": longitude,
                            "plusCode": this.plusCode.toString(),
                            "minuCode": this.allCode,
                          }
                        };
                      }
                      ;
                      print("Data" + "${param}");
                      this.onlineSerives.createStore(param).then((reslut) => {
                            print("${reslut}"),
                            if (reslut["status"] == true)
                              {
                                hideLoadingDialog(),
                                if (this.updateStatus == false)
                                  {
                                    ShowToast("Saved successfully."),
                                  }
                                else
                                  {
                                    ShowToast("Updated successfully."),
                                  },
                                setState(() {
                                  this.createRegistration = reslut["data"];
                                  print("hello" + "${reslut["data"]}");
                                  this.updateDataarray = [
                                    this.createRegistration
                                  ];
                                  this.shopSyskey =
                                      this.updateDataarray[0]["id"].toString();
                                  print("$shopSyskey");
                                  this.updateStatus = true;
                                  this.widget.updateStatuspass =
                                      this.updateStatus;
                                }),
                              }
                            else
                              {
                                hideLoadingDialog(),
                              }
                          });
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 300,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Center(
                      child: this.updateStatus == false
                          ? Text(
                              "Save",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15),
                            )
                          : Text(
                              "Update",
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
                title: InkWell(
                  onTap: () {
                    if (this.updateStatus == true) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => CheckNeighborhoodScreen(
                                this.shopName.text,
                                this.shopPhoneNo.text,
                                this.street.text,
                                "register",
                                this.widget.passData)
                            //  OutsideInsideNeighborhood(
                            //   this.shopName.text,
                            //   this.shopNamemm.text,
                            //   this.shopPhoneNo.text,
                            //   this.ownerName.text,
                            //   this.ownerPhoneNo.text,
                            //   this.street.text,
                            //   this.plusCode,
                            //   this.widget.regOrAss,
                            //   this.widget.passData,
                            // ),
                            ),
                      );
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 300,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Center(
                      child: this.updateStatus == false
                          ? Text(
                              "Next",
                              style: TextStyle(
                                  color: Colors.white38,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          : Text(
                              "Next",
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
      ),
    );
  }
}
