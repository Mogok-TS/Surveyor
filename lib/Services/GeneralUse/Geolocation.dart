import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  var answer = await Geolocator().getCurrentPosition();
  return answer;
}

Future<bool> getGPSstatus() async{
  var status = await Geolocator().isLocationServiceEnabled();
  print("${status}");
  return status;
}