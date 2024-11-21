import 'dart:io';
import 'package:shared/helpers/helpers.dart';
import 'package:cli/main_menu.dart' as main_menu;
import 'package:cli/vehicle_menu.dart' as vehicle_menu;
import 'package:cli/parking_space_menu.dart' as parking_space_menu;
import 'package:shared/models/parking.dart';
import 'package:cli/repositories/parking_repository.dart';
import 'package:cli/repositories/vehicle_repository.dart';
import 'package:cli/repositories/parking_space_repository.dart';
import 'package:shared/models/parking_space.dart';
import 'package:shared/models/vehicle.dart';

//show the menu for parkings
void showMenu() {
  
  //show the submenu for 'Personer'
  print("\nMeny för parkingar, välj ett alternativ:"); 
  print("1. Starta parkering");
  print("2. Avsluta parkering");
  print("3. Visa parkering");
  print("4. Visa alla parkeringar");
  print("5. Uppdatera parkering");
  print("6. Ta bort parkering");
  print("7. Gå tillbaka till huvudmenyn");
  stdout.write("\nVälj ett alternativ (1-7): ");

  //read the selected option
  readMenuSelection();

  return;

}

//read the menu selection and goto the function selected
void readMenuSelection() {
  
  //wait for input and read the selection option
  String optionSelected = stdin.readLineSync()!;

  //select action based on the selected option
  if(optionSelected == "1") { 
    
    //add parking
    startParking();
  
  } else if(optionSelected == "2") { 
    
    //end parking
    endParking();
  
  } else if(optionSelected == "3") { 
    
    //list all parkings
    getParking();
  
  } else if(optionSelected == "4") { 
    
    //list all parkings
    getAllParkings();
  
  } else if(optionSelected == "5") { 
    
    //update parkings
    updateParking();
  
  } else if(optionSelected == "6") { 
    
    //update parkings
    deleteParking();
  
  } else if(optionSelected == "7") { 

    //go back to main menu
    main_menu.showMenu();
  
  } else { 
    
    //unsupported selection
    stdout.write("\nOgiligt val! Välj ett alternativ (1-7): ");

    readMenuSelection();
  
  }

  return;
  
}

//function to start a new parking
void startParking() async {

  try {

    //set the vehicle
    var vehicle = await setVehicle();

    //set the parkingspace
    var parkingSpace = await setParkingSpace();

    //set the time to now
    String startTime = Helpers().formatDate(DateTime.now());

    //set the parking-object
    Parking newParking = Parking(vehicle: vehicle, parkingSpace: parkingSpace, startTime: startTime, endTime: "");
    await ParkingRepository().add(newParking);

    print("\nParkeringen har startats.");

  } catch(err) {

    print("\nEtt fel har uppstått: $err");

  }

  showMenu();

  return;


}

//function to end a parking
void endParking() async {

  //get all active parkings
  var parkingList = await ParkingRepository().getAll();

  if(parkingList!.where((p) => p.endTime == "" || p.endTime == null).isEmpty) {

    print("\nDet finns inga aktiva parkeringar");

    showMenu();

    return;

  }

  //print a list of parkings
  printParkingList(parkingList, true);

  stdout.write("\nAnge id för den parkeringens du vill avsluta: ");
  String selection = stdin.readLineSync()!;

  if(selection == "" || int.tryParse(selection) == null) {

    showMenu();

    return;

  }

  int id = int.parse(selection);

  try {

    //get the parking by its id
    var parking = parkingList.where((p) => p.id == id).first;
    var updatedParking = parking;
    updatedParking.endTime = Helpers().formatDate(DateTime.now());
    await ParkingRepository().update(id, updatedParking);

    print("\nParkering har avslutats.");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen parkering med id $id");

    endParking();
    
    return;

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen parkering med id $id");

    endParking();
    
    return;

  } catch(err) { 
    
    //some other error
    print("\nEtt fel har uppstått: $err"); 

  }

  showMenu();

  return;

}

//function to get a parking
void getParking() async {

  //get all parkings
  var parkingList = await ParkingRepository().getAll();

  if(parkingList!.isEmpty) {

    print("\nDet finns inga parkeringar registrerade");

    showMenu();
    
    return;

  }

  printParkingList(parkingList);

  stdout.write("\nAnge id på den parkering du vill visa (tryck enter för att avbryta): ");
  var selection = stdin.readLineSync()!;
  
  if(selection == "" || int.tryParse(selection) == null) {

    showMenu();
    
    return;

  }

  var id = int.parse(selection);

  try {

    //get the parking by its index
    var parking = parkingList.where((p) => p.id == id).first;
    print("\nId Registreringsnr Adress Starttid Sluttid Kostnad");
    print("-------------------------------");
    print(parking.printDetails);
    print("-------------------------------");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen parkering med id $id");

    getParking();

    return;

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen parkering med id $id");

    getParking();

    return;

  } catch(err) { 
    
    //some other error
    print("\nEtt fel har uppstått: $err"); 

  }

  showMenu();

  return;

}

//function to list all parkings
void getAllParkings() async {

  //get all parkings
  var parkingList = await ParkingRepository().getAll();

  if(parkingList!.isEmpty) {

    print("\nDet finns inga parkeringar registrerade");

  } else {

    printParkingList(parkingList);

  }

  showMenu();

  return;

}

