import 'package:flutter/material.dart';
import 'package:shared/models/parking.dart';
import 'package:parkingapp_user/repositories/parking_repository.dart';

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

  Parking? selectedItem;

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
        GestureDetector(
          onTap: () {
            setState(() {
              selectedItem = null;
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
                const Text("Aktiva parkeringar", style: TextStyle(fontWeight: FontWeight.bold)),
                FutureBuilder<List<Parking>?>(
                  future: parkingsList,
                  builder: (context, snapshot) {
                    var items = snapshot.data;
                    if(snapshot.hasData) {
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
                                    selectedItem = items[index];
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