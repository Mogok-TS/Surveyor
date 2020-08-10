import 'dart:io';
import 'dart:convert';

import 'package:Surveyor/outsideInsideNeighborhood.dart';
import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:load/load.dart';
import 'assets/custom_icons_icons.dart';
import 'package:Surveyor/Services/Online/OnlineServices.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

// ignore: must_be_immutable
class NeighborhoodSurveyScreen extends StatefulWidget {
  final bool isNeighborhood;
  final bool isOutside;
  final bool isInside;
  final bool isStoreOperater;
  final String storeName;
  final String storeNumber;
  final String address;
  final String surveyStage;
  final String surveyType;
  final String regOrAss;
  final passData;
  final question;
  final header;

  NeighborhoodSurveyScreen(
      this.isNeighborhood,
      this.isOutside,
      this.isInside,
      this.isStoreOperater,
      this.storeName,
      this.storeNumber,
      this.address,
      this.surveyStage,
      this.surveyType,
      this.regOrAss,
      this.passData,
      this.question,
      this.header);

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
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool check4 = false;
  OnlineSerives onlineSerives = new OnlineSerives();
  var questions = [];
  List imageList = [];
  var questionNature;
  bool _status = true;
  var groupId2 = "";
  var newQuestionarray = [];
  var _allData = {};
  var imageName;
  var _consoleLable = "";
  var svr9DataList = [];
  var _svr9DataListObject = {};
  var fillAnswerArray = [];

  _clickDoneAssignStore() {
    showLoadingDialog();
    var _question = this.widget.question;
    print("_question>>??" + _question.toString());
    print("allquestion>>??" + this.questions.toString());
    print("??>>" + this.widget.passData.toString());
    var pssOject = this.widget.passData[0];
    if(this.widget.regOrAss == "assign"){

    }else{

    }
    _allData["id"] = pssOject["shopsyskey"];
    _allData["active"] = true;
    _allData["name"] = pssOject["shopname"];
    _allData["mmName"] = pssOject["shopnamemm"];
    _allData["personName"] = pssOject["username"];
    _allData["personPhoneNumber"] = pssOject["personph"];
    _allData["phoneNumber"] = pssOject["phoneno"];
    _allData["stateId"] = pssOject["stateid"];
    _allData["districtId"] = pssOject["districtid"];
    _allData["townshipId"] = pssOject["townshipid"];
    _allData["townId"] = pssOject["townid"];
    _allData["wardId"] = pssOject["wardid"];
    _allData["address"] = pssOject["address"];
    _allData["street"] = pssOject["street"];
    _allData["t12"] = "";
    _allData["svrHdrData"] = {
      "n1": "1",
      "n2": pssOject["shopsyskey"].toString(),
      "n3": this.widget.header["headerSyskey"].toString()
    };
    _allData["locationData"] = {
      "latitude": pssOject["lat"],
      "longitude": pssOject["long"],
      "plusCode": pssOject["pluscode"],
      "minuCode": pssOject["mimu"]
    };
    var questionAndAnswer = [];

    for (var i = 0; i < this.questions.length; i++) {
      var loopData = this.questions[i];
      var singleQueAndAns = {};
      
      if (loopData["questionType"] == "Fill in the Blank") {
        // print("fill>>"+loopData.toString());
        var _value = {};
        _value["questionTypeId"] = loopData["n2"];
        _value["questionNatureId"] = _question["sectionSyskey"];
        _value["questionId"] = loopData["syskey"];
        _value["answerId"] = "";
        for(var pp = 0; pp < this.fillAnswerArray.length; pp++){
          if(this.fillAnswerArray[pp]["questionSyskey"] == loopData["syskey"]){
            _value["remark"] = this.fillAnswerArray[pp]["answer"];
            break;
          }
        }
        _value["desc"] = loopData["controller"];
        _value["instruction"] = loopData["t2"];
        _value["t4"] = "";
        _value["t5"] = "";
        questionAndAnswer.add(_value);
      } else if (loopData["questionType"] == "Checkbox") {
       
        for (var ii = 0; ii < loopData["answerList"].length; ii++) {
          var answerList = loopData["answerList"][ii];
          if (answerList["check"] == true) {
            var _value = {};
            _value["questionTypeId"] = loopData["n2"];
            _value["questionNatureId"] = _question["sectionSyskey"];
            _value["questionId"] = loopData["syskey"];
            _value["answerId"] = answerList["syskey"];
            _value["remark"] = "";
            _value["desc"] = answerList["t1"];
            _value["instruction"] = loopData["t2"];
            _value["t4"] = "";
            _value["t5"] = "";
            questionAndAnswer.add(_value);
          }
        }
        singleQueAndAns["questionTypeId"] = _question["sectionSyskey"];
      } else if (loopData["questionType"] == "Attach Photograph") {
        var answerList = loopData["answerList"][0];
        if (answerList["image"].length > 0) {
          for (var ii = 0; ii < answerList["image"].length; ii++) {
            var _value = {};
            _value["questionTypeId"] = loopData["n2"];
            _value["questionNatureId"] = _question["sectionSyskey"];
            _value["questionId"] = loopData["syskey"];
            _value["answerId"] = "";
            _value["remark"] = "";
            _value["desc"] = "";
            _value["instruction"] = loopData["t2"];
            _value["t4"] = "";
            _value["t5"] = "";
            for(var q = 0; q < this.imageList.length; q++){
              _svr9DataListObject["t1"] = this.imageList[q]["base64Image"];
              _svr9DataListObject["t2"] = this.imageList[q]["imageName"];
              svr9DataList.add(_svr9DataListObject);
            }
            _value["svr9DataList"] = svr9DataList;
            questionAndAnswer.add(_value);
          }
        }
      } else if (loopData["questionType"] == "Multiple Choice") {
        for (var ii = 0; ii < loopData["answerList"].length; ii++) {
          var answerList = loopData["answerList"][ii];
          if (answerList["radio"] == loopData["radio"]) {
            var _value = {};
            _value["questionTypeId"] = loopData["n2"];
            _value["questionNatureId"] = _question["sectionSyskey"];
            _value["questionId"] = loopData["syskey"];
            _value["answerId"] = answerList["syskey"];
            _value["remark"] = "";
            _value["desc"] = answerList["t1"];
            _value["instruction"] = loopData["t2"];
            _value["t4"] = "";
            _value["t5"] = "";
            questionAndAnswer.add(_value);
          }
        }
         print("multi>>"+loopData.toString());
        
      }
    }
     _allData["quesAndAns"] = questionAndAnswer;
     print("quesandans"+_allData["quesAndAns"].toString());
//    setState(() {
//      _consoleLable = _allData.toString();
//    });
    print("alldata>>" + _allData["quesAndAns"].toString());
    this.onlineSerives.createStore(_allData).then((reslut) => {
      hideLoadingDialog(),
      if (reslut["status"] == true){

      }else{
        
      }
    });
  }

