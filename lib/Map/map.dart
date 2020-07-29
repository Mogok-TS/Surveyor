import 'dart:async';
import 'dart:math';

import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../stores.dart';


class Gmap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: GmapS(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GmapS extends StatefulWidget {
  @override
  State<GmapS> createState() => MapSampleState();
}

class MapSampleState extends State<GmapS> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Geolocator geolocator = Geolocator();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(21.954510, 96.093292),
    zoom: 10.0,
  );

  void toUserLocation() {
    _getLocation().then((value) {
      setState(() {
        if (value == null) {
          print(value);
        } else {
          _getAddress(value).then((val) async {
            if (value.latitude != null && value.longitude != null) {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      bearing: 0.0,
                      target: LatLng(value.latitude, value.longitude),
                      tilt: 0.0,
                      zoom: 18.5)));

              final MarkerId markerId = MarkerId("1");

              final Marker marker = Marker(
                  markerId: markerId,
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: InfoWindow(title: "current position"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure));
              setState(() {
                markers[markerId] = marker;
              });
            } else {
              print(val);
            }
          }).catchError((error) {
            print(error);
          });
        }
      });
    }).catchError((error) {
      print(error);
    });
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  Future<String> _getAddress(Position pos) async {
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      return pos.thoroughfare + ', ' + pos.locality;
    }
    return "";
  }

  void locationFromServer() {
    _getLocation().then((value) {
      setState(() {
        if (value == null) {
          print(value);
        } else {
          _getAddress(value).then((val) async {
            if (value.latitude != null && value.longitude != null) {
              List addressList = [
                {"Name": "i Mart", "lati": (value.latitude + 0.0001000), "long": (value.longitude + 0.0001000)},
                {"Name": "Queen Mart", "lati": (value.latitude + 0.0002000), "long": (value.longitude + 0.0003000)},
                {"Name": "Pyae Wa", "lati": (value.latitude + 0.0004000), "long": (value.longitude + 0.0006000)}
              ];
              for (var i = 0; i < addressList.length; i++) {
                final MarkerId markerId = MarkerId("id is $i");

                final Marker marker = Marker(
                    markerId: markerId,
                    position: LatLng(addressList[i]["lati"],
                        addressList[i]["long"]),
                    infoWindow: InfoWindow(title: addressList[i]["Name"]),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed));
                setState(() {
                  markers[markerId] = marker;
                });
              }
            } else {
              print(val);
            }
          }).catchError((error) {
            print(error);
          });
        }
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    locationFromServer();
    toUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: MainMenuWidget(),
        appBar: AppBar(
          backgroundColor: Colors.red,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.location_searching),
              onPressed: () async {
                toUserLocation();
              },
            ),
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => StoreScreen(),
                  ),
                );
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: Set<Marker>.of(markers.values),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Container(
                width: 180,
                height: 100,
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.location_on, color: Colors.blue),
                            Text("  Current Location"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.location_on, color: Colors.red),
                            Text("  Assigned Store"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () {},
            child: Image.asset("location.png", width: 50),
          ),
        ),
      ),
    );
  }
}
