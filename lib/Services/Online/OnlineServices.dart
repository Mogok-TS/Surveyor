import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:Surveyor/Services/Messages/Messages.dart';

class OnlineSerives {
  final LocalStorage storage = new LocalStorage('Surveyor');
  String url;
  String overKey;
  String netWorkerr = "Can't connect right now. [005]";
  String urlErr = "Please check URL";
  String serverErr;
  String loginUserId;
  String loginUserRoles;
  bool status;

  Map<String, String> headers = {
    "Accept": "text/html,application/json",
    "Content-Type": "application/json"
  };
  Map<String, String> headersWithKey;

  void mainData() {
    this.overKey = storage.getItem("orgId");
    if (this.overKey != null) {
      this.headersWithKey = {
        "Accept": "text/html,application/json",
        "Content-Type": "application/json",
        "Content-Over": this.overKey
      };
    }
    this.URL();
  }

  void URL() {
    this.url = this.storage.getItem('URL');
    if (this.url == "" || this.url == null || this.url.isEmpty) {
      // this.url = "http://52.255.142.115:8084/mrepository_kn_svrtest/";
     // this.url = "http://52.255.142.115:8084/madbrepository/"; //For QC
     //  this.url = "http://52.255.142.115:8084/madbrepositorydev/"; // For Dev
     //  this.url = "http://18.136.44.90:8084/madbrepository/"; //For Go Live
      this.url =
          "http://52.253.88.71:8084/madbrepository/"; //For Customer_Testing
       // this.url = "http://52.255.142.115:8084/mrepository_kn_svrtest/"; //For Kaung Nyan
      this.storage.setItem('URL', "http://52.253.88.71:8084/madbrepository/");
    }
  }

  Servererror(code) {
    this.serverErr = "Server error. [" + code.toString() + "]";
    return this.serverErr;
  }

