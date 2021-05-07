import 'dart:io';

import 'package:carsharing_app/models/car.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';

class CarProvider {
  String _url = 'http://springbootbackendcarsharingapi103-env.eba-2nmwr2r3.us-east-1.elasticbeanstalk.com/api/autos/';

  Future<List<Car>> getCars() async {
    var data =  await http.get("$_url");
    var jsonData = json.decode(data.body);

    List<Car> cars = [];
    for(var u in jsonData) {
      Car car = Car(u["id"], u["color"], u["modelo"], u["placa"], jsonData['latitude'], jsonData['longitude']);
      cars.add(car);
    }
    return cars;
  }

  createCar(String placa, String color, String marca, String imagen) async {
    Map data = {
      'color' : color,
      'img'   : imagen.toString(),
      'modelo': marca,
      'placa' : placa
    };
    var bodyRequest = json.encode(data);
    var jsonData;
    var response = await http.post("$_url", headers: {"Content-Type": "application/json" }, body: bodyRequest);

    if(response.statusCode == 201) {
      jsonData = json.decode(response.body);
      return jsonData;
    }
  }
  Future<Car> getCar() async {
    var data = await http.get('$_url/1');
    var jsonData = json.decode(data.body);
    Car car = Car(jsonData["id"], jsonData["color"], jsonData["modelo"], jsonData["placa"], jsonData['latitude'], jsonData['longitude']);
    return car;
  }
}