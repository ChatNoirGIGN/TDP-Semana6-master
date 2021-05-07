import 'package:carsharing_app/models/car.dart';
import 'package:carsharing_app/models/reservation.dart';
import 'package:carsharing_app/models/user.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
class ReservationProvider {

  String _url = "http://springbootbackendcarsharingapi103-env.eba-2nmwr2r3.us-east-1.elasticbeanstalk.com/api/usuarios/";

  Future<List<Reservation>> getReservations(int id) async {

    var data = await http.get("$_url$id/reservas");
    var jsonData = json.decode(data.body);

    List<Reservation> reservations = [];
    for(var u in jsonData) {
      Reservation reservation = Reservation(u["id"], u["dirOrigen"], u["dirDestino"], u["costo"], u["uso"], u["mastercard"], u["visa"], u["fecha"], u["hora"],
          u["auto"] =  Car(u["auto"]["id"], u["auto"]["color"], u["auto"]["marca"], u["auto"]["placa"], u["auto"]["latitude"], u["auto"]["longitude"]),
          u["usuario"] = Usuario(u["usuario"]["id"], u["usuario"]["apellidoMaterno"], u["usuario"]["apellidoPaterno"],
              u["usuario"]["celular"], u["usuario"]["correo"], u["usuario"]["dni"], u["usuario"]["enable"], u["usuario"]["esAdm"],
              u["usuario"]["fechaNac"], u["usuario"]["nombres"], u["usuario"]["password"]));
      reservations.add(reservation);
    }
    return reservations;
  }

  Future<Reservation> getReservation(int id) async {
    var data = await http.get("http://springbootbackendcarsharingapi103-env.eba-2nmwr2r3.us-east-1.elasticbeanstalk.com/api/reservas/$id");
    var jsonData = json.decode(data.body);

    Reservation reservation = Reservation(jsonData["id"], jsonData["dirOrigen"], jsonData["dirDestino"],
        jsonData["costo"],jsonData["uso"], jsonData["mastercard"], jsonData["visa"], jsonData["fecha"], jsonData["hora"],
        jsonData["auto"] = Car(jsonData["auto"]["id"], jsonData["auto"]["color"], jsonData["auto"]["modelo"], jsonData["auto"]["placa"], jsonData["auto"]["latitude"], jsonData["auto"]["longitude"]) ,
        jsonData["usuario"] = Usuario(jsonData["usuario"]["id"], jsonData["usuario"]["apellidoMaterno"], jsonData["usuario"]["apellidoPaterno"],
            jsonData["usuario"]["celular"], jsonData["usuario"]["correo"], jsonData["usuario"]["dni"], jsonData["usuario"]["enable"], jsonData["usuario"]["esAdm"],
            jsonData["usuario"]["fechaNac"], jsonData["usuario"]["nombres"], jsonData["usuario"]["password"]));

    print(jsonData.toString());


    return reservation;
  }
}