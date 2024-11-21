import 'package:shared/models/parking_space.dart';
import 'package:shared/models/person.dart';
import 'package:shared/models/vehicle.dart';
import 'package:cli/repositories/parking_space_repository.dart';
import 'package:cli/repositories/person_repository.dart';
import 'package:cli/repositories/vehicle_repository.dart';

//create some initial objects
Future<void> initData() async {
  
  Person owner = Person(personId: "7211097550", name: "Anders Emgström");
  await PersonRepository().add(owner);

  Vehicle vehicle = Vehicle(regId: "LUP767", vehicleType: "bil", owner: owner);
  await VehicleRepository().add(vehicle);

  ParkingSpace parkingSpace = ParkingSpace(address: "Paulus Parkingsgarage, Bålsta", pricePerHour: 29);
  await ParkingSpaceRepository().add(parkingSpace); 
  
}