  Future<bool> loginData(param) async {
    this.mainData();
    this.url = this.url + "main/logindebug/mit";
    print("url-->" + this.url);
    var body = json.encode(param);
    var response = await http
        .post(this.url, headers: this.headers, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    print("${response.statusCode}");
    print("${response.body}");
//    if (response.statusCode == 404) {
//      ShowToast(this.urlErr);
//      this.status = false;
//    } else
    if (response != null) {
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["orgId"] != "" && data["syskey"] != "") {
          this.storage.setItem("orgId", data["orgId"]);
          this.storage.setItem("loginData", data);
          this.loginUserId = data["userId"].toString();
          this.loginUserRoles = data["loginUserRoles"].toString();
          this.status = true;
        } else {
          ShowToast("Invalid User ID or Password");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    return this.status;
  }

  Future<bool> createNewUser(data) async {
    this.mainData();
    this.url = this.url + "main/signup/mit";
    var body = json.encode(data);
    var response = await http
        .post(this.url, headers: this.headers, body: body)
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    if (response != null) {
      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["message"] == "SUCCESS") {
          ShowToast("Saved successfully.");
          this.status = true;
        } else if (data["message"] == "IDEXIST") {
          ShowToast("User already exists.");
          this.status = false;
        } else if (data["message"] == "PCEXIST") {
          ShowToast("Passcode already exists.");
          this.status = false;
        } else {
          ShowToast("Saving fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    return this.status;
  }

  Future<bool> getStores(params) async {
    print("${params}");
    this.mainData();
    this.url = this.url + "shop/getshopall";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
          this.storage.setItem("storeData", data["list"]);
          print("000-->" + data["list"].toString());
        } else {
          ShowToast("Server fail..");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    return this.status;
  }

  Future createStore(params) async {
    this.mainData();
    this.url = this.url + "shop/saveshop";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});

    if (response != null) {
      data = json.decode(response.body);
      print({"$data"});
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
          // this.storage.setItem("storeData", data["data"]);
        } else if (data["status"] == "Code Already Existed") {
          ShowToast("Code Already Existed");
          this.status = false;
        } else {
          print("Hey" + data["status"]);
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    var returnData = {"status": this.status, "data": data["data"]};
    return returnData;
  }

  Future getGooglePlusCode(params) async {
    this.mainData();
    this.url = this.url + "/geocoding/get-plus-code";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
//    print("${response.body}");
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
        } else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    var returndata = {"status": this.status, "data": data["data"]};
    return returndata;
  }

  

  Future getQuestions(params,sections) async {
    print("prams for get question>>" + params.toString());
    var returnData = {};
    var _array = [];
    var checkSaveorupdate = "save";
    this.mainData();
    this.url = this.url + "/shop/getSvrHdrShopDataListByHdrSKCatSK";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    print("123456-->");
    print("${response.body}");

    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
          var _bojArray = {};
          var dataList = data["list"];
          for (var ii = 0; ii < dataList.length; ii++) {
            var _data = dataList[ii];
            _bojArray["SectionSK"] = dataList[ii]["SectionSK"];
            _bojArray["HeaderSyskey"] = dataList[ii]["HeaderSyskey"];
            _bojArray["QuestionCode"] = dataList[ii]["QuestionCode"];
            _bojArray["QuestionSyskey"] = dataList[ii]["QuestionSyskey"];
            _bojArray["SectionDesc"] = dataList[ii]["SectionDesc"];
            _bojArray["Platform"] = dataList[ii]["Platform"];
            _bojArray["QuestionShopSyskey"] =
                dataList[ii]["QuestionShopSyskey"];
            if (dataList[ii]["Flag"] == null) {
              _bojArray["Flag"] = 0;
            } else {
              _bojArray["Flag"] = dataList[ii]["Flag"];
            }
            if (dataList[ii]["Comment"] == null) {
              _bojArray["Comment"] = "";
            } else {
              _bojArray["Comment"] = dataList[ii]["Comment"];
            }
            // if (dataList[ii]["TypeSK"].toString() == "1" ||
            //     dataList[ii]["TypeSK"].toString() == "3") {
            _bojArray["AnswerSyskey"] = "";
            _bojArray["Instruction"] = dataList[ii]["Instruction"];
            if (dataList[ii]["AnswerShopPhoto"] == null ||
                dataList[ii]["AnswerShopPhoto"].length == 0) {
              if (dataList[ii]["HeaderShopSyskey"] != null) {
                _bojArray["HeaderShopSyskey"] =
                    dataList[ii]["HeaderShopSyskey"];
              } else {
                _bojArray["HeaderShopSyskey"] = "";
              }
              _bojArray["AnswerShopPhoto"] = [];
              _bojArray["AnswerDesc"] = "";
            } else {
              checkSaveorupdate = "update";
              _bojArray["HeaderShopSyskey"] = dataList[ii]["HeaderShopSyskey"];
              _bojArray["AnswerShopPhoto"] = dataList[ii]["AnswerShopPhoto"];
              _bojArray["AnswerDesc"] = dataList[ii]["AnswerDesc"];
            }

            _bojArray["TypeSK"] = dataList[ii]["TypeSK"];
            _bojArray["TypeDesc"] = dataList[ii]["TypeDesc"];
            _bojArray["answers"] = dataList[ii]["answers"];
            _bojArray["HeaderDescription"] = dataList[ii]["HeaderDescription"];
            _bojArray["QuestionDescription"] =
                dataList[ii]["QuestionDescription"];
            _array.add(json.encode(_bojArray));
          }
          print("checkorupdate->" + checkSaveorupdate);
          // print("RES $_array");
        } else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    List aj = json.decode(_array.toString());
//    print("AA>> ${aj.length}");
//    for(var j = 0; j < aj.length;j++){
//      print("RR >>  ${aj[j]["QuestionSyskey"]}");
//    }
    returnData["status"] = this.status;
    returnData["data"] = aj;
    returnData["checkSaveorupdate"] = checkSaveorupdate;
    print("111->" +  aj[0]["HeaderShopSyskey"].toString() + "___" + sections);
    if(sections == "allsection"){
      var aa = "";
      for(var i = 0; i < aj.length; i++){
        print("123ss-->" + aj[i]["HeaderShopSyskey"].toString());
        if(aj[i]["HeaderShopSyskey"] != ""){
          aa = aj[i]["HeaderShopSyskey"].toString();
          this.storage.setItem("allsectionHeadersyskey", aa.toString());
          break;
        }else{
          aa = "";
          this.storage.setItem("allsectionHeadersyskey", aa.toString());
        }
      }
      print("sdfsdf-->" + aa.toString());
    }
    return returnData;
  }

  Future getsvrShoplist(params) async {
    print("params00->" + params.toString());
    this.mainData();
    this.url = this.url + "/shop/get-svr-shoplist";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    print("aassdd-->" + "${response.body}");
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          // this.storage.setItem("storeReg", data["list"]);
          // var aa = data["list"].length;

          this.status = true;
        } else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
//    var returndata = {"status": this.status, "data": data["list"]};
    return this.status;
  }
  Future getStateandDistrict(params) async {
    this.mainData();
    this.url = this.url + "/shop/getByTownship";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    print("--> ${response.body}");
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
//          this.storage.setItem("State", data["list"]);
        } else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    var param = {"status": this.status, "data": data["list"]};
    return param;
  }
  Future getState(params) async {
    this.mainData();
    this.url = this.url + "shop/get-state";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    print("--> ${response.body}");
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
//          this.storage.setItem("State", data["list"]);
        } else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    var param = {"status": this.status, "data": data["list"]};
    return param;
  }

  Future getDistrict(params) async {
    this.mainData();
    this.url = this.url + "shop/get-district";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
          print("district=>"  + data["list"].toString());
//          this.storage.setItem("District", data["list"]);
        } else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    var param = {"status": this.status, "data": data["list"]};
    return param;
  }

  Future getTownship(params) async {
    this.mainData();
    print("<<<<<<->>>>>> " + params["id"]);
    this.url = this.url + "shop/get-township";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    print("data123->"+ json.decode(response.body).toString());
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
//          this.storage.setItem("State", data["list"]);
        } else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    var param = {"status": this.status, "data": data["list"]};
    return param;
  }
  Future getNewStore(params) async {
    this.mainData();
    this.url = this.url + "shop/get-svr-shoplist";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});

    if (response != null) {
      data = json.decode(response.body);
      print("data-->" + data.toString());
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
          this.storage.setItem("regStore", data["list"]); //For showing Registration Store in Map
        } else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    var param = {"status": this.status, "data": data["list"]};
    return param;
  }

  Future getTown(params) async {
    this.mainData();
    this.url = this.url + "shop/get-town";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
//          this.storage.setItem("State", data["list"]);
        } else if (data["status"] == "nodata") {
          this.status = false;
        } else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    var param = {"status": this.status, "data": data["list"]};
    return param;
  }

  Future getWard(params) async {
    this.mainData();
    this.url = this.url + "shop/get-ward";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
//          this.storage.setItem("State", data["list"]);
        } else if (data["status"] == "nodata") {
          this.status = true;
        } else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    var param = {"status": this.status, "data": data["list"]};
    return param;
  }

  Future getHeaderList(params) async {

    this.mainData();
    this.url = this.url + "surveyor/allSurveyorHeaderList";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
         this.storage.setItem("HeaderList", data["list"]);
        } else if (data["status"].toString() == "No Data Record"){
          ShowToast("No data.");
          this.status = false;
        }else if (data["status"].toString() == "No Param"){
          ShowToast("No data.");
          this.status = false;
        }else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    var param = { 
      "status": this.status,
      "data": data["list"] //testData
    };
    return param;
  }

  Future getSurveyorroutebyuser(userID) async {
    this.mainData();
    this.url = this.url + "/surveyor/get-route/" + userID;
    var data;
    var response = await http
        .get(this.url, headers: this.headersWithKey)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    print("100-> ${response.body}");
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
          this.storage.setItem("Routebyuser", data["list"]);
        }else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    var param = {"status": this.status, "data": data["list"]};
    return param;
  }

  Future saveComplete(param) async {
    this.mainData();
    this.url = this.url + "shop/updateStatusRespHdr";
    var body = json.encode(param);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    print("2345-->" + this.url.toString());
    print("sss--> ${response.body}");
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
        } else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