//function to update a parking
void updateParking() async {

  //get all parkings, if empty we return to the menu
  var parkingList = await ParkingRepository().getAll();
  if(parkingList!.isEmpty) {

    print("\nDet finns inga parkeringar registrerade");

    showMenu();

    return;

  }

  printParkingList(parkingList);

  stdout.write("\nAnge id på den parkering du vill uppdatera (tryck enter för att avbryta): ");
  var selection = stdin.readLineSync()!;

  if(selection == "" || int.tryParse(selection) == null) { //no value provided
    
    showMenu();
  
    return;

  }

  var id = int.parse(selection);

  try {
  
    //update vehicleIs
    var vehicle = await setVehicle("\nVilket fordon är parkerat?");

    //update parkingspace
    var parkingSpace = await setParkingSpace("\nVilken parkeingsplats?");

    //set the starttime
    String startTime = setTime("Uppdatera tidpunkt för starttid");

    //set the endtime
    String endTime = setTime("Uppdatera tidpunkt för sluttid");

    //set the new parkingobject
    var newParking = Parking(id: id, vehicle: vehicle, parkingSpace: parkingSpace, startTime: startTime, endTime: endTime);

    await ParkingRepository().update(id, newParking);

    print("\nParkeringen har uppdaterats");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen parkering med id $id");

    endParking();

    return;

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen parkering med id $id");

    endParking();

    return;

  } catch(err) { 
    
    //some other error
    print("\nEtt fel har uppstått: $err"); 

  }

  showMenu();

  return;

}

//function to delete a parking
void deleteParking() async {

  //get all parkings, if empty we return to the menu
  var parkingList = await ParkingRepository().getAll();
  if(parkingList!.isEmpty) {

    print("\nDet finns inga parkeringar registrerade");

    showMenu();

    return;

  }

  printParkingList(parkingList);

  stdout.write("\nAnge id på den parkering du vill ta bort (tryck enter för att avbryta): ");
  String selection = stdin.readLineSync()!;

  if(selection == "") { //no value provided

    showMenu();
  
    return;
  
  }

  var id = int.parse(selection);

  try {

    //delete the parking
    await ParkingRepository().delete(id);
    print("\nParkeringen har tagits bort");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen parkering med index $id");

    deleteParking();

    return;

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen parkering med index $id");

    deleteParking();

    return;

  } catch(err) { 
    
    //some other error, exit function
    print("\nEtt fel har uppstått: $err");

  }

  showMenu();

  return;

}



/*---------------- subfunctions ----------------*/

//set the vehicle
Future<Vehicle> setVehicle([String message = "\nVilket fordon vill du parkera?"]) async {

  print(message);

  //list all vehicles
  var vehicleList = await VehicleRepository().getAll();
  vehicle_menu.printVehicleList(vehicleList!);

  //ask for index
  String inputVehicleIndex;
  do {
    stdout.write("Välj fordonets id: ");
    inputVehicleIndex = stdin.readLineSync()!;
  } while(inputVehicleIndex.isEmpty || int.tryParse(inputVehicleIndex) == null || int.tryParse(inputVehicleIndex)! > vehicleList.length+1);

  //select the item by index and return it
  var vehicle = await VehicleRepository().getById(int.parse(inputVehicleIndex));
  return vehicle!;

}

//set the parkingspace
Future<ParkingSpace> setParkingSpace([String message = "\nVilken perkeringsplats vill du använda?"]) async {

  print(message);

  //list all parkingspaces
  var parkingSpaceList = await ParkingSpaceRepository().getAll();
  parking_space_menu.printParkingSpaceList(parkingSpaceList!);

  //ask for index
  String inputParkingSpaceIndex;
  do {
    stdout.write("Välj parkeringsplatsens index: ");
    inputParkingSpaceIndex = stdin.readLineSync()!;
  } while(inputParkingSpaceIndex.isEmpty || int.tryParse(inputParkingSpaceIndex) == null || int.tryParse(inputParkingSpaceIndex)! > parkingSpaceList.length+1);

  //select the item by index and return it
  var parkingSpace = await ParkingSpaceRepository().getById(int.parse(inputParkingSpaceIndex));
  return parkingSpace!;

}

//set a manual time
String setTime([String message = "Välj tidpunkt"]) {

  print(message);

  String input;
  do {
    stdout.write("Fyll i datum och tid [YYYY-MM-DD HH:MM]: ");
    input = stdin.readLineSync()!;
  } while(input.isEmpty || DateTime.tryParse(input) == null);

  return DateTime.parse(input).toString();

}

//print list of parkings
void printParkingList(List<Parking> parkingList, [bool showOnlyActive = false]) {

    print("\nId Registreringsnr Adress Starttid Sluttid Kostnad");
    print("--------------------------------------------------------------");
    for(var parking in parkingList) {

      if(showOnlyActive) {

        if(parking.endTime == "" || parking.endTime == null) {
          print(parking.printDetails);
        }
      
      } else {
        
        print(parking.printDetails);
      
      }

    }
    print("--------------------------------------------------------------");

  }










