import 'package:flutter/material.dart';
import 'package:shared/models/parking.dart';
import 'package:parkingapp_admin/repositories/parking_repository.dart';

class ParkingsView extends StatefulWidget {
  
  const ParkingsView({super.key});

  @override
  State<ParkingsView> createState() => _ParkingsViewState();

}

class _ParkingsViewState extends State<ParkingsView> {

  late Future<List<Parking>?> parkingsList;

  Future<List<Parking>> getParkingsList() async {
    var parkingsList = await ParkingRepository().getAll();
    return parkingsList!;
  }

  Parking? selectedParking;

  @override
  void initState() {
    super.initState();
    parkingsList = getParkingsList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          alignment: Alignment.topLeft,
          width: 800,
          height: 800,
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Aktiva parkeringar", style: TextStyle(fontWeight: FontWeight.bold)),
              FutureBuilder<List<Parking>?>(
                future: parkingsList,
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return Column(
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text("Id", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              width: 200, 
                              child: Text("Registreringsnummer", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              width: 200, 
                              child: Text("Adress", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              width: 200, 
                              child: Text("Starttid", style: TextStyle(fontWeight: FontWeight.bold)),
                            )
                          ]
                        ),
                        ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              
                              onTap: () {
                                setState((){
                                  selectedParking = snapshot.data![index];
                                });
                                //String? regId = selectedParking!.vehicle!.regId;
                                //var snackBar = SnackBar(content: Text("Parkeringen för $regId är vald"));
                                //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  color: selectedParking == snapshot.data![index] ? Colors.green[100] : Colors.white,
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
                                      SizedBox(
                                        width: 200,
                                        child: Text(snapshot.data![index].startTime),
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
                    return Text("Error!");
                  }
                  return const CircularProgressIndicator();
                }
              )
            ],
          )
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: selectedParking != null ?
            Row (
              children: [
                TextButton (
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green[100]),
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(24)),
                  ),
                  onPressed: () {
                    if(selectedParking != null) {
                      showAlertDialog(context, selectedParking!);
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