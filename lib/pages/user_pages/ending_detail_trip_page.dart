import 'dart:ui';

import 'package:carsharing_app/pages/main_menus/user_home_page.dart';
import 'package:carsharing_app/providers/reservation_provider.dart';
import 'package:carsharing_app/utils/color_palette.dart';
import 'package:carsharing_app/utils/divide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EndingDetailTripPage extends StatefulWidget {
  final int id;
  const EndingDetailTripPage({Key key, this.id}): super(key: key);

  @override
  _EndingDetailTripPageState createState() => _EndingDetailTripPageState();
}

class _EndingDetailTripPageState extends State<EndingDetailTripPage> {

  ReservationProvider _provider = ReservationProvider();
  ColorPalette _colorPalette = ColorPalette();
  Dividers _dividers = Dividers();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorPalette.blue_app,
        title: Text('Detalles del viaje'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: _provider.getReservation(widget.id),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Center(child: CircularProgressIndicator());
            } else{
              double _costo = snapshot.data.costo;
              return Container(
                color: _colorPalette.gray_app,
                child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int i) {
                      return Column(
                        children: <Widget>[
                          Stack(
                            children: [

                              Padding(
                                padding: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(50.0))
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                          child: ListTile(
                                            title: Text('Direccion de Origen: ${snapshot.data.dirOrigen.toString()}',style: TextStyle(color: _colorPalette.dark_blue_app)),
                                            leading: Icon(Icons.trip_origin, color: _colorPalette.dark_blue_app),
                                          )
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                          child: ListTile(
                                            title: Text('Direccion de Destino: ${snapshot.data.dirDestino.toString()}',style: TextStyle(color: _colorPalette.dark_blue_app)),
                                            leading: Icon(Icons.trip_origin, color: _colorPalette.dark_blue_app),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _dividers.defDivider(16.0),
                          Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: _colorPalette.green_app,
                                    borderRadius: BorderRadius.all(Radius.circular(30.0))
                                ),
                                child: ListTile(
                                  title: Text('Costo: ', style: TextStyle(color: _colorPalette.dark_blue_app)),
                                  leading: Icon(Icons.trip_origin, color: _colorPalette.dark_blue_app),
                                  trailing: Text('S/.${_costo.toStringAsFixed(2)}', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
                                ),
                              )
                          ),
                          _dividers.defDivider(16.0),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(30.0))
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: ListTile(
                                    title: Text('Usted pago con ', style: TextStyle(color: _colorPalette.dark_blue_app)),
                                    leading: Icon(Icons.trip_origin, color: _colorPalette.dark_blue_app),
                                    trailing: snapshot.data.visa ? Text('Visa', style: TextStyle(color: _colorPalette.dark_blue_app,fontWeight: FontWeight.bold))
                                        : Text('Mastercard', style: TextStyle(color: _colorPalette.dark_blue_app,fontWeight: FontWeight.bold))
                                ),
                              ),
                            ),
                          ),
                          _dividers.defDivider(32.0),
                          //TODO: Sacar la foto del carro
                          Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(30.0))
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Image(
                                        image: NetworkImage('http://springbootbackendcarsharingapi103-env.eba-2nmwr2r3.us-east-1.elasticbeanstalk.com/api/autos/${snapshot.data.auto.id}/image/download'),
                                        height: 220,
                                      )
                                  ),
                                  ListTile(
                                    title: Center(child: Text('Datos de carro reservado ', style: TextStyle(color: _colorPalette.dark_blue_app, fontSize: 20.0, fontWeight: FontWeight.bold))),
                                  ),
                                  Divider(color: Colors.transparent),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: ListTile(
                                      title: Text('Placa:'),
                                      trailing: Text(' ${snapshot.data.auto.placa}'),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: ListTile(
                                      title: Text('Color:'),
                                      trailing: Text(' ${snapshot.data.auto.color}'),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: ListTile(
                                      title: Text('Marca:'),
                                      trailing: Text(' ${snapshot.data.auto.marca}'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          _dividers.defDivider(16.0),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: _colorPalette.green_app,
                              ),
                              child: Text('Aceptar', style: TextStyle(color: _colorPalette.dark_blue_app, fontWeight: FontWeight.w700)),
                              onPressed: (){
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => UserHomePage()), (Route<dynamic> route) => false);
                              },
                            ),
                          ),
                          _dividers.defDivider(16.0)
                        ],
                      );
                    }
                ),
              );
            }
          },
        ),
      ),
    );
  }
  void _createDetail(BuildContext context, AsyncSnapshot snapshot, int i) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text('Detalles del viaje'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  'assets/map.jpg',
                ),
                Divider(color: Colors.transparent),
                Text('Fecha: ${snapshot.data[i].fecha.toString()}', textAlign: TextAlign.left),
                Text('Hora: ${snapshot.data[i].hora.toString()}', textAlign: TextAlign.left),
                snapshot.data[i].visa ? Text('Metodo de pago: Visa') : Text('Metodo de pago: Mastercard'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.cyan),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
}
