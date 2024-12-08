import 'package:flutter/material.dart';
import 'package:parkingapp_admin/repositories/parking_space_repository.dart';
import 'package:shared/models/parking_space.dart';

class ParkingSpacesView extends StatefulWidget {
  const ParkingSpacesView({super.key});

  @override
  State<ParkingSpacesView> createState() => _ParkingSpacesViewState();
}

class _ParkingSpacesViewState extends State<ParkingSpacesView> {
  
  late Future<List<ParkingSpace>?> itemList;
  bool dataLoaded = false;

  Future<List<ParkingSpace>?> getParkingSpaceList() async {
    List<ParkingSpace>? items;
    try{
      items = await ParkingSpaceRepository().getAll();
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

  ParkingSpace? selectedItem;

  

  @override
  void initState() {
    super.initState();
    itemList = getParkingSpaceList();
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
                  const Text("Parkeringsplatser", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  FutureBuilder<List<ParkingSpace>?>(
                    future: itemList,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        var items = snapshot.data!;
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
                                  child: Text("Kostnad/timme", style: TextStyle(fontWeight: FontWeight.bold)),
                                )
                              ]
                            ),
                            const SizedBox(height: 8),
                            ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: items.length,
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
                                            child: Text(items[index].address),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text(items[index].pricePerHour.toString()),
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
                            await ParkingSpaceRepository().add(item!);  
                            setState(() {
                              itemList = getParkingSpaceList();
                            }); 
                          }
                          
                        },
                        child: const Text("Lägg till ny parkeringsplats")
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
                              await ParkingSpaceRepository().update(item.id, item);
                              setState(() {
                                itemList = getParkingSpaceList();
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
                                await ParkingSpaceRepository().delete(selectedItem!.id);
                                setState(() {
                                  itemList = getParkingSpaceList();
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

Future<ParkingSpace?> showItemForm (BuildContext context, ParkingSpace? item) {
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? address;
  double pricePerHour = 0;

  var isUpdate = item != null ? true: false;


  return showDialog<ParkingSpace?>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  isUpdate ? const Text("Lägg till en ny parkeringsplats") : const Text("Uppdatera parkeringsplats"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: item?.address,
                decoration: const InputDecoration(
                  hintText: "Address",
                ),
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return "Du måste fylla i en adress";
                  }
                  return null;
                  //item?.address = value;
                },
                onSaved: (value) => address = value,
              ),
              TextFormField(
                initialValue: item?.pricePerHour.toString(),
                decoration: const InputDecoration(
                  hintText: "Kostnad per timme",
                ),
                validator: (String? value) {
                  var pricePerHour = double.tryParse(value!);
                  if(pricePerHour == null) {
                    return "Du måste fylla i ett pris per timme";
                  }
                  return null;
                  //item?.pricePerHour = pricePerHour;
                },
                onSaved: (value) {
                  if(value != null && double.tryParse(value) != null) {
                    pricePerHour = double.parse(value);
                  } 
                }
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
                            
                            item = ParkingSpace(id: item?.id, address: address!, pricePerHour: pricePerHour);
                            
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

Future<String?> showRemovalDialog(BuildContext context, ParkingSpace item) {

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
        title:  const Text("Vill du ta bort parkeringsplatsen?"),
        content: const Text(""),
        actions: [
          cancelButton,
          okButton,
        ],
      );
    }
  );
  

}