import 'dart:async';
import 'dart:convert';
import 'package:Surveyor/Services/Loading/LoadingServices.dart';
import 'package:flutter/widgets.dart';
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
      this.url = "http://52.255.142.115:8084/madbrepositorydev/"; // For Dev
//      this.url = "http://52.253.88.71:8084/madbrepository/"; //For Customer_Testing
      this
          .storage
          .setItem('URL', "http://52.255.142.115:8084/madbrepositorydev/");
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
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
          this.storage.setItem("storeData", data["list"]);
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

  Future createStore(params) async {
    this.mainData();
    this.url = this.url + "shop/saveshop";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});

    if (response != null) {
      data = json.decode(response.body);
      print({"$data"});
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
          this.storage.setItem("storeData", data["data"]);
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

  Future getQuestions(params) async {
    var returnData = {};
    var _array = [];
    var checkSaveorupdate = "save";
    this.mainData();
    this.url = this.url + "/shop/getSvrHdrShopDataListByHdrSKCatSK";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    print("123456-->");
    print("${response.body}");
    var ab = "";
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
          var _bojArray = {};
          var dataList = data["list"];
          for(var ii = 0; ii < dataList.length; ii++){
            var _data = dataList[ii];
            _bojArray["SectionSK"] = dataList[ii]["SectionSK"];
            _bojArray["HeaderSyskey"] = dataList[ii]["HeaderSyskey"];
            _bojArray["QuestionCode"] = dataList[ii]["QuestionCode"];
            _bojArray["QuestionSyskey"] = dataList[ii]["QuestionSyskey"];
            _bojArray["SectionDesc"] = dataList[ii]["SectionDesc"];
            _bojArray["Platform"] = dataList[ii]["Platform"];
            _bojArray["QuestionShopSyskey"] = dataList[ii]["QuestionShopSyskey"];
            if(_data["QuestionShopSyskey"].toString() == ""){
              _bojArray["HeaderShopSyskey"] = "";
              _bojArray["AnswerShopPhoto"] = [];
              _bojArray["AnswerDesc"] = "";
            }else{
              checkSaveorupdate = "update";
              _bojArray["HeaderShopSyskey"] =dataList[ii]["HeaderShopSyskey"];
              _bojArray["AnswerShopPhoto"] = dataList[ii]["AnswerShopPhoto"];
              _bojArray["AnswerDesc"] = dataList[ii]["AnswerDesc"];
            }
            _bojArray["TypeSK"] = dataList[ii]["TypeSK"];
            _bojArray["TypeDesc"] = dataList[ii]["TypeDesc"];
            _bojArray["answers"] = dataList[ii]["answers"];
            _bojArray["HeaderDescription"] = dataList[ii]["HeaderDescription"];
            _bojArray["QuestionDescription"] = dataList[ii]["QuestionDescription"];
            _array.add(json.encode(_bojArray));
          }

          print("RES $_array");
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

    return returnData;
  }

  Future getsvrShoplist(params) async {
    print(("${params}"));
    this.mainData();
    this.url = this.url + "/shop/get-svr-shoplist";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    print("${response.body}");
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.storage.setItem("storeReg", data["list"]);
          var aa = data["list"].length;

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

  Future getState(params) async {
    this.mainData();
    this.url = this.url + "shop/get-state";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
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
    var param = {
      "status":this.status,
      "data":data["list"]
    };
    return param;
  }
  Future getDistrict(params) async {
    this.mainData();
    this.url = this.url + "shop/get-district";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
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
    var param = {
      "status":this.status,
      "data":data["list"]
    };
    return param;
  }

  Future getTownship(params) async {
    this.mainData();
    this.url = this.url + "shop/get-township";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
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
    var param = {
      "status":this.status,
      "data":data["list"]
    };
    return param;
  }

  Future getTown(params) async {
    this.mainData();
    this.url = this.url + "shop/get-town";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
//          this.storage.setItem("State", data["list"]);
        }else if(data["status"] == "nodata" ){
          this.status = false;
        }
        else {
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
      "status":this.status,
      "data":data["list"]
    };
    return param;
  }

  Future getWard(params) async {
    this.mainData();
    this.url = this.url + "shop/get-ward";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
//          this.storage.setItem("State", data["list"]);
        } else if(data["status"] == "nodata"){
          this.status = true;
        }
        else {
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
      "status":this.status,
      "data":data["list"]
    };
    return param;
  }

  Future getHeaderList(params) async {
    this.mainData();
    this.url = this.url + "surveyor/allSurveyorHeaderList";
    var body = json.encode(params);
    var data;
    var response = await http
        .post(this.url, headers: this.headersWithKey, body: body)
        .catchError((err) => {ShowToast(this.netWorkerr), this.status = false});
    if (response != null) {
      data = json.decode(response.body);
      if (response.statusCode == 200) {
        if (data["status"] == "SUCCESS") {
          this.status = true;
//          this.storage.setItem("HeaderList", data["list"]);
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
    var param = {
      "status":this.status,
      "data":data["list"]
    };
    return param;
  }
}