//    var param = {
//      "status":this.status,
//      "data":data["list"]
//    };
    return this.status;
  }

  Future getCategory(params) async {
    this.mainData();
    print("paramCate-->" + params.toString());
    this.url = this.url + "surveyor/getsuvcategory";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    print("12-->" + response.body);
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
          this.storage.setItem("Category", data["list"]);
        } else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
//    var param = {
//      "status":this.status,
//      "data":data["list"]
//    };
    return this.status;
  }

  Future getRegion(params) async {
    this.mainData();
    this.url = this.url + "shop/get-region";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
          this.storage.setItem("Region", data["list"]);
        } else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }

    return this.status;
  }

  Future getSurveyor(params) async {
    print("param -> " + params.toString());
    this.mainData();
    this.url = this.url + "route/checkin";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    if (response != null) {
      data = json.decode(response.body);
      print({"Helooo+$data"});
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
          this.storage.setItem("getSurveyor", data["list"]);
          if (data["list"].length == 0) {
            this.storage.setItem("Category", []);
            print("123-->");
          }
        } else {
          ShowToast("Server fail.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    var param = {"status": this.status, "data": data["list"]};
    return param;
  }

  Future getStoretype(params) async {
    print("paramgetStoretype -> " + params.toString());
    this.mainData();
    this.url = this.url + "shop/getStoreType";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .timeout(const Duration(milliseconds: 40000))
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    if (response != null) {
      data = json.decode(response.body);
      print({"getStore--> $data"});
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
          this.storage.setItem("getStroetype", data["list"]);
        } else {
          ShowToast("Server fail for getStoreType.");
          this.status = false;
        }
      } else {
        ShowToast(this.Servererror(response.statusCode));
        this.status = false;
      }
    } else {
      ShowToast(this.netWorkerr);
      this.status = false;
    }
    var param = {"status": this.status, "data": data["list"]};
    return param;
  }
}
