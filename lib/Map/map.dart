import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:Surveyor/Services/GeneralUse/Geolocation.dart';
import 'package:Surveyor/Services/Messages/Messages.dart';
import 'package:Surveyor/widgets/mainmenuwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:ui' as ui;
import '../stores.dart';
import '../stores_details.dart';

class GmapS extends StatefulWidget {
  double lati;
  double long;
  var data;
  var regass;
  var passLength;
  var updateStatus;
  GmapS(
      {Key key,
      @required this.lati,
      @required this.long,
      @required this.data,
      @required this.regass,
      @required this.passLength,
      @required this.updateStatus})
      : super(key: key);
  @override
  State<GmapS> createState() => MapSampleState();
}

class MapSampleState extends State<GmapS> {
  final LocalStorage storage = new LocalStorage('Surveyor');
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Geolocator geolocator = Geolocator();
  GoogleMapController googleMapController;
  final Set<Polygon> _polygon = {};
  static CameraPosition _kGooglePlex;
  var _latLong;
  List data;
  var check = 0;

  List polygonArray = [];

  Future<void> localJsonData() async {
    var jsonText = await rootBundle.loadString("assets/township.json");
    setState(() {
      data = json.decode(jsonText);
    });
  }

  void toUserLocation() {
    _getLocation().then((value) async {
//      setState(() {
        if (value == null) {
          print(value);
        } else {
//          _getAddress(value).then((val) async {
            if (value.latitude != null && value.longitude != null) {
              print("000--->" + this.widget.regass);
              if (this.widget.regass == "newStore" ||
                  this.widget.regass == "Map") {
                print(widget.lati.toString() + " __" + widget.long.toString());
                this._latLong = {
                  "lat": value.latitude,
                  "long": value.longitude
                };
              } else {
                this._latLong = {"lat": widget.lati, "long": widget.long};
              }
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      bearing: 0.0,
                      target:
                          LatLng(this._latLong["lat"], this._latLong["long"]),
                      tilt: 0.0,
                      zoom: 18.5)));

              final MarkerId markerId = MarkerId("1");

              final Marker marker = Marker(
                  markerId: markerId,
                  position: LatLng(this._latLong["lat"], this._latLong["long"]),
                  infoWindow: InfoWindow(title: "current position"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure));

              // for (var a = 0; a < data.length; a++) {
              //   List<LatLng> latlng = List();
              //   setState(() {
              //     latlng = [];
              //   });
              //   List list1 = data
              //       .where((element) =>
              //           element["properties"]["TS_PCODE"].toString() ==
              //           data[a]["properties"]["TS_PCODE"].toString())
              //       .toList();

              //   for (var b = 0; b < list1.length; b++) {
              //     List list2 = list1[b]["geometry"]["coordinates"];
              //     for (var c = 0; c < list2.length; c++) {
              //       for (var d = 0; d < list2[c].length; d++) {
              //         for (var e = 0; e < list2[c][d].length; e++) {
              //           double lati =
              //               double.parse(list2[c][d][e][1].toString());
              //           double long =
              //               double.parse(list2[c][d][e][0].toString());
              //           LatLng location = LatLng(lati, long);
              //           latlng.add(location);
              //         }
              //       }
              //     }
              //   }

              //   _polygon.add(Polygon(
              //       polygonId: PolygonId('area'),
              //       points: latlng,
              //       geodesic: true,
              //       strokeColor: Colors.red.withOpacity(0.6),
              //       strokeWidth: 5,
              //       fillColor: Colors.redAccent.withOpacity(0.1),
              //       visible: true));
              // }

              setState(() {
                markers[markerId] = marker;
              });
            } else {
//              print(val);
            }
//          }).catchError((error) {
//            print(error);
//          });
        }
//      });
    }).catchError((error) {
      print(error);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
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
    _getLocation().then((value) async {
//      setState(() {
        if (value == null) {
          print(value);
        } else {
//          _getAddress(value).then((val) async {
            if (value.latitude != null && value.longitude != null) {
              List addressList = [];
              // print(this.storage.getItem("storeData"));
              List list = this.storage.getItem("storeData");

              for (var i = 0; i < list.length; i++) {
                print(list[i]["lat"]);
                addressList.add({
                  "Name": list[i]["shopname"],
                  "lati": double.parse(list[i]["lat"]),
                  "long": double.parse(list[i]["long"])
                });
              }
              for (var i = 0; i < addressList.length; i++) {
                final Uint8List markerIcon =
                    await getBytesFromAsset('assets/placeholder2.png', 30);
                final MarkerId markerId = MarkerId("id is $i");

                final Marker marker = Marker(
                    markerId: markerId,
                    onTap: () {
                      print("Lati == ${addressList[i]["lati"]} / Long == ${addressList[i]["long"]}");
                      this._latLong = {
                        "lat": addressList[i]["lati"],
                        "long": addressList[i]["long"]
                      };
                    },
                    position:
                        LatLng(addressList[i]["lati"], addressList[i]["long"]),
                    infoWindow: InfoWindow(
                        title: addressList[i]["Name"]),
                    icon: BitmapDescriptor.fromBytes(markerIcon));

                for (var v = 0; v < polygonArray.length; v++) {
                  List<LatLng> latlng = List();
                  setState(() {
                    latlng = [];
                  });
                  List list1 = data
                      .where((element) =>
                          element["properties"]["TS_PCODE"].toString() ==
                          polygonArray[v]["code"].toString())
                      .toList();

                  print(list1);

                  for (var b = 0; b < list1.length; b++) {
                    List list2 = list1[b]["geometry"]["coordinates"];
                    print(list2);
                    for (var c = 0; c < list2.length; c++) {
                      for (var d = 0; d < list2[c].length; d++) {
                        for (var e = 0; e < list2[c][d].length; e++) {
                          double lati =
                              double.parse(list2[c][d][e][1].toString());
                          double long =
                              double.parse(list2[c][d][e][0].toString());
                          LatLng location = LatLng(lati, long);
                          latlng.add(location);
                        }
                      }
                    }
                  }

                  _polygon.add(Polygon(
                      polygonId: PolygonId('area$v'),
                      points: latlng,
                      geodesic: true,
                      strokeColor: Colors.red.withOpacity(0.6),
                      strokeWidth: 2,
                       fillColor: Colors.redAccent.withOpacity(0.3),
                      visible: true));
                }

                setState(() {
                  markers[markerId] = marker;
                });
              }

              List storeregi = [];
              List store = this.storage.getItem("storeReg");
              final Uint8List markerIcon =
                  await getBytesFromAsset('assets/placeholder.png', 50);
              for (var a = 0; a < store.length; a++) {
                storeregi.add({
                  "name": store[a]["mmName"],
                  "lati": double.parse(
                      store[a]["locationData"]['latitude'].toString()),
                  "long": double.parse(
                      store[a]["locationData"]['longitude'].toString())
                });
              }
              for (var i = 0; i < storeregi.length; i++) {
                final MarkerId markerId = MarkerId("storeReg is $i");

                final Marker marker = Marker(
                    markerId: markerId,
                    position:
                        LatLng(storeregi[i]["lati"], storeregi[i]["long"]),
                    infoWindow: InfoWindow(
                        title: storeregi[i]["name"]),
                    icon: BitmapDescriptor.fromBytes(markerIcon));

                setState(() {
                  markers[markerId] = marker;
                });
              }
            } else {
//              print(val);
            }
//          }).catchError((error) {
//            print(error);
//          });
        }
      });
//    }).catchError((error) {
//      print(error);
//    });
  }

  @override
  void initState() {
    super.initState();
    localJsonData();
    data = widget.data;
    locationFromServer();
    toUserLocation();
    polygonArray = this.storage.getItem("RouteMimu");
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
                if (this.widget.regass == "Map") {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => StoreScreen(),
                    ),
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => StoresDetailsScreen(
                          this.widget.passLength,
                          this.widget.updateStatus,
                          this.widget.regass),
                    ),
                  );
                }
              },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              zoomControlsEnabled: false,
              mapType: check == 0 ? MapType.normal : MapType.satellite,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: Set<Marker>.of(markers.values),
              polygons: _polygon,
              onTap: (latLong) {
                print("current" + latLong.toString());
                createNewMarker(latLong.latitude, latLong.longitude);

              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Container(
                width: 182,
                height: 150,
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
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.location_on, color: Colors.green),
                            Text("  Registration Store"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: selectPopup(),
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () {
              // getGPSstatus().then((status) => {
              //       print("$status"),
              //       if (status == true)
              //         {
              //           this.storage.setItem("Maplatlong", this._latLong),
              //           Navigator.of(context).pushReplacement(
              //             MaterialPageRoute(
              //               builder: (context) => StoresDetailsScreen(
              //                   this.widget.passLength,
              //                   this.widget.updateStatus,
              //                   this.widget.regass),
              //             ),
              //           ),
              //         }
              //       else
              //         {ShowToast("Please open GPS")}
              //     });
            },
            child: Image.asset(
              "assets/location.png",
              width: 50,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  Widget selectPopup() => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Text("Default"),
      ),
      PopupMenuItem(
        value: 2,
        child: Text("Satellite"),
      ),
    ],
    initialValue: 0,
    onCanceled: () {
      print("You have canceled the menu.");
    },
    onSelected: (value) {
      print(value);
      if (value == 2) {
        setState(() {
          check = 1;
        });
      } else {
        setState(() {
          check = 0;
        });
      }
    },
    icon: Icon(
      Icons.layers,
      color: Colors.black,
    ),
  );

  bool _checkIfValidMarker(LatLng tap, List<LatLng> vertices, String townCode) {
    int intersectCount = 0;
    for (int j = 0; j < vertices.length - 1; j++) {
      if (rayCastIntersect(tap, vertices[j], vertices[j + 1])) {
        intersectCount++;
      }
    }

    if ("${(intersectCount % 2) == 1}" == "true") {
      print("${(intersectCount % 2) == 1}   $townCode");
    }

    return ((intersectCount % 2) == 1); // odd = inside, even = outside;
  }

  bool rayCastIntersect(LatLng tap, LatLng vertA, LatLng vertB) {
    double aY = vertA.latitude;
    double bY = vertB.latitude;
    double aX = vertA.longitude;
    double bX = vertB.longitude;
    double pY = tap.latitude;
    double pX = tap.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      return false; // a and b can't both be above or below pt.y, and a or
      // b must be east of pt.x
    }

    double m = (aY - bY) / (aX - bX); // Rise over run
    double bee = (-aX) * m + aY; // y = mx + b
    double x = (pY - bee) / m; // algebra is neat!

    return x > pX;
  }
}
