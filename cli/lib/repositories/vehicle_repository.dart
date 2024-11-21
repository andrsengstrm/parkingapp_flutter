import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared/helpers/helpers.dart';
import 'package:shared/models/vehicle.dart';
import 'package:shared/repositories/repository_interface.dart';

class VehicleRepository implements RepositoryInterface<Vehicle> {
  
  var client = http.Client();
  final baseUrl = Helpers().baseUrl;
  final path = "/vehicle";


  @override
  Future<Vehicle?> add(Vehicle item) async {

    final body = item.toJson();
    dynamic response;

    try {

      response = await client.post(
        Uri.parse("$baseUrl$path"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body)
      );

    } catch(err) {

      throw Exception("Det gick inte att få kontakt med servern. $err");

    }

    if(response.statusCode == 200) {
    
      final bodyAsJson = jsonDecode(response.body);
      Vehicle vehicle = Vehicle.fromJson(bodyAsJson);
      return vehicle;
    
    } else {
    
      throw Exception("Det gick inte att lägga till fordonet");
    
    }

  }


  @override
  Future<List<Vehicle>?> getAll() async {

    dynamic response;

    try {

      response = await client.get(
        Uri.parse("$baseUrl$path")
      );

    } catch(err) {

      throw Exception("Det gick inte att få kontakt med servern. $err");

    }

    if(response.statusCode == 200) {

      final bodyAsJson = jsonDecode(response.body);
      var vehicleList = List<Vehicle>.empty(growable: true);

      for(var i=0; i< bodyAsJson.length;i++) {
        final vehicle = Vehicle.fromJson(bodyAsJson[i]);
        vehicleList.add(vehicle);
      }

      return vehicleList;

    } else {

      throw Exception("Det gick inte att hämta fordonen");

    }


  }


  @override
  Future<Vehicle?> getById(int id) async {
    
    dynamic response;

    try {

      response = await client.get(
        Uri.parse("$baseUrl$path/$id")
      );

    } catch(err) {

      throw Exception("Det gick inte att få kontakt med servern. $err");

    }
    
    if(response.statusCode == 200) {
    
      final bodyAsJson = jsonDecode(response.body);
      Vehicle vehicle = Vehicle.fromJson(bodyAsJson);
      return vehicle;
    
    } else {
    
      throw Exception("Det gick inte att hämta forodonet med id $id");
    
    }

  }

  @override
  Future<Vehicle?> update(int id, Vehicle item) async {

    final body = item.toJson();
    dynamic response;

    try {

      response = await client.put(
        Uri.parse("$baseUrl$path/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body)
      );

    } catch(err) {

      throw Exception("Det gick inte att få kontakt med servern. $err");

    }

    if(response.statusCode == 200) {
  
      var bodyAsJson = jsonDecode(response.body);
      return Vehicle.fromJson(bodyAsJson);
      
    } else {

      throw Exception("DEt gick inte att uppdatera fordonet med id $id");

    }

  }

  @override
  Future<Vehicle?> delete(int id) async {
    
    dynamic response;

    try {

      response = await client.delete(
        Uri.parse("$baseUrl$path/$id")
      );

    } catch(err) {

      throw Exception("Det gick inte att få kontakt med servern. $err");

    }

    if(response.statusCode == 200) {
  
      var bodyAsJson = jsonDecode(response.body);
      return Vehicle.fromJson(bodyAsJson);
  
    } else {

      throw Exception("Det gick inte att ta bort fordonet med id $id");

    }
  
  }


}