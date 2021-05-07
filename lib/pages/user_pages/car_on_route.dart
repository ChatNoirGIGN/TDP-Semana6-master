import 'package:carsharing_app/pages/user_pages/detail_trip_page.dart';
import 'package:carsharing_app/pages/user_pages/ending_detail_trip_page.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/utils/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';
import 'package:location/location.dart' as loc;

import 'on_use_car_page.dart';
import 'dart:math';

class CarOnRoute extends StatefulWidget {
  final int id;
  final Position toDestination;
  const CarOnRoute({Key key, this.id, this.toDestination}): super(key: key);

  @override
  _CarOnRouteState createState() => _CarOnRouteState();
}

class _CarOnRouteState extends State<CarOnRoute> {

  loc.Location _location = loc.Location();
  loc.LocationData _locationData;
  double totalDistance = 0.0;

  NotificationSend _notificationSend = NotificationSend();

  CameraPosition _initialPosition = CameraPosition(target: LatLng(0.0,0.0));
  GoogleMapController mapController;
  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;

  ColorPalette _colorPalette = ColorPalette();

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  GoogleMapPolyline googleMapPolyline =  new GoogleMapPolyline(apiKey: "AIzaSyDJ1lKBGhVhPdoTduuEtBZ3Rk83Rqd1ctw");

  final Set<Polyline> polyline = {};

  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
        markers.add(Marker(markerId: MarkerId("fromPoint"), position: LatLng(_currentPosition.latitude, _currentPosition.longitude)));
        markers.add(Marker(markerId: MarkerId("toPoint"), position: LatLng(widget.toDestination.latitude, widget.toDestination.longitude)));
      });
    }).catchError((e) {
      print(e);
    });
    await _createPolylines(_currentPosition, widget.toDestination);
  }

  _createPolylines(Position start, Position destination) async {
    polylineCoordinates = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(start.latitude, start.longitude),
        destination: LatLng(destination.latitude, destination.longitude),
        mode: RouteMode.walking);
    setState(() {
      polyline.add(Polyline(polylineId: PolylineId('poly'), visible: true,  points: polylineCoordinates, width: 4, color: Colors.red));
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }


  @override
  Widget build(BuildContext context) {
    double _coordinateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }

    _location.onLocationChanged().listen((locationData) {
      _locationData = locationData;
      totalDistance = _coordinateDistance(_locationData.latitude, _locationData.longitude, _currentPosition.latitude, _currentPosition.longitude);
      if(totalDistance >= 3 ){
        _notificationSend.showNotification('Esta desviandose del a ruta', 'Usted esta tomando una ruta no asignada, por favor volver al camino.');
      }
      print("aquí");
      print(totalDistance);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorPalette.blue_app,
        title: Text('Vehículo en Ruta'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            markers: markers != null ? Set<Marker>.from(markers) : null,
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            polylines: polyline,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: SwipingButton(
                      swipeButtonColor: Colors.red,
                      swipePercentageNeeded: 0.6,
                      text: "Finalizar viaje",
                      onSwipeCallback:(){
                        return showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                title: Text("Aviso", style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text("Gracias por usar nuestro servicio", style: TextStyle(color: _colorPalette.dark_blue_app)),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(color: _colorPalette.green_app),
                                    ),
                                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => EndingDetailTripPage(id: widget.id)), (Route<dynamic> route) => true),
                                  ),
                                ],
                              );

                            }
                        );
                      }),
                ),
              ),
              Divider(color: Colors.transparent),
              Divider(color: Colors.transparent)
            ],
          ),
        ],
      ),
    );
  }
}
