import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';
import 'package:Surveyor/Services/GeneralUse/Geolocation.dart';
import 'package:Surveyor/Services/Messages/Messages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'Services/GeneralUse/PhoneNumber.dart';
import 'assets/custom_icons_icons.dart';

class StoresDetailsScreen extends StatefulWidget {
  @override
  _StoresDetailsScreenState createState() => _StoresDetailsScreenState();
}

class _StoresDetailsScreenState extends State<StoresDetailsScreen> {
  io.File _image;
  OnlineSerives onlineSerives = new OnlineSerives();
  TextEditingController shopCode = new TextEditingController();
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

  var latitude,longitude;

  @override
  void initState() {
// TODO: implement initState
    super.initState();
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

  List<String> _stateList = [
    'State',
    'ဧရာဝတီတိုင်းဒေသကြီး',
    'ပဲခူးတိုင်းဒေသကြီး',
    'ချင်းပြည်နယ်',
    'ကချင်ပြည်နယ်',
    'ကယားပြည်နယ်',
    'ကရင်ပြည်နယ်',
    'မကွေးတိုင်းဒေသကြီး',
    'မန္တလေးတိုင်းဒေသကြီး',
    'မွန်ပြည်နယ်',
    '	ရခိုင်ပြည်နယ်',
    'ရှမ်းပြည်နယ်',
    'စစ်ကိုင်းတိုင်းဒေသကြီး',
    'တနင်္သာရီတိုင်းဒေသကြီး',
    '	ရန်ကုန်တိုင်းဒေသကြီး',
    'နေပြည်တော် ပြည်ထောင်စုနယ်မြေ'
  ];
  String _state = 'State';
  List<String> _districtList = [
    'District',
    "ပုသိမ်ခရိုင်",
    "ဟင်္သာတခရိုင်",
    "မအူပင်ခရိုင်",
    "မြောင်းမြခရိုင်",
    "ဖျာပုံခရိုင်",
    "လပွတ္တာခရိုင်"
  ];
  String _district = "District";
  List<String> _townShipList = [
    'TownShip',
    'ပုသိမ်မြို့',
    'ရွှေသောင်ယံမြို့',
    'ငွေဆောင်မြို့',
  ];
  String _townShip = 'TownShip';
  List<String> _townOrVillagetractList = [
    'Town/Village Tract?',
    'Town',
    'Village',
    'Village Tract',
  ];
  String _townOrVillagetract = 'Town/Village Tract?';

  List<String> _townList = [
    'Town',
    'ကနောင်မြို့',
    'ကန်ကြီးထောင့်မြို့',
    'ကျိုက်လတ်မြို့',
    'ကျုံပျော်မြို့',
    'ကျုံမငေးမြို့',
    'ကျောင်းကုန်းမြို့',
    'ကြံခင်းမြို့',
  ];
  String _town = "Town";
  List<String> _villageOrWardList = ['Village/Ward?', 'Village', 'Ward'];
  String _villageOrWard = 'Village/Ward?';
  List<String> _wardList = ["Ward", "Ward1", "Ward2", "Ward3", "ward4"];
  String _ward = "Ward";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomIcons.appbarColor,
        title: Text("AuderBox"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: TextField(
                  controller: shopCode,
                  decoration: InputDecoration(
                    focusColor: Colors.black,
                    prefixIcon: Icon(
                      Icons.chrome_reader_mode,
                      color: CustomIcons.iconColor,
                    ),
                    hintText: 'Sp Shop Code',
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
                    margin: EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
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
                    margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
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
                    margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
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
                    margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
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
              Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 44.0),
                    margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
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
                    margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        items: _villageOrWardList.map(
                          (val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(val),
                            );
                          },
                        ).toList(),
                        value: _villageOrWard,
                        onChanged: (value) {
                          setState(() {
                            _villageOrWard = value;
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
              Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 44.0),
                    margin: EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
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
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: RaisedButton(
                  onPressed: () {
                    var param,googlePlusparam;
                    getGPSstatus().then((status) => {
                          if (status == true){
                            getCurrentLocation().then((k) {
                              latitude = k.latitude;
                              longitude = k.longitude;
                            }),
                            param = {
                              "active": true,
                              "name": this.shopName.text.toString(),
                              "mmName": this.shopNamemm.text.toString(),
                              "personName":
                              this.ownerName.text.toString(),
                              "phoneNumber":
                              this.shopPhoneNo.text.toString(),
                              "stateId": "0",
                              "districtId": "0",
                              "townshipId": "0",
                              "townId": "0",
                              "wardId": "0",
                              "address":
                              "၁, 23လမ်​း63.64ကြား, မဟာဇေယျာဘုံရပ်ကွက်, အောင်မြေသာဇံ, အောင်မြေသာစံ, မန္တလေးခရိုင်, မန္တလေးတိုင်းဒေသကြီး  ",
                              "street": this.street.text.toString(),
                              "locationData": [
                                {
                                  "recordStatus": 1,
                                  "latitude": latitude,
                                  "longitude": longitude
                                }
                              ]
                            },
                            googlePlusparam= {
                              "lat": latitude,
                              "lng": longitude
                            },
                            this.onlineSerives.getGooglePlusCode(googlePlusparam).then((value) => {print("${value}")}),
                          }
//                            {
//                              if (this.shopCode.text == "" ||
//                                  this.shopCode.text == null ||
//                                  this.shopCode.text.isEmpty ||
//                                  this.shopName.text == "" ||
//                                  this.shopName.text == null ||
//                                  this.shopName.text.isEmpty ||
//                                  this.shopNamemm.text == "" ||
//                                  this.shopNamemm.text == null ||
//                                  this.shopNamemm.text.isEmpty ||
//                                  this.shopPhoneNo.text == "" ||
//                                  this.shopPhoneNo.text == null ||
//                                  this.shopPhoneNo.text.isEmpty ||
//                                  this.ownerName.text == "" ||
//                                  this.ownerName.text == null ||
//                                  this.ownerName.text.isEmpty ||
//                                  this.ownerPhoneNo.text == "" ||
//                                  this.ownerPhoneNo.text == null ||
//                                  this.ownerPhoneNo.text.isEmpty ||
//                                  this.street.text == "" ||
//                                  this.street.text == null ||
//                                  this.street.text.isEmpty)
//                                {
//                                  ShowToast("Please fill all fields"),
//                                }
//                              else
//                                {
//                                  this.shopPhoneNo.text =
//                                      getPhoneNumber(this.shopPhoneNo.text),
//                                  this.ownerPhoneNo.text =
//                                      getPhoneNumber(this.ownerPhoneNo.text),
//                                  getCurrentLocation().then((k) {
//                                    latitude = k.latitude;
//                                    longitude = k.longitude;
//                                  }),
//                                  param = {
//                                    "active": true,
//                                    "name": this.shopName.text.toString(),
//                                    "mmName": this.shopNamemm.text.toString(),
//                                    "personName":
//                                        this.ownerName.text.toString(),
//                                    "phoneNumber":
//                                        this.shopPhoneNo.text.toString(),
//                                    "stateId": "0",
//                                    "districtId": "0",
//                                    "townshipId": "0",
//                                    "townId": "0",
//                                    "wardId": "0",
//                                    "address":
//                                        "၁, 23လမ်​း63.64ကြား, မဟာဇေယျာဘုံရပ်ကွက်, အောင်မြေသာဇံ, အောင်မြေသာစံ, မန္တလေးခရိုင်, မန္တလေးတိုင်းဒေသကြီး  ",
//                                    "street": this.street.text.toString(),
//                                    "locationData": [
//                                      {
//                                        "recordStatus": 1,
//                                        "latitude": latitude,
//                                        "longitude": longitude
//                                      }
//                                    ]
//                                  },
//                                  googlePlusparam= {
//                                    "lat": latitude,
//                                    "lng": longitude
//                                  },
//                                  this.onlineSerives.getGooglePlusCode(googlePlusparam),
//                                }
//                            }
                          else
                            {ShowToast("Please open GPS")}
                        });
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  color: CustomIcons.buttonColor,
                  textColor: CustomIcons.buttonText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
