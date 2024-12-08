import 'package:flutter/material.dart';
import 'package:shared/models/parking.dart';
import 'package:parkingapp_admin/repositories/parking_repository.dart';

class ParkingsView extends StatefulWidget {
  
  const ParkingsView({super.key});

  @override
  State<ParkingsView> createState() => _ParkingsViewState();

}

class _ParkingsViewState extends State<ParkingsView> {

  late Future<List<Parking>?> activeParkingsList;
  late Future<List<Parking>?> finishedParkingsList;

  Future<List<Parking>> getActiveParkingsList() async {
    var parkingsList = await ParkingRepository().getAll();
    parkingsList = parkingsList!.where((p) => p.endTime == null).toList();
    return parkingsList;
  }

  Future<List<Parking>> getFinishedParkingsList() async {
    var parkingsList = await ParkingRepository().getAll();
    parkingsList = parkingsList!.where((p) => p.endTime != null).toList();
    return parkingsList;
  }

  Parking? selectedItem;

  @override
  void initState() {
    super.initState();
    activeParkingsList = getActiveParkingsList();
    finishedParkingsList = getFinishedParkingsList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedItem = null;
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
                  const Text("Aktiva parkeringar", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  FutureBuilder<List<Parking>?>(
                    future: activeParkingsList,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        var items = snapshot.data;
                        return Column(
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 200, 
                                  child: Text("Parkeringsplats", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  width: 200, 
                                  child: Text("Registreringsnummer", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  width: 200, 
                                  child: Text("Starttid", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  width: 200, 
                                  child: Text("Nuvarande kostnad", style: TextStyle(fontWeight: FontWeight.bold)),
                                )
                              ]
                            ),
                            const SizedBox(height: 8),
                            ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: items!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState((){
                                      selectedItem = items[index];
                                    });
                                    //String? regId = selectedParking!.vehicle!.regId;
                                    //var snackBar = SnackBar(content: Text("Parkeringen för $regId är vald"));
                                    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      color: selectedItem == items[index] ? Colors.blueGrey[50] : Colors.white,
                                      child: Row (
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(items[index].parkingSpace!.address),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text(items[index].vehicle!.regId),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text(items[index].startTime),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text("${items[index].getCostForParking()} kr"),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) => const Divider(),
                            )
                            
                          ]
                        );
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
                  const SizedBox(height: 64),
                  const Text("Avslutade parkeringar", style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  FutureBuilder<List<Parking>?>(
                    future: finishedParkingsList,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        var items = snapshot.data;
                        return Column(
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 200, 
                                  child: Text("Parkeringsplats", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  width: 200, 
                                  child: Text("Registreringsnummer", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  width: 200, 
                                  child: Text("Starttid", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  width: 200, 
                                  child: Text("Sluttid", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(
                                  width: 200, 
                                  child: Text("Slutlig kostnad", style: TextStyle(fontWeight: FontWeight.bold)),
                                )
                              ]
                            ),
                            const SizedBox(height: 8,),
                            ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: items!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState((){
                                      selectedItem = items[index];
                                    });
                                    //String? regId = selectedParking!.vehicle!.regId;
                                    //var snackBar = SnackBar(content: Text("Parkeringen för $regId är vald"));
                                    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      color: selectedItem == items[index] ? Colors.blueGrey[50] : Colors.white,
                                      child: Row (
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(items[index].parkingSpace!.address),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text(items[index].vehicle!.regId),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text(items[index].startTime),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text(items[index].endTime!),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text("${items[index].getCostForParking()} kr"),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) => const Divider(),
                            )
                            
                          ]
                        );
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
        Positioned(
          bottom: 16,
          left: 16,
          child: selectedItem != null ?
            Row (
              children: [
                ElevatedButton (
                  onPressed: () {
                    if(selectedItem != null) {
                      showAlertDialog(context, selectedItem!);
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

showAlertDialog(BuildContext context, Parking selectedParking) {

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