import 'package:flutter/material.dart';
import 'package:shared/models/parking.dart';
import 'package:parkingapp_admin/repositories/parking_repository.dart';

class ParkingsView extends StatefulWidget {
  
  const ParkingsView({super.key});

  final String title = "Parkeringar";

  @override
  State<ParkingsView> createState() => _ParkingsViewState();

}

class _ParkingsViewState extends State<ParkingsView> {

  late Future<List<Parking>?> parkingsList;

  Future<List<Parking>> getParkingsList() async {
    var parkingsList = await ParkingRepository().getAll();
    return parkingsList!;
  }

  @override
  void initState() {
    super.initState();
    parkingsList = getParkingsList();
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
          Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
          FutureBuilder<List<Parking>?>(
            future: parkingsList,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Column(
                  children: [
                    ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(4),
                      children: [
                        Row(
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
                            )
                          ]
                        )
                      ],
                    ),
                    ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(4),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
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
    );
  }

}

/*

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