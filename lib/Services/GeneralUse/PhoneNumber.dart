getPhoneNumber(data) {
  var phone = data.toString().substring(0, 4);
  print("data->" + phone);
  if (phone.contains("+959")) {
  } else if (phone.contains("959")) {
    data = "+" + data;
  } else if (phone.contains("09")) {
    data = "+959" + data.toString().substring(2, data.length);
  } else {
    data = "+959" + data;
  }
  return data;
}
