import 'package:flutter/material.dart';
import 'package:parkingapp_admin/repositories/parking_repository.dart';
import 'package:parkingapp_admin/repositories/parking_space_repository.dart';
import 'package:shared/models/parking.dart';
import 'package:shared/models/parking_space.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  final String title = "Dashboard";

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  
  late Future<List<Parking>?> parkingsList;
  late Future<List<ParkingSpace>?> parkingSpacesList;
  late int allParkingsCount = 0;
  late int activeParkingsCount = 0;
  late int allParkingSpacesCount = 0;
  late int availableParkingSpacesCount = 0;
  late double totalParkingsCost = 0;

  Future<List<Parking>> getAllParkingsList() async {
    var parkingsList = await ParkingRepository().getAll();
    var allParkingsList = parkingsList!.toList();
    var activeParkingsList = parkingsList.where((p) => p.endTime == null).toList();
    setState(() {
        allParkingsCount = allParkingsList.length;
        activeParkingsCount = activeParkingsList.length;
      });
    return parkingsList;
  }

  Future<List<ParkingSpace>?> getParkingSpacesList() async {
    List<ParkingSpace>? items;
    try{
      items = await ParkingSpaceRepository().getAll();
      setState(() {
        allParkingSpacesCount = items!.length;
      });
      
    } catch(err) {
      debugPrint("Error! $err");
      throw Exception();
    }
    return items;
  }

  Future<List<ParkingSpace>?> getAllParkingSpacesList() async {
    var activeParkings = await ParkingRepository().getAll();
    var busyParkings = [];
    double cost = 0;
    for(var i = 0; i < activeParkings!.length; i++) {
      var parking = activeParkings[i];
      if(parking.endTime == null) {
        if(!busyParkings.contains(parking.parkingSpace!.id)) {
          busyParkings.add(parking.parkingSpace!.id);
        }
      }
      cost += double.tryParse(parking.getCostForParking()) != null ? double.parse(parking.getCostForParking()): 0;
    }
    var allParkingSpaces = await ParkingSpaceRepository().getAll();
    late List<ParkingSpace>? availableParkingSpaces = [];
    for(var i = 0; i < allParkingSpaces!.length; i++) {
      var parkingSpace = allParkingSpaces[i];
      if(!busyParkings.contains(parkingSpace.id)) {
        availableParkingSpaces.add(parkingSpace);
      }
    }
    setState(() {
      allParkingSpacesCount = allParkingSpaces.length;
      availableParkingSpacesCount = availableParkingSpaces.length;
      totalParkingsCost = cost;
    });
    return allParkingSpaces;
  }



  @override
  void initState() {
    super.initState();
    parkingsList = getAllParkingsList();
    parkingSpacesList = getAllParkingSpacesList();
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Dashboard", style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  child: Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Antal aktiva parkeringar"),
                        Text(activeParkingsCount.toString(), style: TextStyle(fontSize: 42))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  child: Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Totalt antal parkeringar"),
                        Text(allParkingsCount.toString(), style: TextStyle(fontSize: 42))
                      ],
                    ),
                  ),
                )
              ]
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  child: Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Antal lediga parkeringsplatser"),
                        Text(availableParkingSpacesCount.toString(), style: TextStyle(fontSize: 42))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  child: Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Totalt antal parkeringsplatser"),
                        Text(allParkingSpacesCount.toString(), style: TextStyle(fontSize: 42))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 616,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Total intäkt"),
                  Text("${totalParkingsCost.toStringAsFixed(2)} kr" , style: TextStyle(fontSize: 42))
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}