import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shared/models/parking_space.dart';
import 'package:server/repositories/parking_space_repository.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Response> addParkingSpace(Request request) async {

  try {

    print("Trying to add a parking space...");

    final requestBody = await request.readAsString();
    final parkingSpace = ParkingSpace.fromJson(jsonDecode(requestBody));
    final addedParkingSpace = await ParkingSpaceRepository().add(parkingSpace);

    return Response.ok(jsonEncode(addedParkingSpace));

  } catch(err) {

    return Response.internalServerError();

  }

}

Future<Response> getAllParkingSpaces(Request request) async {

  try {

    print("Trying to get all parking space...");

    final parkingSpaceList = await ParkingSpaceRepository().getAll();

    return Response.ok(jsonEncode(parkingSpaceList));

  } catch(err) {

    return Response.internalServerError();

  }

}

Future<Response> getParkingSpaceById(Request request) async {

  try {

    print("Trying to get parking space...");

    final id = request.params['id']!;
    
    final person = await ParkingSpaceRepository().getById(int.parse(id));

    return Response.ok(jsonEncode(person));
  
  } catch(err) {

    return Response.internalServerError();

  }

}

Future<Response> updateParkingSpace(Request request) async {

  try {

    print("Trying to update a parking space...");

    final id = request.params['id']!;
    final requestBody = await request.readAsString();
    final parkingSpace = ParkingSpace.fromJson(jsonDecode(requestBody));
    final updatedParkingSpace = await ParkingSpaceRepository().update(int.parse(id), parkingSpace);

    return Response.ok(jsonEncode(updatedParkingSpace));

  } catch(err) {

    return Response.internalServerError();

  }

}

Future<Response> deleteParkingSpace(Request request) async {

  try {

    print("Trying to delete a parking space...");

    final id = request.params['id']!;
    final deletedPerson = await ParkingSpaceRepository().delete(int.parse(id));

    return Response.ok(jsonEncode(deletedPerson));

  } catch(err) {

    return Response.internalServerError();

  }

}
