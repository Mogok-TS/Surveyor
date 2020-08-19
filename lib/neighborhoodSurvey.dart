import 'dart:io';
import 'dart:convert';

import 'package:Surveyor/Services/Messages/Messages.dart';
import 'package:Surveyor/outsideInsideNeighborhood.dart';
import 'package:Surveyor/stores.dart';
import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:load/load.dart';
import 'package:localstorage/localstorage.dart';
import 'Services/Loading/LoadingServices.dart';
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
  final allsection;

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
      this.header,
      this.allsection);

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
  LocalStorage storage = new LocalStorage('Surveyor');
  List questions = [];
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
  TextEditingController _controller = new TextEditingController();
  var _primaryData = [];
  var _checkSaveorupdate;
  var url, _imageURL;

  _clickDoneAssignStore() {
    showLoading();
    var _question = this.widget.question;
    var pssOject = this.widget.passData[0];
    if (this.widget.regOrAss == "assign") {
      _allData["id"] = pssOject["shopsyskey"];
      _allData["active"] = true;
      _allData["active"] = true;
      _allData["name"] = pssOject["shopname"];
      _allData["mmName"] = pssOject["shopnamemm"];
      _allData["personName"] = pssOject["personname"];
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
      print("--->" + this.questions[0].toString());
      var _syskey = "";
      if (this._checkSaveorupdate == "update") {
        _syskey = this.questions[0]["HeaderShopSyskey"].toString();
      } else {
        _syskey = "";
      }
      _allData["svrHdrData"] = {
        "syskey": _syskey,
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
    } else {
      _allData["id"] = pssOject["id"];
      _allData["active"] = true;
      _allData["name"] = pssOject["name"];
      _allData["mmName"] = pssOject["mmName"];
      _allData["personName"] = pssOject["personName"];
      _allData["personPhoneNumber"] = pssOject["personPhoneNumber"];
      _allData["phoneNumber"] = pssOject["phoneNumber"];
      _allData["stateId"] = pssOject["stateId"];
      _allData["districtId"] = pssOject["districtId"];
      _allData["townshipId"] = pssOject["townshipId"];
      _allData["townId"] = pssOject["townId"];
      _allData["wardId"] = pssOject["wardId"];
      _allData["address"] = pssOject["address"];
      _allData["street"] = pssOject["street"];
      _allData["t12"] = "";
      var _syskey = "";
      if (this._checkSaveorupdate == "update") {
        _syskey = this.questions[0]["HeaderShopSyskey"].toString();
      } else {
        _syskey = "";
      }
      _allData["svrHdrData"] = {
        "syskey": _syskey,
        "n1": "0",
        "n2": pssOject["id"].toString(),
        "n3": this.widget.header["headerSyskey"].toString()
      };

      _allData["locationData"] = {
        "latitude": pssOject["locationData"]["latitude"],
        "longitude": pssOject["locationData"]["longitude"],
        "plusCode": pssOject["locationData"]["plusCode"],
        "minuCode": pssOject["locationData"]["minuCode"]
      };
    }
    var questionAndAnswer = [];

    for (var i = 0; i < this.questions.length; i++) {
      var loopData = this.questions[i];
      print("loop>>" + loopData.toString());
      var loopPrimary = {};
      loopPrimary = this._primaryData[i];
      var singleQueAndAns = {};

      if (loopData["TypeDesc"] == "Fill in the Blank") {
        var _value = {};
        print("fill>>" + loopData.toString());
        _value["id"] = loopData["QuestionShopSyskey"];
        _value["questionTypeId"] = loopData["TypeSK"].toString();
        _value["questionNatureId"] = _question["sectionSyskey"].toString();
        _value["questionId"] = loopData["QuestionSyskey"].toString();
        _value["answerId"] = "0";
        _value["remark"] = loopData["AnswerDesc"];
        _value["desc"] = "";
        _value["instruction"] = loopData["QuestionDescription"];
        if (loopData["Comment"] == null) {
          _value["t4"] = "";
        } else {
          _value["t4"] = loopData["Comment"];
        }
        _value["t5"] = "";
        _value["n8"] = "0";
        if (loopData["Flag"] == null) {
          _value["n9"] = "0";
        } else {
          _value["n9"] = loopData["Flag"];
        }
        if (loopData["ApprovedFlag"] == null) {
          _value["n10"] = "0";
        } else {
          _value["n10"] = loopData["ApprovedFlag"];
        }
        _value["svr9DataList"] = [];
        questionAndAnswer.add(_value);
      } else if (loopData["TypeDesc"] == "Checkbox") {
        var _value = {};
        _value["id"] = loopData["QuestionShopSyskey"];
        _value["questionTypeId"] = loopData["TypeSK"].toString();
        _value["questionNatureId"] = _question["sectionSyskey"].toString();
        _value["questionId"] = loopData["QuestionSyskey"].toString();
        _value["remark"] = "";
        _value["instruction"] = loopData["QuestionDescription"];
        if (loopData["Comment"] == null) {
          _value["t4"] = "";
        } else {
          _value["t4"] = loopData["Comment"];
        }
        _value["t5"] = "";
        _value["n8"] = "0";
        if (loopData["Flag"] == null) {
          _value["n9"] = "0";
        } else {
          _value["n9"] = loopData["Flag"];
        }
        if (loopData["ApprovedFlag"] == null) {
          _value["n10"] = "0";
        } else {
          _value["n10"] = loopData["ApprovedFlag"];
        }
        print("00--> ${loopPrimary["checkDatas"]}");
        if (loopPrimary["checkDatas"].length > 0) {
          var datalist = [];
          for (var x = 0; x < loopPrimary["checkDatas"].length; x++) {
            var data = {};
            if (loopPrimary["checkDatas"][x]["check"] == true) {
              data["recordStatus"] = 1;
              data["t1"] = "";
              data["t2"] = "";
              data["t3"] = loopPrimary["checkDatas"][x]["text"];
              data["n2"] = loopPrimary["checkDatas"][x]["syskey"];
              datalist.add(data);
            }
          }
          if (datalist.length == 0) {
            var data = {};
            data["recordStatus"] = 1;
            data["t1"] = "";
            data["t2"] = "";
            data["t3"] = "";
            data["n2"] = "";
            datalist.add(data);
          }
          _value["svr9DataList"] = datalist;
        } else {
          var datalist = [];
          var data = {};
          data["recordStatus"] = 1;
          data["t1"] = "";
          data["t2"] = "";
          data["t3"] = "";
          data["n2"] = "";
          datalist.add(data);
          _value["svr9DataList"] = datalist;
        }
        questionAndAnswer.add(_value);
        // singleQueAndAns["questionTypeId"] = _question["sectionSyskey"];
      } else if (loopData["TypeDesc"] == "Attach Photograph") {
        var _value = {};
        _value["id"] = loopData["QuestionShopSyskey"];
        _value["questionTypeId"] = loopData["TypeSK"].toString();
        _value["questionNatureId"] = _question["sectionSyskey"].toString();
        _value["questionId"] = loopData["QuestionSyskey"].toString();
        _value["answerId"] = "0";
        _value["remark"] = "";
        _value["desc"] = "";
        _value["instruction"] = loopData["QuestionDescription"];
        if (loopData["Comment"] == null) {
          _value["t4"] = "";
        } else {
          _value["t4"] = loopData["Comment"];
        }
        _value["t5"] = "";
        _value["n8"] = "0";
        if (loopData["Flag"] == null) {
          _value["n9"] = "0";
        } else {
          _value["n9"] = loopData["Flag"];
        }
        if (loopData["ApprovedFlag"] == null) {
          _value["n10"] = "0";
        } else {
          _value["n10"] = loopData["ApprovedFlag"];
        }
        if (loopPrimary["images"].length > 0) {
          var datalist = [];
          for (var x = 0; x < loopPrimary["images"].length; x++) {
            var loopObj = loopPrimary["images"][x];

            var data = {};
            data["recordStatus"] = 1;
            data["t1"] = loopObj["base64"].toString();
            data["t2"] = loopObj["name"].toString();
            data["t3"] = "";
            data["n2"] = "";
            datalist.add(data);
          }
          _value["svr9DataList"] = datalist;
          questionAndAnswer.add(_value);
        } else {
          var datalist = [];
          var data = {};
          data["recordStatus"] = 1;
          data["t1"] = "";
          data["t2"] = "";
          data["t3"] = "";
          data["n2"] = "";
          datalist.add(data);
          _value["svr9DataList"] = datalist;
          questionAndAnswer.add(_value);
        }
      } else if (loopData["TypeDesc"] == "Multiple Choice") {
        for (var ss = 0; ss < this.newQuestionarray.length; ss++) {
          if (this.newQuestionarray[ss]["questionSyskey"].toString() ==
              loopData["QuestionSyskey"].toString()) {
            var _value = {};
            _value["id"] = loopData["QuestionShopSyskey"];
            _value["questionTypeId"] = loopData["TypeSK"].toString();
            _value["questionNatureId"] = _question["sectionSyskey"].toString();
            _value["questionId"] = loopData["QuestionSyskey"].toString();
            _value["answerId"] =
                this.newQuestionarray[ss]["answerSyskey"].toString();
            _value["remark"] = "";
            _value["desc"] = this.newQuestionarray[ss]["answerDesc"].toString();
            _value["instruction"] = loopData["QuestionDescription"];
            if (loopData["Comment"] == null) {
              _value["t4"] = "";
            } else {
              _value["t4"] = loopData["Comment"];
            }
            _value["t5"] = "";
            _value["n8"] = "0";
            if (loopData["Flag"] == null) {
              _value["n9"] = "0";
            } else {
              _value["n9"] = loopData["Flag"];
            }
            if (loopData["ApprovedFlag"] == null) {
              _value["n10"] = "0";
            } else {
              _value["n10"] = loopData["ApprovedFlag"];
            }
            _value["svr9DataList"] = [];
            questionAndAnswer.add(_value);
          }
        }
      }
    }
    _allData["quesAndAns"] = questionAndAnswer;

//    setState(() {
//      _consoleLable = _allData.toString();
//      hideLoadingDialog();
//    });

    this.onlineSerives.createStore(_allData).then((reslut) => {
          hideLoadingDialog(),
          if (reslut["status"] == true)
            {
              ShowToast("Saved successfully."),
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
                      this.widget.allsection,
                      this.widget.header),
                ),
              )
            }
          else
            {}
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

  String base64String;

  Future getImageFromCamera(var syskey, var images) async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (image.path == '') {
      } else {
        newImageName();
        var datas = {};
        datas["image"] = image;
        datas["name"] = imageName;
        datas["type"] = "file";
        imageFileList(syskey, imageName, image, datas);
        images.add(datas);
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
        newImageName();
        var datas = {};
        datas["image"] = files[i];
        datas["name"] = imageName;
        datas["type"] = "file";
        imageFileList(syskey, imageName, files[i], datas);
        images.add(datas);
        // images.add(files[i]);
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
      var syskey, var imageName, var imageFileList, var datasobj) async {
    // List returnList = [];
    var result = await FlutterImageCompress.compressWithFile(
      imageFileList.path,
      minWidth: 500,
      minHeight: 500,
      quality: 50,
      rotate: 0,
    );

    String base64Image = "data:image/png;base64," + base64Encode(result);
    datasobj["base64"] = base64Image;
    imageList.add({
      "syskey": "$syskey",
      "base64Image": "$base64Image",
      "imageName": "$imageName"
    });
  }

  Future<String> convertBase64(var imagefile) async {
    var result = await FlutterImageCompress.compressWithFile(
      imagefile.path,
      minWidth: 500,
      minHeight: 500,
      quality: 50,
      rotate: 0,
    );
    String base64Image = "data:image/png;base64," + base64Encode(result);
    return base64Image;
  }

  Widget buildRadio(var answerList, var questionIndex) {
    var index = questionIndex - 1;
    // return Text(index.toString());
    return Column(
      children: <Widget>[
        for (var q = 0; q < answerList.length; q++)
          for (var ee = 0; ee < this.newQuestionarray.length; ee++)
            if (answerList[q]["questionSyskey"].toString() ==
                this.newQuestionarray[ee]["questionSyskey"].toString())
              RadioListTile(
                groupValue:
                    this.newQuestionarray[ee]["answerSyskey"].toString(),
                title: Text(answerList[q]["text"].toString()),
                value: answerList[q]["syskey"].toString(),
                onChanged: (aaa) {
                  setState(() {
                    this.newQuestionarray[ee]["answerSyskey"] = aaa.toString();
                    this.newQuestionarray[ee]["answerDesc"] =
                        answerList[q]["text"].toString();
                  });
                },
              ),
      ],
    );
  }

  Widget attachPhotograph(data, imageslist) {
    var t1 = data["QuestionCode"];
    var t2 = data["QuestionDescription"];
    var images = [];
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
                    getImageFromCamera(data["QuestionSyskey"], imageslist);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                RaisedButton(
                  child: Text("Library"),
                  onPressed: () {
                    getImageFromGallery(data["QuestionSyskey"], imageslist);
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
              children: List.generate(imageslist.length, (index) {
                return storeImage(
                    imageslist[index], index, imageslist, imageList);
              }),
            ),
          ),
          Container(),
        ],
      ),
    );
  }

  Widget multipleChoice(var t1, var t2, var data, var questionIndex) {
    print("obj>>" + data.toString());
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
                children: <Widget>[buildRadio(data, questionIndex)],
                // children: <Widget>[buildRadio(data, questionIndex)],
              ))
        ],
      ),
    );
  }

  Widget checkBox(var data, var datas) {
    var t1 = data["QuestionCode"];
    var t2 = data["QuestionDescription"];
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
                  for (var i = 0; i < datas.length; i++)
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: datas[i]["check"],
                            onChanged: (bool newValue) {
                              setState(() {
                                datas[i]["check"] = !datas[i]["check"];
                              });
                            }),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          datas[i]["text"].toString(),
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

  Widget fillintheBlank(var data) {
    print("123==> ${data}");
    var t1 = data["QuestionCode"];
    var t2 = data["QuestionDescription"];
    TextEditingController _textController = new TextEditingController();
    _textController.text = data["AnswerDesc"];
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
                      controller: _textController,
                      onChanged: (val) {
                        data["AnswerDesc"] = _textController.text;
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

  Widget storeImage(var image, int index, var data, var imageLists) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Center(
        child: Stack(
          children: <Widget>[
            GestureDetector(onTap: () {
              if (image["type"] == "online") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowImage(
                              image: Image.network(image["image"]),
                            )));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowImage(
                              image: Image(
                                image: FileImage(image["image"]),
                              ),
                            )));
              }
            }, child: Builder(builder: (context) {
              if (image["type"] == "online") {
                return Image.network(
                  image["image"],
                  height: 200,
                  width: 200,
                  fit: BoxFit.fill,
                );
              } else {
                return Image(
                  image: FileImage(image["image"]),
                  height: 200,
                  width: 200,
                  fit: BoxFit.fill,
                );
              }
            })),
            Positioned(
              right: 2,
              top: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    data.removeAt(index);
                    imageLists.removeAt(index);
//                    this.svr9DataList = [];
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
    var _pssOject;
    if (this.widget.regOrAss == "assign") {
      _pssOject = this.widget.passData[0]["shopsyskey"];
    } else {
      _pssOject = this.widget.passData[0]["id"];
    }

    this.url = this.storage.getItem('URL');

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
      "HeaderShopSyskey": "",
      "ShopTransSyskey": "",
      "SectionSyskey": this.widget.question["sectionSyskey"].toString(),
      "HeaderSyskey": this.widget.header["headerSyskey"].toString(),
      "ShopSyskey": _pssOject.toString(),
    };

