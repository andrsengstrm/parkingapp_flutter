import 'package:flutter/material.dart';
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

  Future<List<Parking>?> getParkingsList(email) async {
    try {
      var parkingsList = await ParkingRepository().getAllByVehicleOwnerEmail(email);
      return parkingsList;
    } catch(err) {
      debugPrint(err.toString());
    }
    return null;
  }

  Future<Parking?> startParking(Parking newParking) async {
    try {
      var startedParking = await ParkingRepository().add(newParking);
      return startedParking;
    } catch(err) {
      debugPrint(err.toString());
    }
    return null;
  }

  Future<Parking?> endParking(Parking parkingToEnd) async {
    try {
      var endedParking = await ParkingRepository().update(parkingToEnd.id, parkingToEnd);
      return endedParking;
    } catch(err) {
      debugPrint(err.toString());
    }
    return null;
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
    return Container(
      color: Colors.white,
      alignment: Alignment.topLeft,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedParking = null;
              });
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                alignment: Alignment.topLeft,
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
                          minimumSize: const Size(240, 240),
                        ),
                        onPressed: () async {
                          var parking = await showStartParkingDialog(context, vehiceList, parkingSpaceList);
                          if(parking != null) {
                            var startedParking = await startParking(parking);
                            if(startedParking != null) {
                              setState(() {
                                parkingsList = getParkingsList(user.email);
                              });
                            }
                          }
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
                          var activeParkings = items!.where((p) => p.endTime == null).toList();
                          if(activeParkings.isNotEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: activeParkings.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        setState((){
                                          selectedParking = activeParkings[index];
                                        });
                                        var parkingToBeFinished = await showSelectedParkingDialog(context, selectedParking);
                                        if(parkingToBeFinished == null) {
                                          return;
                                        }
                                        var endedParking = await endParking(parkingToBeFinished);
                                        if(endedParking != null) {
                                          setState(() {
                                            parkingsList = getParkingsList(user.email);
                                          });
                                        }
                                      },
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Card(
                                          child: ListTile(
                                            title: Text("${activeParkings[index].vehicle!.regId} - ${activeParkings[index].parkingSpace!.address}"),
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
                    ),
                    const SizedBox(height: 32),
                    const Text("Tidigare parkeringar", style: TextStyle(fontWeight: FontWeight.bold)),
                    FutureBuilder<List<Parking>?>(
                      future: parkingsList,
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          var items = snapshot.data;
                          var inactiveParkings = items!.where((p) => p.endTime != null).toList();
                          if(inactiveParkings.isNotEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: inactiveParkings.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        setState((){
                                          selectedParking = inactiveParkings[index];
                                        });
                                        await showSelectedParkingDialog(context, selectedParking); 
                                      },
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Card(
                                          child: ListTile(
                                            title: Text("${inactiveParkings[index].vehicle!.regId} - ${inactiveParkings[index].parkingSpace!.address}"),
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
                              child: Text("Det finns inga tidigare parkeringar"),
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
          ),
        ]
      ),
    );
  }
}

Future<Parking?>? showStartParkingDialog(BuildContext context, Future<List<Vehicle>?> vehicleList, Future<List<ParkingSpace>?> parkingSpaceList ) {

  late Vehicle selectedVehicle;
  late ParkingSpace selectedParkingSpace;
  late Parking? newParking;
  final Size size = MediaQuery.sizeOf(context);
  final double contentWidth = size.width - 32;

  Future<List<ParkingSpace>?> getAvailableParkingSpaces() async {
    var activeParkings = await ParkingRepository().getAll();
    var busyParkings = [];
    for(var i = 0; i < activeParkings!.length; i++) {
      var p = activeParkings[i];
      if(p.endTime == null) {
        if(!busyParkings.contains(p.parkingSpace!.id)) {
          busyParkings.add(p.parkingSpace!.id);
        }
      }
    }
    var allParkingSpaces = await ParkingSpaceRepository().getAll();
    late List<ParkingSpace>? availableParkingSpaces = [];
    for(var i = 0; i < allParkingSpaces!.length; i++) {
      var p = allParkingSpaces[i];
      if(!busyParkings.contains(p.id)) {
        availableParkingSpaces.add(p);
      }
    }
    return availableParkingSpaces;
  }

  Future<List<ParkingSpace>?> selectableParkingSpaceList = getAvailableParkingSpaces();

  return showDialog(
    context: context,
    builder: (BuildContext context) => Dialog.fullscreen(
    child: Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Wrap(
          spacing: 16,
          direction: Axis.vertical,
          children: [
            const Text(
              "Starta parkering",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
            FutureBuilder<List<Vehicle>?>(
              future: vehicleList,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  var items = snapshot.data;
                  if(items!.isNotEmpty) {
                    return DropdownMenu<Vehicle>(
                      width: contentWidth,
                      hintText: "Välj fordon",
                      onSelected: (Vehicle? value) {
                        selectedVehicle = value!;
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
            FutureBuilder<List<ParkingSpace>?>(
              future: selectableParkingSpaceList,
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  var items = snapshot.data;
                  if(items!.isNotEmpty) {
                    return DropdownMenu<ParkingSpace>(
                      width: contentWidth,
                      hintText: "Välj parkeringsplats",
                      onSelected: (ParkingSpace? value) {
                        selectedParkingSpace = value!;
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
                return const Text("Det gick inte att visa parkeringar");
              }
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(contentWidth, 50),
              ),
              child: const Text("Starta parkering"),
              onPressed: () { 
                String startTime = Helpers().formatDate(DateTime.now());
                newParking = Parking(vehicle: selectedVehicle, parkingSpace: selectedParkingSpace, startTime: startTime);
                Navigator.of(context).pop(newParking);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(contentWidth, 50),
              ),
              child: const Text("Avbryt"),
              onPressed: () { 
                Navigator.of(context).pop(null);
              },
            )
          ]
        ),
      )
    )
  );
}

Future<Parking?> showSelectedParkingDialog(BuildContext context, Parking? selectedParking) {

  final Size size = MediaQuery.sizeOf(context);
  final double contentWidth = size.width - 32;

  return showDialog<Parking?>(
    context: context,
    builder: (BuildContext context) => Dialog.fullscreen( 
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Parkering", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Parkeringens starttid"),
            Text(
              selectedParking!.startTime,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 8),  
            selectedParking.endTime != null 
            ? Wrap(
                direction: Axis.vertical,
                children: [
                  const Text("Parkeringen sluttid"),
                  Text(selectedParking.endTime!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  const SizedBox(height: 8),
                ]
              )
            : const SizedBox.shrink(),
            const Text("Kostnad för parkeringen"),
            Text("${selectedParking.getCostForParking()} kr",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 8),
            selectedParking.endTime == null
            ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(contentWidth, 50),
              ),
              child: const Text("Avsluta parkering"),
              onPressed: () { 
                String endTime = Helpers().formatDate(DateTime.now());
                selectedParking.endTime = endTime;
                Navigator.of(context).pop(selectedParking);
              },
            )
            : const SizedBox.shrink(),
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(contentWidth, 50),
              ),
              child: const Text("Stäng"),
              onPressed: () { 
                Navigator.of(context).pop();
              },
            ),
          ],
        )
      )
    )
  );
}
