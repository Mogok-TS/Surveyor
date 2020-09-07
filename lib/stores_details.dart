import 'dart:io' as io;
import 'package:Surveyor/Map/map.dart';
import 'package:Surveyor/assets/location_icons.dart';
import 'package:Surveyor/stores.dart';
import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';
import 'package:Surveyor/Services/GeneralUse/Geolocation.dart';
import 'package:Surveyor/Services/Messages/Messages.dart';
import 'package:Surveyor/Services/Loading/LoadingServices.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:load/load.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'Services/GeneralUse/PhoneNumber.dart';
import 'assets/custom_icons_icons.dart';
import 'checkNeighborhood.dart';
import 'Map/map.dart';

// ignore: must_be_immutable
class StoresDetailsScreen extends StatefulWidget {
  var regOrAss;
  var passData, updateStatuspass, coordiante;

  StoresDetailsScreen(
      this.passData, this.updateStatuspass, this.regOrAss, this.coordiante);

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
  ScrollController _controller = new ScrollController();

  var geolocator = Geolocator();
  Future<bool> gpsCheck;
  var googlePlusparam;
  var updateDataarray = [];

  var plusCode, storeRegistration;
  double longitude = 0;
  double latitude = 0;
  var createRegistration;
  List mpaArray;
  List<LatLng> latlng;
  List list1 = [];
  List list2 = [];
  double lati;
  double long;
  LatLng location;
  LatLng curLocation;
  var townshipMimucode, stateCode;

