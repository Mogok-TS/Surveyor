import 'dart:io' as io;
import 'package:Surveyor/assets/circle_icons.dart';
import 'package:Surveyor/assets/location_icons.dart';
import 'package:Surveyor/outsideInsideNeighborhood.dart';
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

class StoresDetailsScreen extends StatefulWidget {
  var passData, updateStatuspass;
  StoresDetailsScreen(this.passData, this.updateStatuspass);

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

  var latitude, longitude, plusCode, storeRegistration;
  var createRegistration;

  @override
  void initState() {
    super.initState();
    setState(() {
      print("${this.widget.passData}");
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
        if (this.updateDataarray[0]["shopSyskey"] == null ||
            this.updateDataarray[0]["shopSyskey"] == "") {
          this.shopSyskey = this.updateDataarray[0]["id"].toString();
        } else {
          this.shopSyskey = this.updateDataarray[0]["shopSyskey"].toString();
        }
        print("shopSyskey--> $shopSyskey");
      }
    });
    showLoading();
    getCurrentLocation().then((k) {
      print({"$k"});
      latitude = k.latitude;
      longitude = k.longitude;
    });
    googlePlusparam = {"lat": latitude, "lng": longitude};
    this.onlineSerives.getGooglePlusCode(googlePlusparam).then(
          (value1) => {
            setState(() {
              this.plusCode = "${value1["data"]["plusCode"]}";
              hideLoadingDialog();
              print("${value1}");
            }),
          },
        );
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
    return LoadingProvider(
      child: Scaffold(
        backgroundColor: Color(0xFFF8F8FF),
        appBar: AppBar(
          backgroundColor: CustomIcons.appbarColor,
          title: Text("Store Detail"),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          Circle.gplus_circled,
                          color: CustomIcons.iconColor,
                          size: 25,
                        ),
                        onPressed: null,
                      ),
                      // Text(this.latitude),
                      Text(
                        "${latitude}" + "/" + "${longitude}",
                        style: TextStyle(fontSize: 16),
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
                          Location.my_location,
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
                        width: 50.0,
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
                      margin:
                          EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
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
                      margin:
                          EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
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
                      margin:
                          EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
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
                        "shopSysKey": this.shopSyskey,
                        "active": true,
                        "name": this.shopName.text.toString(),
                        "mmName": this.shopNamemm.text.toString(),
                        "personName": this.ownerName.text.toString(),
                        "phoneNumber": this.shopPhoneNo.text.toString(),
                        "stateId": "0",
                        "districtId": "0",
                        "townshipId": "0",
                        "townId": "0",
                        "wardId": "0",
                        "address": this.street.text.toString(),
                        "street": this.street.text.toString(),
                        "t12": "",
                        "locationData": {
                          "recordStatus": 1,
                          "latitude": latitude,
                          "longitude": longitude
                        }
                      };
                    } else {
                      param = {
                        "active": true,
                        "name": this.shopName.text.toString(),
                        "mmName": this.shopNamemm.text.toString(),
                        "personName": this.ownerName.text.toString(),
                        "phoneNumber": this.shopPhoneNo.text.toString(),
                        "stateId": "0",
                        "districtId": "0",
                        "townshipId": "0",
                        "townId": "0",
                        "wardId": "0",
                        "address": this.street.text.toString(),
                        "street": this.street.text.toString(),
                        "t12": "",
                        "locationData": {
                          "recordStatus": 1,
                          "latitude": latitude,
                          "longitude": longitude
                        }
                      };
                    }
                    ;
                    print("${param}");
                    this.onlineSerives.createStore(param).then((value) => {
                          print("${value["status"]}"),
                          if (value["status"] == true)
                            {
                              if (this.updateStatus == false)
                                {
                                  ShowToast("Saved successfully."),
                                }
                              else
                                {
                                  ShowToast("Updated successfully."),
                                },
                              hideLoadingDialog(),
                              setState(() {
                                this.createRegistration = value["data"];
                                print("hello" + "${value["data"]}");
                                this.updateDataarray = this.createRegistration;
                                this.shopSyskey = this
                                    .updateDataarray[0]["shopSysKey"]
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
                child: Container(
                  height: 40,
                  width: 300,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Center(
                    child: this.updateStatus == false
                        ? Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          )
                        : Text(
                            "Update",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ),
            new BottomNavigationBarItem(
              icon: new Container(),
              title: InkWell(
                onTap: () {
                  if (plusCode != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StoreData(
                            this.shopName.text,
                            this.shopNamemm.text,
                            this.shopPhoneNo.text,
                            this.ownerName.text,
                            this.ownerPhoneNo.text,
                            this.street.text,
                            this.plusCode,
                            this.widget.passData),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 40,
                  width: 300,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Center(
                    child: plusCode == null
                        ? Text(
                            "Next",
                            style:
                                TextStyle(color: Colors.white38, fontSize: 18),
                          )
                        : Text(
                            "Next",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
