import 'dart:io';
import 'package:cli/person_menu.dart' as personer_menu;
import 'package:cli/vehicle_menu.dart' as vehicle_menu;
import 'package:cli/parking_space_menu.dart' as parking_space_menu;
import 'package:cli/parking_menu.dart' as parking_menu;

void showMenu() {

  //always clear the screen when starting or returning to the main menu
  stdout.write("\x1B[2J\x1B[0;0H");

  //show a prompt to select option
  print("Välkommen till parkeringsappen!");
  print("Vad vill du hantera?");
  print("1. Personer");
  print("2. Fordon");
  print("3. Parkeringsplatser");
  print("4. Parkeringar");
  print("5. Avsluta");
  print("");
  stdout.write("Välj ett alternativ (1-5): ");

  //read which option was selected
  readMenuSelection();

}

void readMenuSelection() {
  
  //wait for input and read the selection option
  String optionSelected = stdin.readLineSync()!;

  //select action based on the selected option
  if(optionSelected == "1") { 
    
    //show menu for personer
    personer_menu.showMenu();
  
  } else if(optionSelected == "2") { 
    
    //show menu for vehicles
    vehicle_menu.showMenu();
  
  } else if(optionSelected == "3") { 
    
    //show menu for parkingspaces
    parking_space_menu.showMenu();
  
  } else if(optionSelected == "4") { 
    
    //show menu for parkings
    parking_menu.showMenu();
  
  } else if(optionSelected == "5") { 
    
    //exit the program
    exitProgram();
  
  } else { 
    
    //unsupported selection
    stdout.write("\nOgiligt val! Välj ett alternativ (1-5): ");
    readMenuSelection();
  
  }

}

void exitProgram() {

  //ask for confirmation to exit the program
  stdout.write("\nVill du avsluta programmet? (J för att avsluta): ");

  //wait for input and read the selection option
  String optionSelected = stdin.readLineSync()!;

  if(!optionSelected.toLowerCase().startsWith("j")) { //the user did not press J or j, abort the exit and return to the main menu
    showMenu();
  }

  //cls to clear the screen
  stdout.write("\x1B[2J\x1B[0;0H");

  //exit without errors
  exit(0);

}