//   var param = { "svrHdrSK": [ "2", "1", "3" ], "CategorySK": [ ] };
    showLoading();
    print("1234-->" + param.toString());
    this
        .onlineSerives
        .getQuestions(param)
        .then((result) => {
              setState(() {
                this._checkSaveorupdate = result["checkSaveorupdate"];
                if (result["status"] == true) {
                  hideLoadingDialog();
                  questions = result["data"];
                  print("123-->" + questions.toString());
                  for (var ss = 0; ss < questions.length; ss++) {
                    var _data = {};
                    print("2356-->" + questions[ss]["QuestionSyskey"]);
                    _data["sysKey"] = questions[ss]["QuestionSyskey"];
                    if (questions[ss]["TypeDesc"] == "Attach Photograph") {
                        var onlinePhoto = [];
                        if (questions[ss]["AnswerShopPhoto"].length > 0) {
                          for (var y = 0;
                              y < questions[ss]["AnswerShopPhoto"].length;
                              y++) {
                            var datas = {};
                            var shopPhoto = questions[ss]["AnswerShopPhoto"][y];
                            datas["image"] = shopPhoto["PhotoPath"];
                            datas["name"] = shopPhoto["PhotoName"];
                            datas["type"] = "online";
                            datas["base64"] = "";
                            onlinePhoto.add(datas);
                          }
                        }else{
                          _data["images"] = [];
                        }
                      _data["checkDatas"] = [];
                    } else if (questions[ss]["TypeDesc"] == "Checkbox") {
                      print("check>>" + this.questions[ss].toString());

                      var checkData = [];
                      for (var x = 0;
                          x < questions[ss]["answers"].length;
                          x++) {
                        var answers = questions[ss]["answers"][x];
                        var checkObj = {};
                        checkObj["text"] = answers["answerDesc"];
                        checkObj["syskey"] = answers["answerSK"];
                        checkObj["check"] = false;
                        if (questions[ss]["AnswerShopPhoto"].length > 0) {
                          for (var y = 0;
                              y < questions[ss]["AnswerShopPhoto"].length;
                              y++) {
                                var shopPhoto = questions[ss]["AnswerShopPhoto"][y];
                                if(shopPhoto["CheckBoxSyskey"] == answers["answerSK"]){
                                  checkObj["check"] = true;
                                }
                              }
                          checkData.add(checkObj);
                        }else{
                          checkData.add(checkObj);
                        }
                      }
                      _data["checkDatas"] = checkData;
                      _data["images"] = [];
                      _data["radioDatas"] = [];
                    } else if (questions[ss]["TypeDesc"] == "Multiple Choice") {
                      var answerSyskey;
                      answerSyskey = questions[ss]["AnswerSyskey"].toString();
                      print("0987654321-->" + answerSyskey);
                      var radioObj = {};
                      var radioData = [];
                      var syskeys = {};
                      syskeys["questionSyskey"] =
                          questions[ss]["QuestionSyskey"].toString();
                      for (var x = 0;
                          x < questions[ss]["answers"].length;
                          x++) {
                        var radioObj = {};
                        var getdefaultAns = questions[ss]["answers"][0];
                        var answers = questions[ss]["answers"][x];
                        radioObj["text"] = answers["answerDesc"];
                        radioObj["syskey"] = answers["answerSK"];
                        radioObj["questionSyskey"] =
                            questions[ss]["QuestionSyskey"].toString();
                        if (answerSyskey == "") {
                          syskeys["answerSyskey"] =
                              getdefaultAns["answerSK"].toString();
                          syskeys["answerDesc"] =
                              getdefaultAns["answerDesc"].toString();
                        } else {
                          syskeys["answerSyskey"] = answerSyskey.toString();
                          if (answerSyskey.toString() == answers["answerSK"].toString()) {
                            syskeys["answerSyskey"] =
                                answers["answerSK"].toString();
                            syskeys["answerDesc"] =
                                answers["answerDesc"].toString();
                          }
                        }
                        radioData.add(radioObj);
                      }

                      this.newQuestionarray.add(syskeys);
                      print("aa-->" + this.newQuestionarray.toString());
                      radioObj["qustionSyskey"] =
                          _data["radioDatas"] = radioData;
                      _data["checkDatas"] = [];
                      _data["images"] = [];
                    } else {
                      _data["checkDatas"] = [];
                      _data["images"] = [];
                    }
                    _primaryData.add(_data);
                    print("ddd--> ${_primaryData}");
                  }
                  _status = true;
                } else {
                  _status = false;
                  hideLoadingDialog();
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

  Widget _allWidget(var data, var questionIndex, var primarydata) {
    if (primarydata["images"] == null) {
      primarydata["images"] = [];
    }
    print("37--> ${data}");
    Widget _widget;

    if (data["TypeDesc"] == "Attach Photograph") {
      _widget = attachPhotograph(data, primarydata["images"]);
    } else if (data["TypeDesc"] == "Fill in the Blank") {
      _widget = fillintheBlank(data);
    } else if (data["TypeDesc"] == "Checkbox") {
      _widget = checkBox(data, primarydata["checkDatas"]);
    } else if (data["TypeDesc"] == "Multiple Choice") {
      var t1 = data["QuestionCode"];
      var t2 = data["QuestionDescription"];
      _widget =
          multipleChoice(t1, t2, primarydata["radioDatas"], questionIndex);
    } else {
      _widget = Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Text(data.toString()),
      );
    }
//     if (data["questionType"] == "Multiple Choice") {
//       _widget = multipleChoice(data['t1'], data['t2'], data["answerList"],
//           data["radioData"], data["radio"], questionIndex);
//     }
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
                      _allWidget(questions[i], i, _primaryData[i]),
                if (!_status || questions.length == 0)
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
                              this.widget.allsection,
                              this.widget.header),
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
                      print(this._status);
                      if (this._status == true && this.questions.length > 0) {
                        setState(() {
                          _clickDoneAssignStore();
                        });
                      } else {
                        showLoading();
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
                                this.widget.allsection,
                                this.widget.header),
                          ),
                        );
                      }
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Done",
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
