getTodayDate() {
  var date = new DateTime.now().toString();

  var dateParse = DateTime.parse(date);
  var year,month,day;

  year = dateParse.year.toString();

  if(dateParse.month.toString().length == 1){
    month = "0"+ dateParse.month.toString();
  }else{
    month = dateParse.month.toString();
  }

  if(dateParse.day.toString().length == 1){
    day = "0" + dateParse.day.toString();
  }else{
    day = dateParse.day.toString();
  }
  var todayDate = year + month + day;

  return todayDate;
}
