import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

Future<Position> getCurrentLocation() async {
  var answer = await Geolocator().getCurrentPosition();
  return answer;
}

Future getLocation() async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return ;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.DENIED) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.GRANTED) {
      return;
    }
  }

   return _locationData = await location.getLocation();
  print("location -->" + _locationData.latitude.toString());
}

Future<bool> getGPSstatus() async{
  var status = await Geolocator().isLocationServiceEnabled();
  print("${status}");
  return status;
}