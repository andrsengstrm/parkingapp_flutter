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

  late Person user;

  bool editMode = false;

  Person getCurrentUser () {
    return widget.user;
  }

  @override
  void initState() {
    super.initState();
    user = getCurrentUser();
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
                initialValue: user.name,
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
                onSaved: (value) => user.name = value!,
              ),
              TextFormField(
                initialValue: user.personId,
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
                onSaved: (value) => user.personId = value!,
              ),
              TextFormField(
                initialValue: user.email,
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
                onSaved: (value) => user.email = value!,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    var updatedPerson = Person(id: user.id, name: user.name, personId: user.personId, email: user.email);
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
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  setState(() {
                    editMode = false;
                  });       
                },
                child: const Text("Avbryt"),
              ),
            ],
          ),
        )
      )
      : Stack(
        fit: StackFit.expand,
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Mitt konto", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("Namn"),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  )
                ),
                const SizedBox(height: 8),
                const Text("Personnummer"),
                Text(
                  user.personId,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  )
                ),
                const SizedBox(height: 8),
                const Text("Email"),
                Text(
                  user.email!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ))
                
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
                  minimumSize: const Size(double.infinity, 50),
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