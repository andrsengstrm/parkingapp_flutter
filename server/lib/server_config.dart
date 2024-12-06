import 'package:shared/objectbox.g.dart';
//import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:server/handlers/person_handler.dart' as person_handler;
import 'package:server/handlers/vehicle_handler.dart' as vehicle_handler;
import 'package:server/handlers/parking_space_handler.dart' as parking_space_handler;
import 'package:server/handlers/parking_handler.dart' as parking_handler;

class ServerConfig {

  //ServerConfig._privateConstructor() {
  //  initialize();
  //}

  //static final ServerConfig _instance = ServerConfig._privateConstructor();
  //factory ServerConfig() => _instance;
  //static ServerConfig get instance => _instance;




  static final ServerConfig _instance = ServerConfig._internal();

  //ServerConfig._internal();

  ServerConfig._internal() {
    initialize();
  }

  factory ServerConfig() => _instance;

  late Store store;

  late Router router;

  Router initialize() {

    router = Router();

    store = openStore();
    
    //person routes
    router.post('/person', person_handler.addPerson);
    router.get('/person', person_handler.getAllPersons);
    router.get('/person/<id>', person_handler.getPersonById);
    router.get('/person/getbyemail/<email>', person_handler.getPersonByEmail);
    router.put('/person/<id>', person_handler.updatePerson);
    router.delete('/person/<id>', person_handler.deletePerson);

    //vehicle routes
    router.post('/vehicle', vehicle_handler.addVehicle);
    router.get('/vehicle', vehicle_handler.getAllVehicles);
    router.get('/vehicle/<id>', vehicle_handler.getVehicleById);
    router.put('/vehicle/<id>', vehicle_handler.updateVehicle);
    router.delete('/vehicle/<id>', vehicle_handler.deleteVehicle);

    //parking space routes
    router.post('/parkingspace', parking_space_handler.addParkingSpace);
    router.get('/parkingspace', parking_space_handler.getAllParkingSpaces);
    router.get('/parkingspace/<id>', parking_space_handler.getParkingSpaceById);
    router.put('/parkingspace/<id>', parking_space_handler.updateParkingSpace);
    router.delete('/parkingspace/<id>', parking_space_handler.deleteParkingSpace);

    //parking routes
    router.post('/parking', parking_handler.addParking);
    router.get('/parking', parking_handler.getAllParkings);
    router.get('/parking/<id>', parking_handler.getParkingById);
    router.put('/parking/<id>', parking_handler.updateParking);
    router.delete('/parking/<id>', parking_handler.deleteParking);

    return router;

  }

}