  @override
  void initState() {
    super.initState();
    this.mpaArray = this.storage.getItem("mapArray");
    print("map--->" + this.mpaArray.length.toString());
    setState(
      () {
        Future.delayed(const Duration(milliseconds: 500), () {
          showLoading();
        });
        _state = "-";
        _stateList = ["-"];
        _districtList = [
          "-",
        ];
        _district = "-";
        _townShip = "-";
        _townShipList = ["-"];
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
        if (this.updateDataarray.length == 0) {
          this.updateStatus = false;
        } else {
          this.updateStatus = true;
          if (this.widget.regOrAss == "assign") {
            this.shopSyskey = this.updateDataarray[0]["shopsyskey"].toString();
            this.shopName.text = this.updateDataarray[0]["shopname"].toString();
            this.shopNamemm.text =
                this.updateDataarray[0]["shopnamemm"].toString();
            this.shopPhoneNo.text =
                this.updateDataarray[0]["phoneno"].toString();
            this.ownerName.text =
                this.updateDataarray[0]["personname"].toString();
            this.ownerPhoneNo.text =
                this.updateDataarray[0]["personph"].toString();
            this.street.text = this.updateDataarray[0]["street"].toString();
            this.allAddress = this.updateDataarray[0]["address"].toString();
            this._stateId = this.updateDataarray[0]["stateid"].toString();
            this._districtId = this.updateDataarray[0]["districtid"].toString();
            this._townShipId = this.updateDataarray[0]["townshipid"].toString();
            this.townVillageTractId =
                this.updateDataarray[0]["townid"].toString();
            this.wardVillageId = this.updateDataarray[0]["wardid"].toString();
            this.latitude = double.parse(this.updateDataarray[0]["lat"]);
            this.longitude = double.parse(this.updateDataarray[0]["long"]);
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
            this._stateId = this.updateDataarray[0]["stateId"].toString();
            this._districtId = this.updateDataarray[0]["districtId"].toString();
            this._townShipId = this.updateDataarray[0]["townshipId"].toString();
            this.townVillageTractId =
                this.updateDataarray[0]['townId'].toString();
            this.wardVillageId = this.updateDataarray[0]["wardId"].toString();
            this.latitude = this.updateDataarray[0]["locationData"]["latitude"];
            this.longitude =
                this.updateDataarray[0]["locationData"]["longitude"];
            _getUpdateData();
          } else if (this.widget.regOrAss == "newStoreMap") {
            for (var i = 0; i < this.widget.coordiante.length; i++) {
              latitude = this.widget.coordiante[i]["lat"];
              longitude = this.widget.coordiante[i]["long"];
            }
          } else if (this.widget.regOrAss == "assignStore") {
            this.shopSyskey = this.updateDataarray[0]["shopsyskey"].toString();
            this.shopName.text = this.updateDataarray[0]["shopname"].toString();
            this.shopNamemm.text =
                this.updateDataarray[0]["shopnamemm"].toString();
            this.shopPhoneNo.text =
                this.updateDataarray[0]["phoneno"].toString();
            this.ownerName.text =
                this.updateDataarray[0]["personname"].toString();
            this.ownerPhoneNo.text =
                this.updateDataarray[0]["personph"].toString();
            this.street.text = this.updateDataarray[0]["street"].toString();
            this.allAddress = this.updateDataarray[0]["address"].toString();
            this._stateId = this.updateDataarray[0]["stateid"].toString();
            this._districtId = this.updateDataarray[0]["districtid"].toString();
            this._townShipId = this.updateDataarray[0]["townshipid"].toString();
            this.townVillageTractId =
                this.updateDataarray[0]["townid"].toString();
            this.wardVillageId = this.updateDataarray[0]["wardid"].toString();
            if (this.widget.updateStatuspass == true) {
              this.latitude = double.parse(this.updateDataarray[0]["lat"]);
              this.longitude = double.parse(this.updateDataarray[0]["long"]);
            } else if (this.widget.updateStatuspass == false) {
              for (var i = 0; i < this.widget.coordiante.length; i++) {
                latitude = this.widget.coordiante[i]["lat"];
                longitude = this.widget.coordiante[i]["long"];
              }
            }
            _getUpdateData();
          }
          print("shopSyskey--> $shopSyskey");
        }
        getCurrentLocation().then(
          (k) {
            print({"$k"});
            Future.delayed(const Duration(milliseconds: 600), () {
              if (this.widget.regOrAss == "Map") {
                var _latLong = this.storage.getItem("Maplatlong");
                print("--->" + _latLong.toString());
                latitude = _latLong["lat"];
                longitude = _latLong["long"];
              } else if (this.widget.regOrAss == "newStore") {
                latitude = k.latitude;
                longitude = k.longitude;
              }

              googlePlusparam = {"lat": latitude, "lng": longitude};
              this.onlineSerives.getGooglePlusCode(googlePlusparam).then(
                    (result) => {
                      if (result["status"] == true)
                        {
//                  print("12-->" + mpaArray.toString()),
                          for (var a = 0; a < mpaArray.length; a++)
                            {
                              latlng = List(),
                              setState(() {
                                latlng = [];
                              }),

                              list1 = mpaArray
                                  .where((element) =>
                                      element["properties"]["TS_PCODE"]
                                          .toString() ==
                                      mpaArray[a]["properties"]["TS_PCODE"]
                                          .toString())
                                  .toList(),
//                      print("123-->" + list1.toString()),
                              for (var b = 0; b < list1.length; b++)
                                {
                                  list2 = list1[b]["geometry"]["coordinates"],
//                        print("43-->" + list2.toString()),
                                  for (var c = 0; c < list2.length; c++)
                                    {
                                      for (var d = 0; d < list2[c].length; d++)
                                        {
                                          for (var e = 0;
                                              e < list2[c][d].length;
                                              e++)
                                            {
                                              lati = double.parse(
                                                  list2[c][d][e][1].toString()),
                                              long = double.parse(
                                                  list2[c][d][e][0].toString()),
                                              location = LatLng(lati, long),
                                              latlng.add(location),
                                            }
                                        }
                                    }
                                },
                              curLocation = LatLng(latitude, longitude),
                              _checkIfValidMarker(
                                  curLocation,
                                  latlng,
                                  mpaArray[a]["properties"]["TS_PCODE"]
                                      .toString()),
                            },
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
          },
        );
      },
    );
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
              if (this.widget.regOrAss == "assign" ||
                  this.widget.regOrAss == "register" ||
                  this.widget.regOrAss == "assignStore")
                {
                  if (this._stateId == stateObject[i]['id'])
                    {
                      this._state = stateObject[i]['description'],
                      _stateCode = stateObject[i]['code'],
                    },
                }
              else if (this.widget.regOrAss == "newStore")
                {
                  if (this._stateCode == stateObject[i]['code'])
                    {
                      this._stateId = stateObject[i]['id'],
                      this._state = stateObject[i]['description'],
                    }
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
              if (this.widget.regOrAss == "assign" ||
                  this.widget.regOrAss == "register" ||
                  this.widget.regOrAss == "assignStore")
                {
                  if (this._districtId == districtObject[i]['id'])
                    {
                      this._district = districtObject[i]['description'],
                      _districtCode = districtObject[i]["code"],
                    }
                }
              else if (this.widget.regOrAss == "newStore")
                {
                  if (this._districtCode == districtObject[i]['code'])
                    {
                      this._districtId = districtObject[i]['id'],
                      this._district = districtObject[i]['description'],
                    }
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
              if (this.widget.regOrAss == "assign" ||
                  this.widget.regOrAss == "register" ||
                  this.widget.regOrAss == "assignStore")
                {
                  if (this._townShipId == townShipObject[i]['id'])
                    {
                      this._townShip = townShipObject[i]["description"],
                      _townShipCode = townShipObject[i]["code"],
                    }
                }
              else if (this.widget.regOrAss == "newStore")
                {
                  if (this._townShipCode == townShipObject[i]['code'])
                    {
                      this._townShip = townShipObject[i]["description"],
                      this._town = townShipObject[i]["id"],
                    }
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
                if (this.widget.regOrAss == "assign" ||
                    this.widget.regOrAss == "register" ||
                    this.widget.regOrAss == "assignStore")
                  {
                    if (this.townVillageTractId == this.townData[i]['id'])
                      {
                        this.n2Code = this.townData[i]['n2'],
                        if (this.n2Code == 1)
                          {
                            this.n2Code = '1',
                            _townOrVillagetract = "Town",
                            _townList.add(this.townData[i]['description']),
                            _town = this.townData[i]['description'],
                            townVillageTractCode = this.townData[i]["code"],
                          }
                        else if (this.n2Code == 2)
                          {
                            this.n2Code = '2',
                            _townOrVillagetract = "Village Tract",
                            _villageTractList
                                .add(this.townData[i]['description']),
                            _villageTract = this.townData[i]['description'],
                            townVillageTractCode =
                                this._villageTractData[i]["code"],
                          }
                      }
                  }
                else if (this.widget.regOrAss == 'newStore')
                  {
                    if (this.townVillageTractCode == this.townData[i]['code'])
                      {
                        this.n2Code = this.townData[i]['n2'],
                        if (this.n2Code == 1)
                          {
                            this.n2Code = '1',
                            _townOrVillagetract = "Town",
                            _townList.add(this.townData[i]['description']),
                            _town = this.townData[i]['description'],
                            townVillageTractId = this.townData[i]["id"],
                          }
                        else if (this.n2Code == 2)
                          {
                            this.n2Code = '2',
                            _townOrVillagetract = "Village Tract",
                            _villageTractList
                                .add(this.townData[i]['description']),
                            _villageTract = this.townData[i]['description'],
                            townVillageTractId =
                                this._villageTractData[i]["id"],
                          }
                      }
                  }
              }
          },
        );
    var dataWard = {
      "id": "",
      "code": "",
      "description": "",
      "parentid": this.townVillageTractId,
      "n2": "1"
    };
    onlineSerives.getWard(dataWard).then(
          (value) => {
            this.wardData = value['data'],
            for (var i = 0; i < wardData.length; i++)
              {
                _wardList.add(wardData[i]["description"]),
                if (this.widget.regOrAss == "assign" ||
                    this.widget.regOrAss == "register" ||
                    this.widget.regOrAss == "assignStore")
                  {
                    if (this.wardVillageId == wardData[i]['id'])
                      {
                        this._ward = wardData[i]['description'],
                        wardVillageCode = wardData[i]["code"],
                      }
                  }
                else if (this.widget.regOrAss == "newStore")
                  {
                    if (this.wardVillageCode == wardData[i]['code'])
                      {
                        this._ward = wardData[i]['description'],
                        wardVillageId = wardData[i]["id"],
                      }
                  }
              }
          },
        );

    var dataParams = {
      "id": "",
      "code": "",
      "description": "",
      "parentid": this.townVillageTractId,
      "n2": "2"
    };
    onlineSerives.getWard(dataParams).then((value) => {
          _villageData = value['data'],
          for (var i = 0; i < _villageData.length; i++)
            {
              _villageList.add(_villageData[i]['description']),
              if (this.widget.regOrAss == "assign" ||
                  this.widget.regOrAss == "register" ||
                  this.widget.regOrAss == "assignStore")
                {
                  if (this.wardVillageId == _villageData[i]['id'])
                    {
                      this._village = _villageData[i]['description'],
                      wardVillageCode = _villageData[i]["code"],
                    }
                }
              else if (this.widget.regOrAss == "newStore")
                {
                  if (this.wardVillageCode == _villageData[i]['code'])
                    {
                      this._village = _villageData[i]['description'],
                      wardVillageId = _villageData[i]["id"],
                    }
                }
            }
        });
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
                },
            },
          );
    }
  }

  _getWard(params) {
    if (params != null) {
      onlineSerives.getWard(params).then(
            (value) => {
              wardData = value['data'],
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
      onlineSerives.getWard(params).then((value) => {
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

  var townData;
  List<String> _townList = ['-'];
  String _town = "-";

  var wardData;
  List<String> _wardList = ["-"];
  String _ward = "-";

  var _villageTractData;
  List<String> _villageTractList = ["-"];
  String _villageTract = "-";

  var _villageData;
  List<String> _villageList = ["-"];
  String _village = "-";

  var townVillageTractId = "0";
  var townVillageTractCode;
  var wardVillageId = "0";
  var wardVillageCode;

  var n2Code;
  final FocusNode streetNode = FocusNode();

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
            controller: _controller,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => GmapS(
                              lati: this.latitude,
                              long: this.longitude,
                              regass: this.widget.regOrAss,
                              passLength: this.widget.passData,
                              updateStatus: this.widget.updateStatuspass,
                              data: this.widget.passData,
                              shopkey: this.shopSyskey,
                            ),
                          ),
                        );
                        _state = "-";
                        _stateList = ["-"];
                        _districtList = [
                          "-",
                        ];
                        _district = "-";
                        _townShip = "-";
                        _townShipList = ["-"];
                        _townOrVillagetract = "-";
                        _town = "-";
                        _townList = ['-'];
                        _ward = "-";
                        _wardList = ['-'];
                        _villageTract = "-";
                        _villageTractList = ["-"];
                        _village = "-";
                        _villageList = ["-"];
                      },
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
                            Icons.person_pin_circle,
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
                                  _controller.animateTo(180.0,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease);
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
                                  _controller.animateTo(180.0,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease);
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
                                  _controller.animateTo(180.0,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease);
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
                                    _villageTract = '-';
                                    _villageTractList = ['-'];
                                    _village = '-';
                                    _villageList = ['-'];
                                    this.townVillageTractId = "0";
                                    this.wardVillageId = "0";
                                    _controller.animateTo(180.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
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
                                      if (_town == townData[i]['description']) {
                                        var params = {
                                          "id": "",
                                          "code": "",
                                          "description": "",
                                          "parentid": townData[i]["id"],
                                          "n2": "1"
                                        };
                                        townVillageTractId = townData[i]["id"];
                                        townVillageTractCode =
                                            townData[i]["code"];
                                        _ward = "-";
                                        _wardList = ['-'];
                                        _getWard(params);
                                      } else if (_town == "-") {
                                        _ward = "-";
                                        _wardList = ['-'];
                                      }
                                    }
                                    _controller.animateTo(180.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
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
                                      if (_ward == wardData[i]['description']) {
                                        wardVillageCode = wardData[i]["code"];
                                        wardVillageId = wardData[i]["id"];
                                      }
                                    }
                                    _controller.animateTo(180.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
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
                                      if (_villageTract ==
                                          _villageTractData[i]['description']) {
                                        var params = {
                                          "id": "",
                                          "code": "",
                                          "description": "",
                                          "parentid": _villageTractData[i]
                                              ["id"],
                                          "n2": "2"
                                        };
                                        townVillageTractCode =
                                            _villageTractData[i]["code"];
                                        townVillageTractId =
                                            _villageTractData[i]["id"];
                                        _village = "-";
                                        _villageList = ['-'];
                                        _getVillage(params);
                                      } else if (_villageTract == "-") {
                                        _village = "-";
                                        _villageList = ['-'];
                                      }
                                    }
                                    _controller.animateTo(180.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
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
                                      if (_village ==
                                          _villageData[i]['description']) {
                                        wardVillageCode =
                                            _villageData[i]["code"];
                                        wardVillageId = _villageData[i]["id"];
                                      }
                                    }
                                    _controller.animateTo(180.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
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
                      focusNode: streetNode,
                      controller: street,
                      onFieldSubmitted: (value) {
                        streetNode.unfocus();
                        setState(() {
                          this.street.text = value;
                        });
                      },
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
                  Container(
                    margin: EdgeInsets.all(12),
                    height: 10 * 24.0,
                    child: TextField(
                      enabled: false,
                      maxLines: 10,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText:
                            '${this.street.text != '' ? this.street.text + ',' : ''}${this._village != '-' ? this._village + ',' : ''}${this._villageTract != '-' ? this._villageTract + ',' : ''}${this._ward != '-' ? this._ward + ',' : ''}${this._town != '-' ? this._town + ',' : ''}${this._townShip != '-' ? this._townShip + ',' : ''}${this._district != '-' ? this._district + ',' : ''}${this._state != '-' ? this._state : ''}',
                        fillColor: Colors.grey[300],
                        filled: true,
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
                      print("thisCode" + this.n2Code);
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
                          // this._townOrVillagetract == null ||
                          // this._townOrVillagetract == "-" ||
                          // this._townOrVillagetract.isEmpty ||
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
                        if (this._townOrVillagetract == '-') {
                          allCode = _townShipCode;
                          allAddress = street.text +
                              "," +
                              _townShip +
                              "," +
                              _district +
                              "," +
                              _state;
                        } else if (this._townOrVillagetract == 'Town') {
                          if (this._town != '-') {
                            if (this._ward == '-') {
                              if (this.n2Code == '1') {
                                allCode = townVillageTractCode;
                                allAddress = street.text +
                                    "," +
                                    _town +
                                    "," +
                                    _townShip +
                                    "," +
                                    _district +
                                    "," +
                                    _state;
                              }
                            } else if (this._ward != '-') {
                              if (this.n2Code == '1') {
                                allCode = wardVillageCode;
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
                              }
                            }
                          } else if (this._town == '-') {
                            allCode = _townShipCode;
                            allAddress = street.text +
                                "," +
                                _townShip +
                                "," +
                                _district +
                                "," +
                                _state;
                          }
                        } else if (this._townOrVillagetract ==
                            'Village Tract') {
                          if (this._villageTract != '-') {
                            if (this._village == '-') {
                              if (this.n2Code == '2') {
                                allCode = townVillageTractCode;
                                allAddress = street.text +
                                    "," +
                                    _villageTract +
                                    "," +
                                    _townShip +
                                    "," +
                                    _district +
                                    "," +
                                    _state;
                              }
                            } else if (this._village != '-') {
                              allCode = wardVillageCode;
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
                          } else if (this._villageTract == '-') {
                            allCode = _townShipCode;
                            allAddress = street.text +
                                "," +
                                _townShip +
                                "," +
                                _district +
                                "," +
                                _state;
                          }
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
                            "townId": this.townVillageTractId,
                            "wardId": this.wardVillageId,
                            "address": this.allAddress,
                            "street": this.street.text.toString(),
                            "t12": "",
                            "svrHdrData": {
                              "syskey": "",
                              "n1": "1",
                              "n2": "",
                              "n3": ""
                            },
                            "locationData": {
                              "latitude": latitude,
                              "longitude": longitude,
                              "plusCode": this.plusCode.toString(),
                              "minuCode": this.allCode,
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
                            "townId": this.townVillageTractId,
                            "wardId": this.wardVillageId,
                            "address": this.allAddress,
                            "street": this.street.text.toString(),
                            "t12": "",
                            "svrHdrData": {
                              "syskey": "",
                              "n1": "1",
                              "n2": "",
                              "n3": ""
                            },
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

  bool _checkIfValidMarker(LatLng tap, List<LatLng> vertices, String townCode) {
    int intersectCount = 0;
    for (int j = 0; j < vertices.length - 1; j++) {
      if (rayCastIntersect(tap, vertices[j], vertices[j + 1])) {
        intersectCount++;
      }
    }

    if ("${(intersectCount % 2) == 1}" == "true") {
      this.townshipMimucode = townCode;
      print("townshipCode -->" + this.townshipMimucode);
      this.stateCode = this.townshipMimucode.toString().substring(0, 6);
      print("stateCode -->" + this.stateCode);
      print("${(intersectCount % 2) == 1}   $townCode");
      var params = {"statecode": this.stateCode};
      onlineSerives.getRegion(params).then(
            (value) => {
              if (value == true)
                {
                  print("-->>>>>>>>>>>>_-----------" +
                      this.storage.getItem("Region").toString()),
                }
            },
          );
    }

    return ((intersectCount % 2) == 1); // odd = inside, even = outside;
  }

  bool rayCastIntersect(LatLng tap, LatLng vertA, LatLng vertB) {
    double aY = vertA.latitude;
    double bY = vertB.latitude;
    double aX = vertA.longitude;
    double bX = vertB.longitude;
    double pY = tap.latitude;
    double pX = tap.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      return false; // a and b can't both be above or below pt.y, and a or
      // b must be east of pt.x
    }

    double m = (aY - bY) / (aX - bX); // Rise over run
    double bee = (-aX) * m + aY; // y = mx + b
    double x = (pY - bee) / m; // algebra is neat!

    return x > pX;
  }
}
