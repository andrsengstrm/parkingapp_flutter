import 'package:flutter/material.dart';
import 'package:parkingapp_user/repositories/person_repository.dart';
import 'package:shared/models/person.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.onLogin});

  final Function onLogin;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final ValueNotifier<Future> _loginHandler = ValueNotifier(Future.value());

  final _formKey = GlobalKey<FormState>();

  late String? name;
  late String? personId;
  late String? email;
  late String? pwd;
  late bool loginModeCreate = false;
  late bool loginError = false;

  Future<bool> loginUser () async {
    bool isLoggedIn = false;
    loginError = false;
    try {
      debugPrint("Email: $email");
      var person = await PersonRepository().getByEmail(email!);
      debugPrint(person!.email);
      if(person != null) {
        isLoggedIn = true;
      }
    } catch(err) {
      loginError = true;
    }
    return isLoggedIn;
  }

  Future<Person?> createUser () async {
    Person? person;
    loginError = false;
    try {
      //debugPrint("Email: $loginEmail");
      var newPerson = Person(personId: personId!, name: name!, email: email);
      person = await PersonRepository().add(newPerson);
    } catch(err) {
      debugPrint(err.toString());
      loginError = true;
    }
    return person;
  }

@override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _loginHandler,
      builder: (context, value, _) {
      return FutureBuilder(
        future: value,
        builder: (context, snapshot) {
         return Center(
            widthFactor: 300,
            child: 
            
            loginModeCreate
            
            ? Form(
                key: _formKey,
                child: SizedBox(
                  width: 300,
                  child: Wrap(
                    runSpacing: 16,
                    children: [
                      const Text(
                        "Parkeringsappen",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const Text("Fyll i dina uppgifter för att skapa ett konto"),
                      TextFormField(
                        enabled: snapshot.connectionState != ConnectionState.waiting,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                          hintText: "Email",
                        ),
                        validator: (String? value) {
                          if(value == null || value.isEmpty) {
                            return "Du måste fylla i din email för att skapa ett konto";
                          }
                          return null;
                        },
                        onSaved: (value) => email = value,
                      ),
                      TextFormField(
                        enabled: snapshot.connectionState != ConnectionState.waiting,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Namn",
                          hintText: "Namn",
                        ),
                        validator: (String? value) {
                          if(value == null || value.isEmpty) {
                            return "Du måste fylla i ditt namn för att skapa ett konto";
                          }
                          return null;
                        },
                        onSaved: (value) => name = value,
                      ),
                       TextFormField(
                        enabled: snapshot.connectionState != ConnectionState.waiting,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Personnummer",
                          hintText: "Personummer",
                        ),
                        validator: (String? value) {
                          if(value == null || value.isEmpty) {
                            return "Du måste fylla i ditt personnummer för att skapa ett konto";
                          }
                          return null;
                        },
                        onSaved: (value) => personId = value,
                      ),
                      snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50), // Set minimum width and height
                          ),
                          onPressed: () async {
                            if(_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _loginHandler.value = Future.delayed(
                                const Duration(seconds: 2)
                              );
                                  
                              _loginHandler.value.whenComplete(() async {
                                var user = await createUser();
                                if(user != null) {
                                  var isLoggedIn = await loginUser();
                                  if(isLoggedIn) {
                                    widget.onLogin();
                                  }
                                }
                              });
                              
                            } 
                          },
                          child: const Text("Skapa konto")
                        ),
                        const Text("Har de redan ett konto?"),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              loginModeCreate = false;
                            });
                          },
                          child: const Text("Klicka hör för att logga in"),
                        ),
                        loginError
                        ? const Text("Inloggningen misslyckades!")
                        : const SizedBox.shrink()
                    ]
                  ),
                ),
              )

            : Form(
                key: _formKey,
                child: SizedBox(
                  width: 300,
                  child: Wrap(
                    runSpacing: 16,
                    children: [
                      const Text(
                        "Parkeringsappen",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const Text("Fyll i dina uppgifter för att logga in"),
                      TextFormField(
                        enabled: snapshot.connectionState != ConnectionState.waiting,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                          hintText: "Email",
                        ),
                        validator: (String? value) {
                          if(value == null || value.isEmpty) {
                            return "Du måste fylla i din email för att logga in";
                          }
                          return null;
                        },
                        onSaved: (value) => email = value,
                      ),
                      TextFormField(
                        obscureText: true,
                        enabled: snapshot.connectionState != ConnectionState.waiting,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          hintText: "Password",
                        ),
                        validator: (String? value) {
                          if(value == null || value.isEmpty) {
                            return "Du måste fylla i ditt lösenord för att logga in";
                          }
                          return null;
                        },
                        onSaved: (value) => pwd = value,
                      ),
                      snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50), // Set minimum width and height
                          ),
                          onPressed: () async {
                            if(_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _loginHandler.value = Future.delayed(
                                const Duration(seconds: 2)
                              );
                                  
                              _loginHandler.value.whenComplete(() async {
                                var isLoggedIn = await loginUser();
                                if(isLoggedIn) {
                                  widget.onLogin();
                                }
                              });
                              
                            } 
                          },
                          child: const Text("Logga in")
                        ),
                        const Text("Har du inget konto?"),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              loginModeCreate = true;
                            });
                          },
                          child: const Text("Klicka här för att skapa ett konto"),
                        ),
                        loginError
                        ? const Text("Inloggningen misslyckades!")
                        : const SizedBox.shrink()
                    ]
                  ),
                ),
              )

          );
        }
      );
      }
    );
  }
}