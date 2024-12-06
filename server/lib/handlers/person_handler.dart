import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shared/models/person.dart';
import 'package:server/repositories/person_repository.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Response> addPerson(Request request) async {

  try {

    print("Trying to add a person...");

    final requestBody = await request.readAsString();
    final person = Person.fromJson(jsonDecode(requestBody));
    final addedPerson = await PersonRepository().add(person);

    return Response.ok(jsonEncode(addedPerson));

  } catch(err) {

    print(err);
    return Response.internalServerError();

  }
  

}

Future<Response> getAllPersons(Request request) async {

  try {

    print("Trying to get all persons...");
    
    final personList = await PersonRepository().getAll();
    
    return Response.ok(jsonEncode(personList));

  } catch(err) {

    print(err);
    return Response.internalServerError();

  }
}

Future<Response> getPersonById(Request request) async {
  
  try {

    print("Trying to get person...");
    
    final id = request.params['id']!;
    final person = await PersonRepository().getById(int.parse(id));
    
    return Response.ok(jsonEncode(person));

  } catch(err) {

    print(err);
    return Response.internalServerError();

  }

}

Future<Response> getPersonByEmail(Request request) async {
  
  try {

    print("Trying to get a person...");
    
    final email = request.params['email']!;
    final person = await PersonRepository().getByEmail(email);
    
    return Response.ok(jsonEncode(person));

  } catch(err) {

    print(err);
    return Response.internalServerError();

  }

}

Future<Response> updatePerson(Request request) async {

  try {
  
    print("Trying to update a person...");
    
    final id = request.params['id']!;
    final requestBody = await request.readAsString();
    final person = Person.fromJson(jsonDecode(requestBody));
    final updatedPerson = await PersonRepository().update(int.parse(id), person);
    
    return Response.ok(jsonEncode(updatedPerson));

  } catch(err) {

    print(err);
    return Response.internalServerError();

  }

}

Future<Response> deletePerson(Request request) async {
  
  try {
    print("Trying to delete a person...");
    
    final id = request.params['id']!;
    final deletedPerson = await PersonRepository().delete(int.parse(id));
    
    return Response.ok(jsonEncode(deletedPerson));
    
  } catch(err) {

    print(err);
    return Response.internalServerError();

  }

}
