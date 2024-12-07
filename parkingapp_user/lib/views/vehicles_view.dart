import 'package:flutter/material.dart';
import 'package:parkingapp_user/repositories/vehicle_repository.dart';
import 'package:shared/models/person.dart';
import 'package:shared/models/vehicle.dart';

class VehiclesView extends StatefulWidget {
  const VehiclesView({super.key, required this.user});

  final Person user;

  @override
  State<VehiclesView> createState() => _VehiclesViewState();
}

class _VehiclesViewState extends State<VehiclesView> {
  
  late Person user;

  Person getCurrentUser () {
    return widget.user;
  }

  late Future<List<Vehicle>?> itemList;
  bool dataLoaded = false;

  Future<List<Vehicle>?> getVehiclesList() async {
    List<Vehicle>? items;
    try{
      items = await VehicleRepository().getByOwnerEmail(user.email);
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
    user = getCurrentUser();
    itemList = getVehiclesList();
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
                selectedItem = null;
              });
            },
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(16),
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
                                      onTap: () async {
                                        var item = await showItemForm(context, items[index], user);
                                        if(item != null) {
                                          await VehicleRepository().update(item.id, item);
                                          setState(() {
                                            itemList = getVehiclesList();
                                          });
                                        }
                                      },
                                      //tileColor: selectedItem == items[index] ?  Colors.amber : Colors.blueGrey[50]
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
            right: 16,
            child: 
              dataLoaded ? 
                ElevatedButton (
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // Set minimum width and height
                  ),
                  onPressed: () async {
                    var item = await showItemForm(context, null, user);
                    if(item?.id == -1) {
                      await VehicleRepository().add(item!);  
                      setState(() {
                        itemList = getVehiclesList();
                      }); 
                    }
                  },
                  child: const Text("Lägg till nytt fordon"),
                )
              : const SizedBox.shrink() 
      
          )
        ]
      ),
    );
  }

}

Future<Vehicle?> showItemForm (BuildContext context, Vehicle? item, Person user) {
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? regId;
  String? vehicleType;

  var isUpdate = item != null ? true: false;


  return showDialog<Vehicle?>(
    context: context,
    builder: (BuildContext context) => Dialog.fullscreen(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isUpdate 
              ? const Text(
                "Uppdatera fordon",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )
              ) 
              : const Text(
                "Lägg till en nytt fordon",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                )
              ),
            const SizedBox(height: 16),
            Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: TextFormField(
                      initialValue: item?.regId,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Registreringsnummer",
                      ),
                      validator: (String? value) {
                        if(value == null || value.isEmpty) {
                          return "Du måste fylla i ett registreringsnummer";
                        }
                        return null;
                      },
                      onSaved: (value) => regId = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: TextFormField(
                      initialValue: item?.vehicleType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Typ av fordon",
                      ),
                      validator: (String? value) {
                        if(value == null || value.isEmpty) {
                          return "Du måste välja vilken typ av fordon det är";
                        }
                        return null;
                      },
                      onSaved: (value) => vehicleType = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:8, right:8),
                          child: ElevatedButton(
                            onPressed: () {
                              if(context.mounted) {
                                Navigator.of(context).pop(null);
                              }             
                            },
                            child: const Text("Avbryt"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8, right:8),
                          child: ElevatedButton(
                            onPressed: () {
                              if(context.mounted) {
                                Navigator.of(context).pop(null);
                              }             
                            },
                            child: const Text("Ta bort"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8),
                          child: ElevatedButton(
                            onPressed: () async {
                              // Validate will return true if the form is valid, or false if
                              // the form is invalid.
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                if(regId != null && vehicleType != null) {
                                  item = Vehicle(id: item?.id, regId: regId!, vehicleType: vehicleType!, owner: user);
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
          ]
        ),
      )
    )
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