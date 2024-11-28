import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared/helpers/helpers.dart';
import 'package:shared/models/parking.dart';
import 'package:shared/repositories/repository_interface.dart';

class ParkingRepository implements RepositoryInterface<Parking> {

  var client = http.Client();
  final baseUrl = Helpers().baseUrl;
  final path = "/parking";

  @override
  Future<Parking?> add(Parking item) async {

    dynamic response;

    try {

      final body = item.toJson();

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
      Parking parking = Parking.fromJson(bodyAsJson);
      return parking;
    
    } else {
    
      throw Exception("Det gick inte att lägga till parkeringen");
    
    }


  }

  @override
  Future<List<Parking>?> getAll() async {

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
      var parkingList = List<Parking>.empty(growable: true);

      for(var i=0; i< bodyAsJson.length;i++) {
        final parking = Parking.fromJson(bodyAsJson[i]);
        parkingList.add(parking);
      }

      return parkingList;

    } else {

      throw Exception("Det gick inte att hämta parkeringar");

    }

  }

  @override
  Future<Parking?> getById(int id) async {
    
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
      Parking parking = Parking.fromJson(bodyAsJson);
      return parking;
    
    } else {
    
      throw Exception("Det gick inte att hämta parkeringen med id $id");
    
    }

  }

  @override
  Future<Parking?> update(int id, Parking item) async {

    
    dynamic response;

    try {

      final body = item.toJson();

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
      return Parking.fromJson(bodyAsJson);
      
    } else {

      throw Exception("DEt gick inte att uppdatera parkeringen med id $id");

    }

  }

  @override
  Future<Parking?> delete(int id) async {

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
      return Parking.fromJson(bodyAsJson);
  
    } else {

      throw Exception("Det gick inte att ta bort parkeringen med id $id");

    }

  }

}