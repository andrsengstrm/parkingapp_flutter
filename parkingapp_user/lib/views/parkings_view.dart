import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:parkingapp_user/repositories/parking_space_repository.dart';
import 'package:parkingapp_user/repositories/vehicle_repository.dart';
import 'package:shared/helpers/helpers.dart';
import 'package:shared/models/parking.dart';
import 'package:parkingapp_user/repositories/parking_repository.dart';
import 'package:shared/models/parking_space.dart';
import 'package:shared/models/person.dart';
import 'package:shared/models/vehicle.dart';

class ParkingsView extends StatefulWidget {
  
  const ParkingsView({super.key, required this.user});

  final Person user;

  @override
  State<ParkingsView> createState() => _ParkingsViewState();

}

class _ParkingsViewState extends State<ParkingsView> {

  late Person user;
  late Future<List<Vehicle>?> vehiceList;
  late Future<List<ParkingSpace>?> parkingSpaceList;
  late Future<List<Parking>?> parkingsList;
  Parking? selectedParking;

  Person getCurrentUser () {
    return widget.user;
  }

  Future<List<Parking>> getParkingsList(email) async {
    var parkingsList = await ParkingRepository().getAllByVehicleOwnerEmail(email);
    return parkingsList!;
  }

  Future<Parking?> startParking(Parking newParking) async {
    var startedParking = await ParkingRepository().add(newParking);
    return startedParking;
  }

  Future<List<Vehicle>?> getVehicles() async {
    try {
      var items = await VehicleRepository().getByOwnerEmail(user.email);
      return items;
    } catch(err) {
      debugPrint(err.toString());
    }
    return null;
  }

  Future<List<ParkingSpace>?> getParkingSpaces() async {
    try {
      var items = await ParkingSpaceRepository().getAll();
      return items;
    } catch(err) {
      debugPrint(err.toString());
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    user = getCurrentUser();
    vehiceList = getVehicles();
    parkingSpaceList = getParkingSpaces();
    parkingsList = getParkingsList(user.email);
    selectedParking = null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedParking = null;
            });
          },
          child: Container(
            alignment: Alignment.topLeft,
            width: 800,
            height: 800,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                Container(
                  alignment: const Alignment(0, 0),
                  padding: const EdgeInsets.all(64),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(240, 240), // Set minimum width and height
                    ),
                    onPressed: () {
                      var parking = showStartParkingDialog(context, vehiceList, parkingSpaceList);
                    },
                    child: const Text("Starta parkering")
                  ),
                ),
                const Text("Aktiva parkeringar", style: TextStyle(fontWeight: FontWeight.bold)),
                FutureBuilder<List<Parking>?>(
                  future: parkingsList,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      var items = snapshot.data;
                      if(items!.isNotEmpty) {
                        return Column(
                          children: [
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: items!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState((){
                                      selectedParking = items[index];
                                    });
                                    //String? regId = selectedParking!.vehicle!.regId;
                                    //var snackBar = SnackBar(content: Text("Parkeringen för $regId är vald"));
                                    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Card(
                                      child: ListTile(
                                        title: Text(items![index].parkingSpace!.address),
                                        trailing: const Icon(Icons.more_vert),
                                      )
                                    )
                                      
                                    
                                  )
                                );
                              },
                              
                            )
                            
                          ]
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text("Det finns inga aktiva parkeringar"),
                        );
                      }
                    } else if(snapshot.hasError) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text("Det gick inte att hämta data!"),
                      );
                    } 
                    
                    return const Padding(
                      padding: EdgeInsets.only(top: 16, right: 16, bottom: 16),
                      child: LinearProgressIndicator(
                        minHeight: 1,
                      )
                    );
                    
                  }
                )
              ],
            )
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: selectedParking != null ?
            Row (
              children: [
                ElevatedButton (
                  onPressed: () {
                    if(selectedParking != null) {
                      showSelectedParkingDialog(context, selectedParking!);
                    }
                  },
                  child: const Text("Visa detaljer")
                )
              ]
            ) 
            : 
            const SizedBox.shrink()

        )
      ]
    );
  }

}

showStartParkingDialog(BuildContext context, Future<List<Vehicle>?> vehicleList, Future<List<ParkingSpace>?> parkingSpaceList ) {

  late Vehicle selectedVehicle;
  late ParkingSpace selectedParkingSpace;

  // set up the button
  Widget okButton = TextButton(
    child: const Text("Starta pakering"),
    onPressed: () { 
      String startTime = Helpers().formatDate(DateTime.now());
      Parking newParking = Parking(vehicle: selectedVehicle, parkingSpace: selectedParkingSpace, startTime: startTime);
      debugPrint(newParking.vehicle!.regId);
      Navigator.of(context).pop(newParking); // dismiss dialog
    },
  );

  Widget cancelButton = TextButton( 
    child: const Text("Avbryt"),
    onPressed: () { 
      Navigator.of(context).pop(); // dismiss dialog
    },
  );

    // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Starta parkering"),
    content: StatefulBuilder(
      builder:(BuildContext context, StateSetter setState){
      return Column(
        children: [
          const Text("Välj fordon för din parkering"),
          FutureBuilder<List<Vehicle>?>(
            future: vehicleList,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                var items = snapshot.data;
                if(items!.isNotEmpty) {
                  return DropdownMenu<Vehicle>(
                    initialSelection: items.first,
                    onSelected: (Vehicle? value) {
                      setState((){
                        selectedVehicle = value!;
                      });
                    },
                    dropdownMenuEntries: items.map<DropdownMenuEntry<Vehicle>>((Vehicle v) {
                      return DropdownMenuEntry<Vehicle>(
                        value: v,
                        label: v.regId,
                      );
                    }).toList(),    
                  );
                }
              }
              return const Text("Det gick inte att visa fordon");
            }
          ),
          const Text("Välj parkerigsplats för din parkering"),
          FutureBuilder<List<ParkingSpace>?>(
            future: parkingSpaceList,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                var items = snapshot.data;
                if(items!.isNotEmpty) {
                  return DropdownMenu<ParkingSpace>(
                    initialSelection: items.first,
                    onSelected: (ParkingSpace? value) {
                      setState((){
                        selectedParkingSpace = value!;
                      });
                    },
                    dropdownMenuEntries: items.map<DropdownMenuEntry<ParkingSpace>>((ParkingSpace v) {
                      return DropdownMenuEntry<ParkingSpace>(
                        value: v,
                        label: v.address,
                      );
                    }).toList(),    
                  );
                }
              }
              return const Text("Det gick inte att visa fordon");
            }
          ),
        ]
      );
      }
  ),
    actions: [
      cancelButton,
      okButton
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showSelectedParkingDialog(BuildContext context, Parking selectedParking) {

  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () { 
      Navigator.of(context).pop(); // dismiss dialog
    },
  );

    // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title:  Text(selectedParking.vehicle!.regId),
    content: Text("Parkeringens aktuella saldo: ${selectedParking.getCostForParking()} kr"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

}


/*

child: Row (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child:  Text(snapshot.data![index].id.toString()),
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(snapshot.data![index].vehicle!.regId),
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(snapshot.data![index].parkingSpace!.address),
                              ),
                            ],
                          )

return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(4),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(snapshot.data![index].id.toString());
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                );

*/