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
  late int parkingsCount = 0;
  late int parkingSpacesCount = 0;

  Future<List<Parking>?> getParkingsList() async {
    List<Parking>? items;
    try{
      items = await ParkingRepository().getAll();
      setState(() {
        parkingsCount = items!.length;
      });
      
    } catch(err) {
      debugPrint("Error! $err");
      throw Exception();
    }
    return items;
  }

  Future<List<ParkingSpace>?> getParkingSpacesList() async {
    List<ParkingSpace>? items;
    try{
      items = await ParkingSpaceRepository().getAll();
      setState(() {
        parkingSpacesCount = items!.length;
      });
      
    } catch(err) {
      debugPrint("Error! $err");
      throw Exception();
    }
    return items;
  }



  @override
  void initState() {
    super.initState();
    parkingsList = getParkingsList();
    parkingSpacesList = getParkingSpacesList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: 800,
      height: 800,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Antal aktiva parkeringar"),
                    Text(parkingsCount.toString(), style: TextStyle(fontSize: 28))
                  ],
                ),
              ),
              Container(
                width: 200,
                height: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Antal parkeringsplatser"),
                    Text(parkingSpacesCount.toString(), style: TextStyle(fontSize: 28))
                  ],
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}