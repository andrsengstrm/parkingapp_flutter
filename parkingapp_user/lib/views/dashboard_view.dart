import 'package:flutter/material.dart';
import 'package:parkingapp_user/repositories/parking_repository.dart';
import 'package:parkingapp_user/repositories/vehicle_repository.dart';
import 'package:shared/models/parking.dart';
import 'package:shared/models/vehicle.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  final String title = "Dashboard";

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  
  late Future<List<Parking>?> parkingsList;
  late Future<List<Vehicle>?> vehicleList;
  late int parkingsCount = 0;
  late int vehiclesCount = 0;

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

  Future<List<Vehicle>?> getVehiclesList() async {
    List<Vehicle>? items;
    try{
      items = await VehicleRepository().getAll();
      setState(() {
        vehiclesCount = items!.length;
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
    vehicleList = getVehiclesList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
          Column(
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Antal parkeringar"),
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
                    const Text("Antal fordon"),
                    Text(vehiclesCount.toString(), style: TextStyle(fontSize: 28))
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