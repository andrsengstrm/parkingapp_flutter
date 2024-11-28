import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared/helpers/helpers.dart';
import 'package:shared/models/parking_space.dart';
import 'package:shared/repositories/repository_interface.dart';

class ParkingSpaceRepository implements RepositoryInterface<ParkingSpace> {
  
  var client = http.Client();
  final baseUrl = Helpers().baseUrl;
  final path = "/parkingspace";
  
  @override
  Future<ParkingSpace?> add(ParkingSpace item) async {
    
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
      ParkingSpace parkingSpace = ParkingSpace.fromJson(bodyAsJson);
      return parkingSpace;
    
    } else {
    
      throw Exception("Det gick inte att lägga till parkeringplatsen");
    
    }

  }


  @override
  Future<List<ParkingSpace>?> getAll() async {
    
    dynamic response;

    try {

      response = await client.get(
        Uri.parse('$baseUrl$path')
      );

    } catch(err) {

      throw Exception("Det gick inte att få kontakt med servern. $err");

    }

    if(response.statusCode == 200) {

      final bodyAsJson = jsonDecode(response.body);
      var parkingSpaceList = List<ParkingSpace>.empty(growable: true);

      for(var i=0; i< bodyAsJson.length;i++) {
        final parkingSpace = ParkingSpace.fromJson(bodyAsJson[i]);
        parkingSpaceList.add(parkingSpace);
      }

      return parkingSpaceList;

    } else {

      throw Exception("Det gick inte att hämta parkeringplatserna");

    }

  }


  @override
  Future<ParkingSpace?> getById(int id) async {
    
    dynamic response;

    try {

      response = await client.get(
        Uri.parse('$baseUrl$path/$id')
      );

    } catch(err) {

      throw Exception("Det gick inte att få kontakt med servern. $err");

    }
    
    if(response.statusCode == 200) {
    
      final bodyAsJson = jsonDecode(response.body);
      ParkingSpace parkingSpace = ParkingSpace.fromJson(bodyAsJson);
      return parkingSpace;
    
    } else {
    
      throw Exception("Det gick inte att hämta parkeringsplatsen med id $id");
    
    }

  }


  @override
  Future<ParkingSpace?> update(int id, ParkingSpace item) async {
    
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
      return ParkingSpace.fromJson(bodyAsJson);
      
    } else {

      throw Exception("Det gick inte att uppdatera parkeringsplatsen med id $id");

    }

  }


  @override
  Future<ParkingSpace?> delete(int id) async {
    
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
      return ParkingSpace.fromJson(bodyAsJson);
  
    } else {

      throw Exception("Det gick inte att ta bort parkeringsplatsen med id $id");

    }

  }


}