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
import 'package:localstorage/localstorage.dart';
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
  final LocalStorage storage = new LocalStorage('Surveyor');

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
      _getState();
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
        if (this.widget.regOrAss == "Map") {
          var _latLong = this.storage.getItem("Maplatlong");
          print("--->" + _latLong.toString());
          latitude = _latLong["lat"];
          longitude = _latLong["long"];
        } else {
          latitude = k.latitude;
          longitude = k.longitude;
        }

        googlePlusparam = {"lat": latitude, "lng": longitude};
        this.onlineSerives.getGooglePlusCode(googlePlusparam).then(
              (result) => {
                if (result["status"] == true)
                  {
                    setState(() {
                      this.plusCode = "${result["data"]["plusCode"]}";
                      hideLoadingDialog();
                    }),
                  }
                else
                  {
                    hideLoadingDialog(),
                  }
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
          this.allAddress = this.updateDataarray[0]["address"].toString();
          this._stateId = this.updateDataarray[0]['stateid'].toString();
          this._districtId = this.updateDataarray[0]['districtid'].toString();
          this._townShipId = this.updateDataarray[0]['townshipid'].toString();
          this._townId = this.updateDataarray[0]['townid'].toString();
          this._wardId = this.updateDataarray[0]['wardid'].toString();
          _getUpdateData();
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
          this.allAddress = this.updateDataarray[0]["address"].toString();
          this._stateId = this.updateDataarray[0]['stateid'].toString();
          this._districtId = this.updateDataarray[0]['districtid'].toString();
          this._townShipId = this.updateDataarray[0]['townshipid'].toString();
          this._townId = this.updateDataarray[0]['townid'].toString();
          this._wardId = this.updateDataarray[0]['wardid'].toString();
          _getUpdateData();
        }

        print("shopSyskey--> $shopSyskey");
      }
    });
  }

  _getUpdateData() {
    var params = {
      "id": "",
      "code": "",
      "description": "",
      "parentid": "",
      "n2": ''
    };
    onlineSerives.getState(params).then((value) => {
          this.stateObject = value["data"],
          for (var i = 0; i < stateObject.length; i++)
            {
              if (this._stateId == stateObject[i]['id'])
                {
                  this._state = stateObject[i]['description'],
                }
            }
        });
    var districtData = {
      "id": "0",
      "code": "",
      "description": "",
      "parentid": this._stateId,
      "n2": ''
    };
    onlineSerives.getDistrict(districtData).then((val) => {
          this.districtObject = val["data"],
          for (var i = 0; i < districtObject.length; i++)
            {
              _districtList.add(districtObject[i]["description"]),
              if (this._districtId == districtObject[i]['id'])
                {
                  this._district = districtObject[i]['description'],
                }
            },
        });
    var townData = {
      "id": "",
      "code": "",
      "description": "",
      "parentid": this._districtId,
    };
    onlineSerives.getTownship(townData).then((val) => {
          this.townShipObject = val["data"],
          for (var i = 0; i < townShipObject.length; i++)
            {
              _townShipList.add(townShipObject[i]['description']),
              if (this._townShipId == townShipObject[i]['id'])
                {
                  this._townShip = townShipObject[i]["description"],
                }
            },
        });

    var dataTown = {
      "id": "",
      "code": "",
      "description": "",
      "parentid": this._townShipId,
      "n2": "0"
    };
    onlineSerives.getTown(dataTown).then(
          (value) => {
            this.townData = value["data"],
            for (var i = 0; i < this.townData.length; i++)
              {
                if (this._townId == this.townData[i]['id'])
                  {
                    this.n2Code = this.townData[i]['n2'],
                    if (this.n2Code == 1)
                      {
                        this.n2Code = '1',
                        _townOrVillagetract = "Town",
                        _townList.add(this.townData[i]['description']),
                        _town = this.townData[i]['description'],
                      }
                    else if (this.n2Code == 2)
                      {
                        this.n2Code = '2',
                        _townOrVillagetract = "Village Tract",
                        _villageTractList.add(this.townData[i]['description']),
                        _villageTract = this.townData[i]['description'],
                      }
                  }
              }
          },
        );
    var dataWard = {
      "id": "",
      "code": "",
      "description": "",
      "parentid": this._townId,
      "n2": "1"
    };
    onlineSerives.getWard(dataWard).then(
          (value) => {
            this.wardData = value['data'],
            for (var i = 0; i < wardData.length; i++)
              {
                _wardList.add(wardData[i]["description"]),
                if (this._wardId == wardData[i]['id'])
                  {
                    this._ward = wardData[i]['description'],
                  }
              }
          },
        );

    // var dataParams = {
    //   "id": "",
    //   "code": "",
    //   "description": "",
    //   "parentid": this._townId,
    //   "n2": "2"
    // };
    // onlineSerives.getWard(dataParams).then((value) => {
    //       _villageData = value['data'],
    //       for (var i = 0; i < _villageData.length; i++)
    //         {
    //           _villageList.add(_villageData[i]['description']),
    //           if (this._wardId == _villageData[i]['id'])
    //             {
    //               this._village = _villageData[i]['description'],
    //             }
    //         }
    //     });
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
      "-",
    ];
    _district = "-";
    _townShip = "-";
    _townShipList = ["-"];
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
          "-",
        ];
      });
    }
  }

  _getTownShip(params) {
    _townShip = "-";
    _townShipList = [
      "-",
    ];
    if (params != null) {
      onlineSerives.getTownship(params).then((val) => {
            print(val.toString()),
            townShipObject = val["data"],
            for (var i = 0; i < townShipObject.length; i++)
              {
                setState(() {
                  _townShipList.add(townShipObject[i]["description"]);
                }),
              },
          });
    } else {
      setState(() {
        _townShipList = [
          "-",
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

  List<String> _stateList = ['-'];
  String _state = '-';
  var stateObject;
  var _stateCode;
  var _stateId;

  List<String> _districtList = [
    '-',
  ];
  String _district = "-";
  var districtObject;
  var _districtCode;
  var _districtId;

  List<String> _townShipList = [
    '-',
  ];
  String _townShip = '-';
  var townShipObject;
  var _townShipCode;
  var _townShipId;

  var _townOrVillagetractList = [
    '-',
    'Town',
    'Village Tract',
  ];
  String _townOrVillagetract = "-";

  var townCode;
  var _townId;
  var townData;
  List<String> _townList = ['-'];
  String _town = "-";

  var wardCode;
  var wardData;
  var _wardId;
  List<String> _wardList = ["-"];
  String _ward = "-";

  var villageTractCode;
  var villageTractId;
  var _villageTractData;
  List<String> _villageTractList = ["-"];
  String _villageTract = "-";

  var villageCode;
  var _villageData;
  var villageId;
  List<String> _villageList = ["-"];
  String _village = "-";
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
                          width: 5.0,
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
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: TextFormField(
                      controller: shopName,
                      cursorColor: CustomIcons.textField,
                      decoration: InputDecoration(
                        labelText: 'Shop Name',
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 18),
                        focusColor: Colors.black,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: TextFormField(
                      controller: shopNamemm,
                      cursorColor: CustomIcons.textField,
                      decoration: InputDecoration(
                        labelText: 'Shop Name (Myanmar)',
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 18),
                        focusColor: Colors.black,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: shopPhoneNo,
                      cursorColor: CustomIcons.textField,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        labelText: 'Shop Phone No',
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 18),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: TextFormField(
                      controller: ownerName,
                      cursorColor: CustomIcons.textField,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        labelText: 'Owner Name',
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 18),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: ownerPhoneNo,
                      cursorColor: CustomIcons.textField,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        labelText: 'Owner Phone No',
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 18),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                          "State",
                          style: TextStyle(fontSize: 17, color: Colors.black54),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        child: DropdownButtonHideUnderline(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                                    if (_state ==
                                        stateObject[i]["description"]) {
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
                                    } else if (_state == "-") {
                                      n2Code = "0";
                                      _townOrVillagetract = "-";
                                      _getDistrict(null);
                                      break;
                                    }
                                  }
                                  _townOrVillagetract = "-";
                                  n2Code = "0";
                                  _town = "-";
                                  _townList = ['-'];
                                  _ward = "-";
                                  _wardList = ['-'];
                                  _villageTract = "-";
                                  _villageTractList = ["-"];
                                  _village = "-";
                                  _villageList = ["-"];
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                          "District",
                          style: TextStyle(fontSize: 17, color: Colors.black54),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        child: DropdownButtonHideUnderline(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                                    } else if (_district == "-") {
                                      _districtId = "";
                                      _districtCode = "";
                                      n2Code = "0";
                                      _townOrVillagetract = "-";
                                      _getTownShip(null);
                                      break;
                                    }
                                  }
                                  _townOrVillagetract = "-";
                                  n2Code = "0";
                                  _town = "-";
                                  _townList = ['-'];
                                  _ward = "-";
                                  _wardList = ['-'];
                                  _villageTract = "-";
                                  _villageTractList = ["-"];
                                  _village = "-";
                                  _villageList = ["-"];
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 20),
                        child: Text(
                          "TownShip",
                          style: TextStyle(fontSize: 17, color: Colors.black54),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        child: DropdownButtonHideUnderline(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                                    } else if (_townShip == "-") {
                                      _townShipId = "";
                                      _townShipCode = "";
                                      break;
                                    }
                                  }
                                  _townOrVillagetract = "-";
                                  n2Code = "0";
                                  _town = "-";
                                  _townList = ['-'];
                                  _ward = "-";
                                  _wardList = ['-'];
                                  _villageTract = "-";
                                  _villageTractList = ["-"];
                                  _village = "-";
                                  _villageList = ["-"];
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_townShip != "-")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            "Town/Village Tract?",
                            style:
                                TextStyle(fontSize: 17, color: Colors.black54),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                items: _townOrVillagetractList.map(
                                  (val) {
                                    return DropdownMenuItem(
                                      value: val,
                                      child: Text(
                                        val,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  },
                                ).toList(),
                                value: _townOrVillagetract,
                                onChanged: (value) {
                                  setState(() {
                                    _townOrVillagetract = value;
                                    if (value == "Town") {
                                      n2Code = "1";
                                      var paramsTown = {
                                        "id": "",
                                        "code": "",
                                        "description": "",
                                        "parentid": _townShipId,
                                        "n2": "1"
                                      };
                                      _getTown(paramsTown);
                                    } else {
                                      _town = "-";
                                      _ward = "-";
                                    }
                                    if (value == "Village Tract") {
                                      n2Code = "2";
                                      var paramsTract = {
                                        "id": "",
                                        "code": "",
                                        "description": "",
                                        "parentid": _townShipId,
                                        "n2": "2"
                                      };
                                      _getVillageTract(paramsTract);
                                    } else {
                                      _villageTract = "-";
                                      _village = "-";
                                    }
                                    if (value == '-') {
                                      n2Code = "0";
                                      _town = "-";
                                      _ward = "-";
                                      _villageTract = "-";
                                      _village = "-";
                                    }
                                    _town = "-";
                                    _townList = ['-'];
                                    _ward = "-";
                                    _wardList = ['-'];
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (n2Code == "1")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            "Town",
                            style:
                                TextStyle(fontSize: 17, color: Colors.black54),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                                        "id": "",
                                        "code": "",
                                        "description": "",
                                        "parentid": townData[i]["id"],
                                        "n2": "1"
                                      };
                                      townCode = townData[i]["code"];
                                      _townId = townData[i]["id"];
                                      _getWard(params);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (n2Code == "1")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            "Ward",
                            style:
                                TextStyle(fontSize: 17, color: Colors.black54),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                                      _wardId = wardData[i]["id"];
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (n2Code == "2")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            "Village Tract",
                            style:
                                TextStyle(fontSize: 17, color: Colors.black54),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                                      var params = {
                                        "id": "",
                                        "code": "",
                                        "description": "",
                                        "parentid": _villageTractData[i]["id"],
                                        "n2": "2"
                                      };
                                      villageTractCode =
                                          _villageTractData[i]["code"];
                                      villageTractId =
                                          _villageTractData[i]["id"];
                                      _getVillage(params);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (n2Code == "2")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            "Village",
                            style:
                                TextStyle(fontSize: 17, color: Colors.black54),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                        ),
                      ],
                    ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: TextFormField(
                      controller: street,
                      cursorColor: CustomIcons.textField,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        labelText: 'Street',
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 18),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
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
                      showLoading();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => StoreScreen(),
                        ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
//                          decoration: BoxDecoration(color: Color(0xffe53935)),
                          constraints: BoxConstraints(minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Back",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      var param;
                      if (this._state == null ||
                          this._state == "-" ||
                          this._state.isEmpty ||
                          this._district == null ||
                          this._district == "-" ||
                          this._district.isEmpty ||
                          this._townShip == null ||
                          this._townShip == "-" ||
                          this._townShip.isEmpty ||
                          this._townOrVillagetract == null ||
                          this._townOrVillagetract == "-" ||
                          this._townOrVillagetract.isEmpty ||
//                        this._town == null ||
//                        this._town == "Town" ||
//                        this._town.isEmpty ||
//                        this._ward == null ||
//                        this._ward == "Ward" ||
//                        this._ward.isEmpty ||
//                        this._villageTract == null ||
//                        this._villageTract == "Village Tract" ||
//                        this._villageTract.isEmpty ||
//                        this._village == null ||
//                        this._village == "Village" ||
//                        this._village.isEmpty ||
                          this.shopName.text == "" ||
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
                        if (this.n2Code == 1) {
                          allCode = wardCode +
                              "" +
                              townCode +
                              "" +
                              _townShipCode +
                              "" +
                              _districtCode +
                              "" +
                              _stateCode;
                          allAddress = street.text +
                              "," +
                              _ward +
                              "," +
                              _town +
                              "," +
                              _townShip +
                              "," +
                              _district +
                              "," +
                              _state;
                        } else if (this.n2Code == 2) {
                          allCode = villageCode +
                              "" +
                              villageTractCode +
                              "" +
                              _townShipCode +
                              "" +
                              _districtCode +
                              "" +
                              _stateCode;
                          allAddress = street.text +
                              "," +
                              _village +
                              "," +
                              _villageTract +
                              "," +
                              _townShip +
                              "," +
                              _district +
                              "," +
                              _state;
                        }
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
                            "townId":
                                this.n2Code == 1 ? _townId : villageTractId,
                            "wardId": this.n2Code == 1 ? _wardId : villageId,
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
                            "townId":
                                this.n2Code == 1 ? _townId : villageTractId,
                            "wardId": this.n2Code == 1 ? _wardId : villageId,
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
                                    this.shopSyskey = this
                                        .updateDataarray[0]["id"]
                                        .toString();
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
                    child: Column(
                      children: <Widget>[
                        Container(
//                          decoration: BoxDecoration(color: Color(0xffe53935)),
                          constraints: BoxConstraints(minHeight: 50.0),
                          alignment: Alignment.center,
                          child: this.updateStatus == false
                              ? Text(
                                  "Save",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )
                              : Text(
                                  "Update",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (this.updateStatus == true) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => CheckNeighborhoodScreen(
                                  this.shopName.text,
                                  this.shopPhoneNo.text,
                                  this.allAddress,
                                  this.widget.regOrAss,
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
                    child: Column(
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(minHeight: 50.0),
                          alignment: Alignment.center,
                          child: this.updateStatus == false
                              ? Text(
                                  "Next",
                                  style: TextStyle(
                                      color: Colors.white38, fontSize: 16),
                                )
                              : Text(
                                  "Next",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
