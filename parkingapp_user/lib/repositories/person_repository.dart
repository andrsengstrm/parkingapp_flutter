import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:shared/helpers/helpers.dart';
import 'package:shared/models/person.dart';
import 'package:shared/repositories/repository_interface.dart';

class PersonRepository implements RepositoryInterface<Person> {
  
  var client = http.Client();
  final baseUrl = "http://10.0.2.2:8080"; //Helpers().baseUrl;
  final path = "/person";

  @override
  Future<Person?> add(Person item) async {

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
      Person person = Person.fromJson(bodyAsJson);
      return person;
    
    } else {
    
      throw Exception("Det gick inte att lägga till personen");
    
    }

  }


  @override
  Future<List<Person>> getAll() async {
    
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
      var personList = List<Person>.empty(growable: true);

      for(var i=0; i< bodyAsJson.length;i++) {
        final person = Person.fromJson(bodyAsJson[i]);
        personList.add(person);
      }

      return personList;

    } else {

      throw Exception("Det gick inte att hämta personer");

    }

  }


  @override
  Future<Person> getById(int id) async {

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
      Person person = Person.fromJson(bodyAsJson);
      return person;
    
    } else {
    
      throw Exception("Det gick inte att hämta personen med id $id");
    
    }
  
  }

  Future<Person?> getByEmail(String email) async {

    dynamic response;

    try {

      response = await client.get(
        Uri.parse("$baseUrl$path/getbyemail/$email")
      );

    } catch(err) {

      throw Exception("Det gick inte att få kontakt med servern. $err");

    }
    
    if(response.statusCode == 200) {
    
      final bodyAsJson = jsonDecode(response.body);
      Person person = Person.fromJson(bodyAsJson);
      return person;
    
    } else {
    
      throw Exception("Det gick inte att hämta personen med email $email");
    
    }
  
  }


  @override
  Future<Person?> update(int id, Person item) async {
  
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
      return Person.fromJson(bodyAsJson);
      
    } else {

      throw Exception("DEt gick inte att uppdatera personen med id $id");

    }
  
  }


  @override
  Future<Person> delete(int id) async {
  
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
      return Person.fromJson(bodyAsJson);
  
    } else {

      throw Exception("Det gick inte att ta bort personen med id $id");

    }
  
  }


}