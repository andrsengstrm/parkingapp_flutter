import 'package:flutter/material.dart';
import 'package:parkingapp_user/repositories/vehicle_repository.dart';
import 'package:shared/models/vehicle.dart';

class VehiclesView extends StatefulWidget {
  const VehiclesView({super.key});

  @override
  State<VehiclesView> createState() => _VehiclesViewState();
}

class _VehiclesViewState extends State<VehiclesView> {
  
  late Future<List<Vehicle>?> itemList;
  bool dataLoaded = false;

  Future<List<Vehicle>?> getVehiclesList() async {
    List<Vehicle>? items;
    try{
      items = await VehicleRepository().getAll();
      setState(() {
        dataLoaded = true;
      });
      debugPrint("Data was loaded!");
    } catch(err) {
      debugPrint("Error! $err");
      setState(() {
        dataLoaded = false;
      });
      throw Exception();
    }
    return items;
  }

  Vehicle? selectedItem;

  

  @override
  void initState() {
    super.initState();
    itemList = getVehiclesList();
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
                const Text("Fordon", style: TextStyle(fontWeight: FontWeight.bold)),
                FutureBuilder<List<Vehicle>?>(
                  future: itemList,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      var items = snapshot.data!;
                      return Column(
                        children: [
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Card(
                                  child: ListTile(
                                    title: Text(items[index].regId),
                                    onTap: () {
                                      setState((){
                                        selectedItem = items[index];
                                      });
                                    },
                                    tileColor: selectedItem == items[index] ?  Colors.amber : Colors.blueGrey[50]
                                  )
                                ),
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
          child: 
            Row (
              children: [
                dataLoaded ? 
                  Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: ElevatedButton (
                        onPressed: () async {
                          var item = await showItemForm(context, null);
                          if(item?.id == -1) {
                            await VehicleRepository().add(item!);  
                            setState(() {
                              itemList = getVehiclesList();
                            }); 
                          }
                          
                        },
                        child: const Text("Lägg till nytt fordon")
                      ),
                  )
                : const SizedBox.shrink(),
                selectedItem != null ?   
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: ElevatedButton (
                          onPressed: () async {
                            var item = await showItemForm(context, selectedItem);
                            if(item != null) {
                              await VehicleRepository().update(item.id, item);
                              setState(() {
                                itemList = getVehiclesList();
                              });
                            }
                            
                          },
                          child: const Text("Redigera")
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:8.0),
                        child: ElevatedButton (
                          onPressed: () async {
                            if(selectedItem != null) {
                              var confirm = await showRemovalDialog(context, selectedItem!);
                              if(confirm == "confirm") {
                                await VehicleRepository().delete(selectedItem!.id);
                                setState(() {
                                  itemList = getVehiclesList();
                                });
                              }
                            }
                          },
                          child: const Text("Ta bort")
                        ),
                      )
                    ],
                  )
                : const SizedBox.shrink()
              ]
            ) 

        )
      ]
    );
  }

}

Future<Vehicle?> showItemForm (BuildContext context, Vehicle? item) {
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? regId;
  String? vehicleType;

  var isUpdate = item != null ? true: false;


  return showDialog<Vehicle?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  isUpdate ? const Text("Uppdatera fordon") : const Text("Lägg till en nytt fordon"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: item?.regId,
                decoration: const InputDecoration(
                  hintText: "Registreringsnummer",
                ),
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return "Du måste fylla i ett registreringsnummer";
                  }
                  return null;
                },
                onSaved: (value) => regId = value,
              ),
              TextFormField(
                initialValue: item?.vehicleType,
                decoration: const InputDecoration(
                  hintText: "Typ av fordon",
                ),
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return "Du måste välja vilken typ av fordon det är";
                  }
                  return null;
                },
                onSaved: (value) => vehicleType = value,
              ),
              Padding(
                padding: const EdgeInsets.only(top:32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8, right:8),
                      child: TextButton(
                        onPressed: () {
                          if(context.mounted) {
                            Navigator.of(context).pop(null);
                          }             
                        },
                        child: const Text("Avbryt"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8),
                      child: TextButton(
                        onPressed: () async {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            if(regId != null && vehicleType != null) {
                              item = Vehicle(id: item?.id, regId: regId!, vehicleType: vehicleType!);
                            }
                            if(context.mounted) {
                              Navigator.of(context).pop(item);
                            }             
                                  
                          } 
                        },
                        child: const Text("OK"),
                      ),
                    ),
                  ]
                ),
              )
            ],
          )
        ),
      );
    },
  );

}

Future<String?> showRemovalDialog(BuildContext context, Vehicle item) {

  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () { 
      Navigator.of(context).pop("confirm"); // dismiss dialog
    },
  );

  // set up the button
  Widget cancelButton = TextButton(
    child: const Text("Avbryt"),
    onPressed: () { 
      Navigator.of(context).pop(); // dismiss dialog
    },
  );

    // set up the AlertDialog
  return showDialog<String>(
    context: context, 
    builder: (BuildContext builder) {
      return AlertDialog (
        title:  const Text("Vill du ta bort fordonet?"),
        content: const Text(""),
        actions: [
          cancelButton,
          okButton,
        ],
      );
    }
  );
  

}