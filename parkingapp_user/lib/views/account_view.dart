import 'package:flutter/material.dart';
import 'package:parkingapp_user/repositories/person_repository.dart';
import 'package:shared/models/person.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key, required this.user});

  final Person user;

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late Person person;

  bool editMode = false;

  Person getCurrentUser () {
    return widget.user;
  }

  @override
  void initState() {
    super.initState();
    person = getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: 
      editMode
      ? Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            runSpacing: 16,
            children: [
              const Text("Mitt konto", style: TextStyle(fontWeight: FontWeight.bold)),
              TextFormField(
                initialValue: person.name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Namn",
                  hintText: "Namn",
                ),
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return "Du måste fylla i ett namn";
                  }
                  return null;
                },
                onSaved: (value) => person.name = value!,
              ),
              TextFormField(
                initialValue: person.personId,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Personnummer",
                  hintText: "Personnummer",
                ),
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return "Du måste fylla i ett personnummer";
                  }
                  return null;
                },
                onSaved: (value) => person.personId = value!,
              ),
              TextFormField(
                initialValue: person.email,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                  hintText: "Email",
                ),
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return "Du måste fylla i email";
                  }
                  return null;
                },
                onSaved: (value) => person.email = value!,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Set minimum width and height
                ),
                onPressed: () {
                  setState(() {
                    editMode = false;
                  });       
                },
                child: const Text("Avbryt"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Set minimum width and height
                ),
                onPressed: () async {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    
                    var updatedPerson = Person(id: person.id, name: person.name, personId: person.personId, email: person.email);
                    var personReturned = await PersonRepository().update(updatedPerson.id, updatedPerson);    
                    if(personReturned != null) {
                      setState(() {
                        editMode = false;
                      });
                    }
                     
                  } 
                },
                child: const Text("Spara"),
              ),
            ],
          ),
        )
      )
      : Stack(
        fit: StackFit.expand,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Mitt konto", style: TextStyle(fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Namn"),
                      Text(
                        person.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )),
                      const SizedBox(height: 8),
                      const Text("Personnummer"),
                      Text(
                        person.personId,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )),
                      const SizedBox(height: 8),
                      const Text("Email"),
                      Text(
                        person.email!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )),
                    ],
                  )
                )
                
             ]
            ),
          ),
          Positioned(
            right: 16,
            bottom: 8,
            left: 16,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Set minimum width and height
                ),
                onPressed: () {
                  setState(() {
                    editMode = true;
                  });
                },
                child: const Text("Redigera"))
            ),
          )
          
          
        ],
      )
    );
  }
}