  // Future getImageFromCamera(var images) async {
  //   final image = await ImagePicker.pickImage(source: ImageSource.camera);
  //   setState(() {
  //     images.add(image);
  //   });
  // }

  void newImageName() {
    var nowdate = DateTime.now();
    imageName = "${nowdate.year}" +
        "${nowdate.month}" +
        "${nowdate.day}" +
        "${nowdate.hour}" +
        "${nowdate.minute}" +
        "${nowdate.second}" +
        "${nowdate.millisecond}";
  }

  Future getImageFromCamera(var syskey, var images) async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (image.path == '') {
      } else {
        images.add(image);
        newImageName();
        imageFileList(syskey, imageName, image);
      }
    });
  }

  Future getImageFromGallery(var syskey, var images) async {
    List<File> files = await FilePicker.getMultiFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    for (var i = 0; i < files.length; i++) {
      setState(() {
        images.add(files[i]);
        newImageName();
        imageFileList(syskey, imageName, files[i]);
      });
    }
  }

  // Future getImageFromGallery(var images) async {
  //   final image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     images.add(image);
  //   });
  // }

  Future<void> imageFileList(
      var syskey, var imageName, var imageFileList) async {
    // List returnList = [];
    var result = await FlutterImageCompress.compressWithFile(
      imageFileList.path,
      minWidth: 500,
      minHeight: 500,
      quality: 50,
      rotate: 0,
    );

    String base64Image = "data:image/png;base64," + base64Encode(result);

    imageList.add({
      "syskey": "$syskey",
      "base64Image": "$base64Image",
      "imageName": "$imageName"
    });
  }

  Widget buildRadio(var answerList, var questionIndex) {
    var index = questionIndex - 1;
    return Column(
      children: <Widget>[
        for (var q = 0; q < answerList.length; q++)
          RadioListTile(
            groupValue: this.newQuestionarray[index].toString() == "syskey"
                ? this.newQuestionarray[index] =
                    answerList[q]["syskey"].toString()
                : this.newQuestionarray[index] = this.newQuestionarray[index],
            title: Text(answerList[q]["t1"].toString()),
            value: answerList[q]["syskey"].toString(),
            onChanged: (aaa) {
              setState(() {
                this.newQuestionarray[index] = aaa.toString();
              });
            },
          ),
      ],
    );
  }

  Widget attachPhotograph(String syskey, String t1, String t2, var data) {
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
                    getImageFromCamera(syskey, data[0]["image"]);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  child: Text("Library"),
                  onPressed: () {
                    getImageFromGallery(syskey, data[0]["image"]);
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

  Widget fillintheBlank(String t1, String t2, var questionData) {
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
                      onChanged: (val) {
                        var _obj = {};
                        var checkSyskey = 0;
                        var index = 0;
                        if (this.fillAnswerArray.length == 0) {
                          _obj["questionSyskey"] = questionData["syskey"];
                          _obj["answer"] = val;
                          this.fillAnswerArray.add(_obj);
                        } else {
                          for (var qe = 0;
                          qe < this.fillAnswerArray.length;
                          qe++) {
                            if (this.fillAnswerArray[qe]["questionSyskey"] ==
                                questionData["syskey"]) {
                              index = qe;
                              checkSyskey = 1;
                              break;
                            }
                          }
                          if (checkSyskey == 0) {
                            _obj["questionSyskey"] = questionData["syskey"];
                            _obj["answer"] = val;
                            this.fillAnswerArray.add(_obj);
                          } else {
                            this.fillAnswerArray[index]["answer"] = val;
                          }
                        }
                      },
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

  Widget storeImage(var image, int index, var data) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Center(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowImage(
                              image: Image(
                                image: FileImage(image),
                              ),
                            )));
              },
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
                    data.removeAt(index);
                    imageList.removeAt(index);
                  });
                },
                child: Container(
                  width: 25.0,
                  height: 25.0,
                  padding: const EdgeInsets.all(0),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image(
                    image: AssetImage('assets/close.png'),
                    color: Colors.red,
                    height: 20,
                    width: 20,
                  ),
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
    print("re>>" + this.widget.surveyType);
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
    this
        .onlineSerives
        .getQuestions(param)
        .then((result) => {
              setState(() {
                if (result["status"] == true) {
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

  Future<void> showMessageAlert(String message) async {
    double width = MediaQuery.of(context).size.width * 0.5;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0.0))),
          // title: Center(child: Text('Message')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  "$message",
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              color: Color(0xffe53935),
              child: Row(
                children: <Widget>[
                  Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              width: 10,
            ),
          ],
        );
      },
    );
  }

  Widget _allWidget(var data, var questionIndex) {
    Widget _widget;
    var answerArray;
    answerArray = data["answerList"];

    if (data["questionType"] == "Fill in the Blank") {
      _widget = fillintheBlank(data['t1'], data['t2'], data);
    }
    if (data["questionType"] == "Checkbox") {
      _widget = checkBox(data['t1'], data['t2'], data['answerList']);
    }
    if (data["questionType"] == "Attach Photograph") {
      _widget = attachPhotograph(
          data['syskey'], data['t1'], data['t2'], data["answerList"]);
    }
    if (data["questionType"] == "Multiple Choice") {
      _widget = multipleChoice(data['t1'], data['t2'], data["answerList"],
          data["radioData"], data["radio"], questionIndex);
    }
    return _widget;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: LoadingProvider(
        child: Scaffold(
          drawer: MainMenuWidget(),
          appBar: AppBar(
            backgroundColor: CustomIcons.appbarColor,
            title: Text("Questions"),
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
                                SelectableText(_consoleLable),
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
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => OutsideInsideNeighborhood(
                            this.widget.isNeighborhood,
                            this.widget.isOutside,
                            this.widget.isInside,
                            this.widget.isStoreOperater,
                            this.widget.storeName,
                            this.widget.storeNumber,
                            this.widget.address,
                            this.widget.regOrAss,
                            this.widget.passData,
                            this.widget.question,
                            this.widget.header),
                      ),
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
                    print("image data ----- " + imageList.toString());
                    if (this.widget.regOrAss == "assign") {
                      setState(() {
                        _clickDoneAssignStore();
                      });
                    } else {}
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //       builder: (context) => OutsideInsideNeighborhood(
                    //           this.widget.storeName,
                    //           this.widget.storeNumber,
                    //           this.widget.address,
                    //           this.widget.surveyType, [])),
                    // );
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
      ),
    );
  }


}

class ShowImage extends StatefulWidget {
  var image;

  ShowImage({Key key, @required this.image}) : super(key: key);

  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.image,
    );
  }
}
