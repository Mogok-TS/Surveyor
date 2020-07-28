import 'dart:async';
import 'dart:convert';
import 'package:Surveyor/Services/Loading/LoadingServices.dart';
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
      this.url = "http://52.255.142.115:8084/madbrepositorydev/";
      this
          .storage
          .setItem('URL', "http://52.255.142.115:8084/madbrepositorydev/");
    }
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
        if (data["status"] == "SUCCESS!") {
          this.status = true;
          this.storage.setItem("storeData", data["data"]);
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
    var returnData = {
      "status" : this.status,
      "data": data["list"]
    };
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
    this.mainData();
    this.url = this.url + "/surveyor/searchQuestionList";
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
    returnData["status"] = this.status;
     var array1 =[];

    for(var i =0;i<data["list"].length;i++){
      var listdata = data["list"][i];
      var dataarray ={};
      dataarray["syskey"] = listdata["syskey"];
      dataarray["date"] = listdata["date"];
      dataarray["t1"] = listdata["t1"];
      dataarray["t2"] = listdata["t2"];
      dataarray["t3"] = listdata["t3"];
      dataarray["n1"] = listdata["n1"];
      dataarray["n2"] = listdata["n2"];
      dataarray["n3"] = listdata["n3"];

      dataarray["questionNature"] = listdata["questionNature"];
      dataarray["questionType"] = listdata["questionType"];
      dataarray["maxRows"] = listdata["maxRows"];
      dataarray["current"] = listdata["current"];
      dataarray["ansListType"] = listdata["ansListType"];

      var answerList = [];
      var allArray = data["list"][i]["answerList"];
      var radioList = [];
      var radioListIndex =[];
      for(var ii=0;ii<allArray.length;ii++){
        var answerListData = allArray[ii];
        print("answewr>>"+answerListData.toString() );
        var objectarray ={};
        var listIndex = {};
        objectarray["syskey"] = answerListData["syskey"];
        objectarray["date"] = answerListData["date"];
        objectarray["t1"] = answerListData["t1"];
        objectarray["t2"] = answerListData["t2"];
        objectarray["t3"] = answerListData["t3"];
        objectarray["n1"] = answerListData["n1"];
        objectarray["n2"] = answerListData["n2"];
        objectarray["n3"] = answerListData["n3"];
        objectarray["imagePathForMobile"] = answerListData["imagePathForMobile"];
        objectarray["check"] = false;
        objectarray["radio"] = answerListData["syskey"];
        objectarray["image"] = [];
        objectarray["controller"] = "";
        listIndex["id"] = ii;
        listIndex["value"] = answerListData["syskey"];
        answerList.add(objectarray);
        radioList.add(answerListData["syskey"]);
        radioListIndex.add(listIndex);
      }
        dataarray["answerList"] = answerList;
        dataarray["radioValue"] = radioList;
        dataarray["radioData"] = radioListIndex;
        if(radioList.length>0){
        dataarray["radio"] = radioList[0];

        }else{
        dataarray["radio"] = [];
        }
        array1.add(dataarray);

    }
    returnData["data"] = array1;
    
    return returnData;
  }

  Future getsvrShoplist(params) async {
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

  Servererror(code) {
    this.serverErr = "Server error. [" + code + "]";
    return this.serverErr;
  }
}
