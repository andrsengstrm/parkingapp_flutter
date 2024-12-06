import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shared/models/vehicle.dart';
import 'package:server/repositories/vehicle_repository.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Response> addVehicle(Request request) async {
  
  try {

    print("Trying to add a vehicle...");
    
    final requestBody = await request.readAsString();

    final vehicle = Vehicle.fromJson(jsonDecode(requestBody));
    final addedVehicle = await VehicleRepository().add(vehicle);
    
    return Response.ok(jsonEncode(addedVehicle));
  
  } catch(err) {

    print(err);
    return Response.internalServerError();

  }

}

Future<Response> getAllVehicles(Request request) async {
  
  try {
  
    print("Trying to get all vehicles...");
    
    var vehicleList = await VehicleRepository().getAll();
    
    return Response.ok(jsonEncode(vehicleList));
  
  } catch(err) {

    print(err);
    return Response.internalServerError();

  }

}

Future<Response> getVehicleById(Request request) async {

  try {
  
    print("Trying to get vehicle...");

    final id = request.params['id']!;
    final vehicle = await VehicleRepository().getById(int.parse(id));
    
    return Response.ok(jsonEncode(vehicle));

  } catch(err) {

    print(err);
    return Response.internalServerError();

  }

}

Future<Response> updateVehicle(Request request) async {

  try {
  
    print("Trying to update a vehicle...");
    
    final id = request.params['id']!;
    final requestBody = await request.readAsString();
    final vehicle = Vehicle.fromJson(jsonDecode(requestBody));
    final updatedVehicle = await VehicleRepository().update(int.parse(id), vehicle);
    
    return Response.ok(jsonEncode(updatedVehicle));

  } catch(err) {

    print(err);
    return Response.internalServerError();

  }

}

Future<Response> deleteVehicle(Request request) async {

  try {
  
    print("Trying to delete a vehicle...");
    
    final id = request.params['id']!;
    final deletedVehicle = await VehicleRepository().delete(int.parse(id));
    
    return Response.ok(jsonEncode(deletedVehicle));

  } catch(err) {

    print(err);
    return Response.internalServerError();

  }

}
