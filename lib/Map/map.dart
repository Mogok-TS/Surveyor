import 'dart:async';
import 'package:Surveyor/Services/GeneralUse/Geolocation.dart';
import 'package:Surveyor/Services/Messages/Messages.dart';
import 'package:Surveyor/stores_details.dart';
import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localstorage/localstorage.dart';

import '../stores.dart';

class GmapS extends StatefulWidget {
  double lati;
  double long;
  GmapS({Key key, @required this.lati, @required this.long}) : super(key: key);
  @override
  State<GmapS> createState() => MapSampleState();
}

class MapSampleState extends State<GmapS> {
  final LocalStorage storage = new LocalStorage('Surveyor');
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Geolocator geolocator = Geolocator();
  GoogleMapController googleMapController;

  static CameraPosition _kGooglePlex;
  var _latLong;

  void toUserLocation() {
    _getLocation().then((value) {
      setState(() {
        if (value == null) {
          print(value);
        } else {
          _getAddress(value).then((val) async {
            if (value.latitude != null && value.longitude != null) {
              final GoogleMapController controller = await _controller.future;
              this._latLong = {};
              this._latLong = {
                "lat":value.latitude,
                "long":value.longitude
              };
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

  Future<void> createNewMarker(double lati, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0.0, target: LatLng(lati, long), tilt: 0.0, zoom: 18.5)));

    final MarkerId markerId = MarkerId("1");

    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(lati, long),
        infoWindow: InfoWindow(title: "current position"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure));
    setState(() {
      markers[markerId] = marker;
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
              List addressList = [];
              List list = this.storage.getItem("storeData")["shopsByUser"];
              for (var i = 0; i < list.length; i++) {
                print(list[i]["lat"]);
                addressList.add({
                  "Name": list[i]["shopname"],
                  "lati": double.parse(list[i]["lat"]),
                  "long": double.parse(list[i]["long"])
                });
              }
              for (var i = 0; i < addressList.length; i++) {
                final MarkerId markerId = MarkerId("id is $i");

                final Marker marker = Marker(
                    markerId: markerId,
                    position:
                        LatLng(addressList[i]["lati"], addressList[i]["long"]),
                    infoWindow: InfoWindow(
                        title: addressList[i]["Name"], snippet: "Shop Name"),
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
    this._latLong = {
      "lat":widget.lati,
      "long":widget.long
    };
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.lati, widget.long),
      zoom: 10.0,
    );
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
              onTap: (latLong) {
                print("-->" + latLong.toString());
                this._latLong = {
                  "lat":latLong.latitude,
                  "long":latLong.longitude
                };
                createNewMarker(latLong.latitude, latLong.longitude);
              },
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
            onTap: () {
              getGPSstatus().then((status) => {
                print("$status"),
                if (status == true)
                  {
                    this.storage.setItem("Maplatlong", this._latLong),
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            StoresDetailsScreen([], false,"Map"),
                      ),
                    ),
                  }
                else
                  {ShowToast("Please open GPS")}
              });
            },
            child: Image(
              image: AssetImage('assets/location.png'),
              width: 50,
            ),
          ),
        ),
      ),
    );
  }
}
