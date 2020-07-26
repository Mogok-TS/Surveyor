import 'dart:io';

import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'assets/custom_icons_icons.dart';

class NeighborhoodSurveyScreen extends StatefulWidget {
  final String surveyStage;

  final String instrucions;
  NeighborhoodSurveyScreen(this.surveyStage, this.instrucions );
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
  List<Object> _images = List<Object>();
  Future getImageFromCamera() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _images.add(image);
    });
  }

  Future getImageFromGallery() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _images.add(image);
    });
  }

  Widget storeImage(File image, int index) {
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
                    _images.removeAt(index);
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
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainMenuWidget(),
        appBar: AppBar(
          
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.grey[200],
                child: Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Neighborhood Survey",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            this.widget.surveyStage,
                            style: TextStyle(color: CustomIcons.appbarColor),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          Text(
                            "Instructions",
                            style: TextStyle(),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              this.widget.instrucions,
                              style: TextStyle(color: CustomIcons.appbarColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
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
                                "Question 1 :",
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Test",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                    Container(
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
              ),
              Container(
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
                                "Question 2 :",
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Test",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                    Container(
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
                                  style:
                                      TextStyle(color: CustomIcons.appbarColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Spacer(),
                          RaisedButton(
                            child: Text("Camera"),
                            onPressed: () {
                              getImageFromCamera();
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          RaisedButton(
                            child: Text("Library"),
                            onPressed: () {
                              getImageFromGallery();
                            },
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Container(
                      child: GridView.count(
                        shrinkWrap: true,
                        controller: ScrollController(keepScrollOffset: false),
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 3,
                        children: List.generate(_images.length, (index) {
                          return storeImage(_images[index], index);
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                                "Question 3 :",
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Do you satisfied?",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: const Text('Very Satisfied'),
                          leading: Radio(
                            value: "one",
                            groupValue: "one",
                          ),
                        ),
                        ListTile(
                          title: const Text('Satisfied'),
                          leading: Radio(
                            value: "one",
                            groupValue: "Two",
                          ),
                        ),
                        ListTile(
                          title: const Text('Not Satisfied'),
                          leading: Radio(
                            value: "one",
                            groupValue: "Three",
                          ),
                        ),
                        ListTile(
                          title: const Text('Bad'),
                          leading: Radio(
                            value: "one",
                            groupValue: "Four",
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
