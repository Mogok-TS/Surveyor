import 'dart:io';

import 'package:Surveyor/outsideInsideNeighborhood.dart';
import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'assets/custom_icons_icons.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';

class NeighborhoodSurveyScreen extends StatefulWidget {
  final String storeName;
  final String storeNumber;
  final String address;
  final String surveyStage;
  final String surveyType;
  final String regOrAss;
  final String data;
  NeighborhoodSurveyScreen(this.storeName, this.storeNumber, this.address,
      this.surveyStage, this.surveyType,this.regOrAss,this.data);

  @override
  _NeighborhoodSurveyScreenState createState() =>
      _NeighborhoodSurveyScreenState();
}

class ImageUploadModel {
  bool isUploaded;
  bool uploading;
  File imageFile;
  String imageUrl;

  ImageUploadModel({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  });
}

class _NeighborhoodSurveyScreenState extends State<NeighborhoodSurveyScreen> {
  var _radiovalue;
  bool _isSelected;

  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool check4 = false;
  OnlineSerives onlineSerives = new OnlineSerives();
  var questions = [];
  var questionNature;
  bool _status = true;
  var groupId2 = "";
  var newQuestionarray = [];

  List<Object> _images = List<Object>();

  Future getImageFromCamera(var images) async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      images.add(image);
    });
  }

  Future getImageFromGallery(var images) async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      images.add(image);
    });
  }

  Widget buildRadio(var answerList, var questionIndex) {
//    print("${answerList}");
    print("${this.newQuestionarray}");
    var index = questionIndex - 1;
    print("${this.newQuestionarray[index]}");
//    print("${answerList[0]["syskey"].toString()}");
    return Column(
      children: <Widget>[
//        Text("$index")
        for (var q = 0; q < answerList.length; q++)
          RadioListTile(
            groupValue: this.newQuestionarray[index].toString() == "syskey" ? this.newQuestionarray[index] = answerList[q]["syskey"].toString() : this.newQuestionarray[index] = this.newQuestionarray[index],
            title: Text(answerList[q]["t1"].toString()),
            value: answerList[q]["syskey"].toString(),
            onChanged: (aaa) {
              setState(() {
                this.newQuestionarray[index] = aaa.toString();
                print("aa2->$index");
              });
            },
          ),
      ],
    );
  }

  Widget attachPhotograph(String t1, String t2, var data) {
    print("param>>>" + data.toString());
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            color: CustomIcons.dropDownHeader,
            child: ListTile(
              title: InkWell(
                onTap: () {},
                child: Row(
                  children: <Widget>[
                    Text(
                      t1,
                      style: TextStyle(color: Colors.black),
                    ),
                    if (t1 != null && t2 != null)
                      Text(
                        " :",
                        style: TextStyle(color: Colors.black),
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        t2,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {},
            ),
          ),
          Container(
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 1, 5, 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: CustomIcons.iconColor),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    padding: EdgeInsets.all(5),
                    // margin: EdgeInsets.fromLTRB(23, 20, 20, 20),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Instructions :",
                          style: TextStyle(),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "Demo Pic or text",
                            style: TextStyle(color: CustomIcons.appbarColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Container(
            color: Colors.grey[200],
            child: Row(
              children: <Widget>[
                Spacer(),
                RaisedButton(
                  child: Text("Camera"),
                  onPressed: () {
                    getImageFromCamera(data[0]["image"]);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  child: Text("Library"),
                  onPressed: () {
                    getImageFromGallery(data[0]["image"]);
                  },
                ),
                Spacer(),
              ],
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: GridView.count(
              shrinkWrap: true,
              controller: ScrollController(keepScrollOffset: false),
              scrollDirection: Axis.vertical,
              crossAxisCount: 3,
              children: List.generate(data[0]["image"].length, (index) {
                return storeImage(
                    data[0]["image"][index], index, data[0]["image"]);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget multipleChoice(String t1, String t2, var answerdata, var radioValues,
      var value, var questionIndex) {
//    this.newQuestionarray.add("syskey");
    print("${this.newQuestionarray}");
    //  print("radioValues>>"+radioValues[0]["value"]);
    // print("radioValues>>"+radioValues.toString());
    List fList = radioValues;
    String id = value;
    var groupID, groupID2;
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            color: CustomIcons.dropDownHeader,
            child: ListTile(
              title: InkWell(
                onTap: () {},
                child: Row(
                  children: <Widget>[
                    Text(
                      t1,
                      style: TextStyle(color: Colors.black),
                    ),
                    if (t1 != null && t2 != null)
                      Text(
                        " :",
                        style: TextStyle(color: Colors.black),
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        t2,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {},
            ),
          ),
          Container(
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[buildRadio(answerdata, questionIndex)],
              ))
        ],
      ),
    );
  }

  Widget checkBox(String t1, String t2, var data) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            color: CustomIcons.dropDownHeader,
            child: ListTile(
              title: InkWell(
                onTap: () {},
                child: Row(
                  children: <Widget>[
                    Text(
                      t1,
                      style: TextStyle(color: Colors.black),
                    ),
                    if (t1 != null && t2 != null)
                      Text(
                        " :",
                        style: TextStyle(color: Colors.black),
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        t2,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {},
            ),
          ),
          Container(
              color: Colors.grey[200],
              padding: EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  for (var i = 0; i < data.length; i++)
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: data[i]["check"],
                            onChanged: (bool newValue) {
                              setState(() {
                                data[i]["check"] = !data[i]["check"];
                              });
                            }),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          data[i]["t1"].toString(),
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                ],
              ))
        ],
      ),
    );
  }

  Widget fillintheBlank(String t1, String t2) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            color: CustomIcons.dropDownHeader,
            child: ListTile(
              title: InkWell(
                onTap: () {},
                child: Row(
                  children: <Widget>[
                    Text(
                      t1,
                      style: TextStyle(color: Colors.black),
                    ),
                    if (t1 != null && t2 != null)
                      Text(
                        " :",
                        style: TextStyle(color: Colors.black),
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        t2,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {},
            ),
          ),
          Container(
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    // margin: EdgeInsets.fromLTRB(23, 20, 20, 20),
                    child: TextField(
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        prefixIcon: Icon(
                          Icons.question_answer,
                          color: CustomIcons.iconColor,
                        ),
                        hintText: 'Answer',
                        hintStyle: TextStyle(fontSize: 18, height: 1.5),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget storeImage(File image, int index, var data) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Center(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Image(
                image: FileImage(image),
                height: 200,
                width: 200,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              right: 2,
              top: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _images.removeAt(data[index]);
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
    );
  }

  Widget headerBuilder(String title, String secondTitle) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: CustomIcons.dropDownHeader,
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    secondTitle,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container()
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
//    if(){} for questionNature

    if (this.widget.surveyType == "Neighborhood Survey") {
      this.questionNature = "Neighborhood Survey";
    } else if (this.widget.surveyType == "Outside of Store") {
      this.questionNature = "Outside of Store";
    } else if (this.widget.surveyType == "Inside of Store") {
      this.questionNature = "Inside of Store";
    } else if (this.widget.surveyType == "Store Operator") {
      this.questionNature = "Store Operator Information";
    }
    var param = {
      "t1": "",
      "t2": "",
      "date": "",
      "n4": 1,
      "questionNature": this.questionNature,
      "questionType": "",
      "maxRows": "",
      "current": ""
    };
//    print("${param}");
    this
        .onlineSerives
        .getQuestions(param)
        .then((result) => {
              setState(() {
                if (result["status"] == true) {
                  print(result);
                  this.questions = result["data"];
                  for (var ss = 0; ss < this.questions.length; ss++) {
                    if (this.questions[ss]["questionType"] == "Multiple Choice")
                      this.newQuestionarray.add("syskey");
                  }
                  _status = true;
                } else {
                  _status = false;
                }
              }),
            })
        .catchError((err) => {});
  }

  Widget _allWidget(var data, var questionIndex) {
    Widget _widget;
    var answerArray;
    answerArray = data["answerList"];

    if (data["questionType"] == "Fill in the Blank") {
      _widget = fillintheBlank(data['t1'], data['t2']);
    }
    if (data["questionType"] == "Checkbox") {
      _widget = checkBox(data['t1'], data['t2'], data['answerList']);
    }
    if (data["questionType"] == "Attach Photograph") {
      _widget = attachPhotograph(data['t1'], data['t2'], data["answerList"]);
    }
    if (data["questionType"] == "Multiple Choice") {
      print("${data["answerList"]}");
      _widget = multipleChoice(data['t1'], data['t2'], data["answerList"],
          data["radioData"], data["radio"], questionIndex);
    }
    return _widget;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: MainMenuWidget(),
        appBar: AppBar(
          backgroundColor: CustomIcons.appbarColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.grey[200],
                child: Container(
                  width: 700,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                this.widget.surveyType,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (this.widget.surveyType == "Store Operator")
                                Text(
                                  this.widget.storeName,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              if (this.widget.surveyType == "Store Operator")
                                SizedBox(
                                  height: 5.0,
                                ),
                              if (this.widget.surveyType == "Store Operator")
                                Text(
                                  this.widget.storeNumber,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    height: 1.0,
                                  ),
                                ),
                              if (this.widget.surveyType == "Store Operator")
                                SizedBox(
                                  height: 5.0,
                                ),
                              if (this.widget.surveyType == "Store Operator")
                                Text(
                                  this.widget.address,
                                  style: TextStyle(height: 1.3),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_status)
                if (questions.length > 0)
                  for (var i = 0; i < questions.length; i++)
                    _allWidget(questions[i], i),
              if (!_status)
                Container(
                  height: 50,
                  color: Colors.grey[300],
                  child: Center(
                    child: Text(
                      "No Data",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        bottomNavigationBar: new BottomNavigationBar(
          backgroundColor: CustomIcons.appbarColor,
          items: [
            new BottomNavigationBarItem(
              icon: new Container(),
              title: InkWell(
                onTap: () {
                  print("asdfasdfasdf");
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => OutsideInsideNeighborhood(
                            this.widget.storeName,
                            this.widget.storeNumber,
                            this.widget.address,
                            this.widget.surveyType, [])),
                  );
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
            new BottomNavigationBarItem(
              icon: new Container(),
              title: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => OutsideInsideNeighborhood(
                            this.widget.storeName,
                            this.widget.storeNumber,
                            this.widget.address,
                            this.widget.surveyType, [])),
                  );
                },
                child: Container(
                  height: 40,
                  width: 300,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Center(
                    child: new Text(
                      "Done",
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
          ],
        ),
      ),
    );
  }
}
