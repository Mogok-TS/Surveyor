getCommonshop(data, type) {
  var commonArray = [];
  bool repeated = false;
  if(type == "assignStore"){
    for (var i = 0; i < data.length; i++) {
      repeated = false;
      for (var j = 0; j < commonArray.length; j++) {
        if (data[i]["townshipid"] == commonArray[j]["townshipid"]) {
          repeated = true;
        }
      };
      if (!repeated) {
        commonArray.add({"townshipid": data[i]["townshipid"]});
      }
    }
  }else{
    for (var i = 0; i < data.length; i++) {
      repeated = false;
      for (var j = 0; j < commonArray.length; j++) {
        if (data[i]["townshipId"] == commonArray[j]["townshipId"]) {
          repeated = true;
        }
      };
      if (!repeated) {
        commonArray.add({"townshipid": data[i]["townshipId"]});
      }
    }
  }
  return commonArray;
}

