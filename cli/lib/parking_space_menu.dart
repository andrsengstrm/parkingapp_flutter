import 'dart:convert';
import 'dart:io';
import 'package:cli/main_menu.dart' as main_menu;
import 'package:shared/models/parking_space.dart';
import 'package:cli/repositories/parking_space_repository.dart';

void showMenu() {
  
  //show the submenu for 'Personer'
  print("\nMeny för parkingsplatser, välj ett alternativ:"); 
  print("1. Lägg till parkeringsplats");
  print("2. Visa parkeringsplats");
  print("3. Visa alla parkeringsplatser");
  print("4. Uppdatera parkeringsplats");
  print("5. Ta bort parkeringsplats");
  print("6. Gå tillbaka till huvudmenyn");
  stdout.write("\nVälj ett alternativ (1-6): ");

  //read the selected option
  readMenuSelection();

  return;

}

void readMenuSelection() {
  
  //wait for input and read the selection option
  String optionSelected = stdin.readLineSync()!;

  //select action based on the selected option
  if(optionSelected == "1") {
    
    //add parkingspace
    addParkingSpace();
  
  } else if(optionSelected == "2") { 
    
    //list parkingspace
    getParkingSpace();
  
  } else if(optionSelected == "3") { 
    
    //list all parkingspaces
    getAllParkingSpaces();
  
  } else if(optionSelected == "4") { 
    
    //update parkingspace
    updateParkingSpace();
  
  } else if(optionSelected == "5") { 
    
    //delete parkingspace
    deleteParkingSpace();
  
  } else if(optionSelected == "6") { 
    
    //go back to main menu
    main_menu.showMenu();
  
  } else { 
    
    //unsupported selection
    stdout.write("\nOgiligt val! Välj ett alternativ (1-6): ");

    readMenuSelection();
  
  }

  return;
  
}

void addParkingSpace()  async{

  //ask for the address
  String address = setAddress();

  //ask for pricePerHour
  double pricePerHour = setPricePerHour();

  try {

    //construct a ParkingSpace and add it with function from the repo
    var parkingSpace = ParkingSpace(address: address, pricePerHour: pricePerHour);
    var newParkingSpace = await ParkingSpaceRepository().add(parkingSpace);
  
    print("\nParkeringsplatsen ${newParkingSpace!.address} har lagts till.");

  } catch(err) {

    print("\nEtt fel har uppstått: $err");

  }
  
  showMenu();

  return;

}

void getParkingSpace() async {

  var parkingSpaceList = await ParkingSpaceRepository().getAll();

  if(parkingSpaceList!.isEmpty) {

    print("Det finns inga parkeringsplatser registrerade");

    showMenu();

    return;

  } else {

    printParkingSpaceList(parkingSpaceList);

  }

  stdout.write("\nAnge id på den parkeringsplats du vill visa (tryck enter för att avbryta): ");
  String selection = stdin.readLineSync()!;

  if(selection == "" || int.tryParse(selection) == null) {

    showMenu();
    
    return;
  
  }

  var id = int.parse(selection);

  try {

    //get the parkingspace by its id
    var parkingSpace = parkingSpaceList.where((p) => p.id == id).first;
    print("\nId Adress Pris/timme");
    print("-------------------------------");
    print(parkingSpace.printDetails);
    print("-------------------------------");

  } on StateError { 
    
    //no one was found, lets try again
    print("Det finns ingen parkeringsplats med id $id");

    getParkingSpace();

    return;

  } on RangeError { 
    
    //outside the index, lets try again
    print("Det finns ingen parkeringsplats med id $id");

    getParkingSpace();

    return;

  } catch(err) { //some other error

    print("\nEtt fel har uppstått: $err");

  }

  showMenu();

}

void getAllParkingSpaces() async {

  var parkingSpaceList = await ParkingSpaceRepository().getAll();

  if(parkingSpaceList!.isEmpty) {

    print("Det finns inga parkeringsplatser registrerade");

  } else {

    printParkingSpaceList(parkingSpaceList);

  }

  showMenu();

  return;

}

void updateParkingSpace() async {

  var parkingSpaceList = await ParkingSpaceRepository().getAll();
  if(parkingSpaceList!.isEmpty) {

    print("\nDet finns inga parkeringsplatser registrerade");

    showMenu();

    return;

  }

  printParkingSpaceList(parkingSpaceList);

  stdout.write("\nAnge id på den parkeringsplats du vill uppdatera (tryck enter för att avbryta): ");
  String selection = stdin.readLineSync()!;

  if(selection == "" || int.tryParse(selection) == null) {

    showMenu();
    
    return;
  
  }

  var id = int.parse(selection);

  try {

    //ask to update the name
    String address = setAddress("\nVilken adress har parkeringsplatsen? ");

    //ask to update the personId
    double pricePerHour = setPricePerHour("Vilket pris per timme har parkeringsplatsen? ");

    var parkingSpace = ParkingSpace(id: id, address: address, pricePerHour: pricePerHour);

    //update the person
    var updatedParkingSpace = await ParkingSpaceRepository().update(id, parkingSpace);
    print("\nParkeringsplatsen ${updatedParkingSpace!.address} har uppdaterats");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen parkeringsplats med id $id");

    updateParkingSpace();

    return;

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen parkeringsplats med id $id");

    updateParkingSpace();

    return;

  } catch(err) { 
    
    //some other error, exit function
    print("\nEtt fel har uppstått: $err");

  }

  showMenu();

  return;

}

void deleteParkingSpace() async {

  var parkingSpaceList = await ParkingSpaceRepository().getAll();
  if(parkingSpaceList!.isEmpty) {

    print("\nDet finns inga parkeringsplatser registrerade");

    showMenu();

    return;
  
  }

  printParkingSpaceList(parkingSpaceList);

  stdout.write("\nAnge id på den parkeringsplats du vill ta bort (tryck enter för att avbryta): ");
  String selection = stdin.readLineSync()!;

  //select parkingspace by index
  if(selection == "" || int.tryParse(selection) == null) {

    showMenu();
    
    return;
  
  }

  var id = int.parse(selection);

  try {

    //delete the parking space
    var deletedParkingSpace = await ParkingSpaceRepository().delete(id);
    print("\nParkeringsplatsen ${deletedParkingSpace!.address} har tagits bort");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen parkeingsplats med id $id");

    deleteParkingSpace();

    return;

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen parkeingsplats med id $id");

    deleteParkingSpace();

    return;

  } catch(err) { 
    
    //some other error, exit function
    print("\nEtt fel har uppstått: $err");

  }

  showMenu();

  return;

}


/*---------------- subfunctions ------------------*/

//subfunction to set or update the address
String setAddress([String message = "\nVilken adress har parkeringsplatsen? "]) {

  //set the adress
  String address;
  do {
    stdout.write(message);
    address = stdin.readLineSync(encoding: utf8)!;
  } while(address.isEmpty);

  //return the address
  return address;

}

//subfunction to set or update priceperhour
double setPricePerHour([String message = "Vilket pris per timme har parkeringsplatsen? Fyll i ett numeriskt värde: "]) {

  //set the price, make sure its a double
  String input;
  do {
    stdout.write(message);
    input = stdin.readLineSync()!;
  } while(input.isEmpty || double.tryParse(input) == null);
  
  //return the price
  return double.parse(input);

}

//print list of parkingspaces
void printParkingSpaceList(List<ParkingSpace> parkingSpaceList) {

    print("\nId Adress Pris/timme");
    print("-------------------------------");
    for(var parkingSpace in parkingSpaceList) {
      print(parkingSpace.printDetails);
    }
    print("-------------------------------");

  }






