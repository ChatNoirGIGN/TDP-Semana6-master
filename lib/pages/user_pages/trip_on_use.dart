import 'package:carsharing_app/models/reservation.dart';
import 'package:carsharing_app/pages/user_pages/car_on_route.dart';
import 'package:carsharing_app/pages/user_pages/trip_on_cancel.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';
import 'package:http/http.dart' as http;

class TripOnUse extends StatefulWidget {
  final int id;
  final Position toDestination;
  const TripOnUse({Key key, this.id, this.toDestination}): super(key: key);
  @override
  _TripOnUseState createState() => _TripOnUseState();
}

class _TripOnUseState extends State<TripOnUse> {

  bool activar = false;

  ColorPalette _colorPalette = ColorPalette();

  Future<Reservation> _activate(int id) async {
    var data = await http.get("http://springbootbackendcarsharingapi103-env.eba-2nmwr2r3.us-east-1.elasticbeanstalk.com/api/reservas/$id/activate");
    if(data.statusCode == 200) {
      _createAlertOfSuccess(context, 'Viaje comenzado', 'Tenga un buen viaje');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorPalette.blue_app,
        title: Text('Buen Viaje!'),
        centerTitle: true,
      ),
      body: Container(
        color: _colorPalette.gray_app,
        padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: SwipingButton(
                    swipeButtonColor: Colors.green,
                    swipePercentageNeeded: 0.6,
                    text: "Iniciar viaje",
                    onSwipeCallback:(){
                      _activate(widget.id);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute
                            (builder: (BuildContext context) =>
                              CarOnRoute(id: widget.id, toDestination: widget.toDestination,)),
                              (Route<dynamic> route) => false);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createAlertOfSuccess(BuildContext context, String cabezera, String body) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            title: Text(cabezera, style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(body, style: TextStyle(color: _colorPalette.dark_blue_app)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Ok',
                  style: TextStyle(color: _colorPalette.green_app, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute
                    (builder: (BuildContext context) => TripOnCancel(id: widget.id)),
                          (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        }
    );
  }
}