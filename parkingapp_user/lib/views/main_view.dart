import 'package:flutter/material.dart';
import 'package:parkingapp_user/repositories/person_repository.dart';
import 'package:parkingapp_user/views/account_view.dart';
import 'package:parkingapp_user/views/vehicles_view.dart';
import 'package:parkingapp_user/views/parkings_view.dart';
import 'package:shared/models/person.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  final ValueNotifier<Future> _loginFuture = ValueNotifier(Future.value());
  final loginFormKey = GlobalKey<FormState>();
  bool isLoggedIn = false;

  late String? name;
  late String? personId;
  late String? email;
  late String? pwd;
  late bool loginModeCreate = false;
  late bool loginError = false;

  late Person? person;

  Future<bool> loginUser () async {
    bool loginSuccess = false;
    loginError = false;
    try {
      debugPrint("Email: $email");
      person = await PersonRepository().getByEmail(email!);
      debugPrint(person!.email);
      if(person != null) {
        loginSuccess = true;
      }
    } catch(err) {
      loginError = true;
    }
    return loginSuccess;
  }

  Future<Person?> createUser () async {
    //Person? person;
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


  get destinations => const <NavigationDestination>[
    NavigationDestination(icon: Icon(Icons.local_parking), label:"Parkeringar"),
    NavigationDestination(icon: Icon(Icons.fire_truck), label:"Fordon"),
    NavigationDestination(icon: Icon(Icons.person), label:"Konto"),
    NavigationDestination(icon: Icon(Icons.logout), label: "Logga ut")
  ];

  int _selectedIndex = 0;

  Widget gotoView(int index) {
    if(index == 0) {
      return const ParkingsView();
    } else if(index == 1) {
      return VehiclesView(user: person!);
    } else if(index == 2) {
      return AccountView(user: person!);
    }
    setState(() {
      isLoggedIn = false;
    });
    return const SizedBox.shrink();
  }

  onSelectedIndex(int index) {
    if(index == 3) {
      setState(() {
        isLoggedIn = false;
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: 
        isLoggedIn 
        ? Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Parkeringsappen",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              Expanded(
                child: gotoView(_selectedIndex)
              ),
              NavigationBar(
                destinations: destinations, 
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index) {
                 onSelectedIndex(index);
                },
              ),
            ],
          ),
        )
        : loginForm(context)
      )
    );
  }

  Widget loginForm(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _loginFuture,
      builder: (context, value, _) {
      return FutureBuilder(
        future: value,
        builder: (context, snapshot) {
         return Center(
            widthFactor: 300,
            child: 
            
            loginModeCreate
            
            ? Form(
                key: loginFormKey,
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
                            if(loginFormKey.currentState!.validate()) {
                              loginFormKey.currentState!.save();
                              _loginFuture.value = Future.delayed(
                                const Duration(seconds: 2)
                              );
                                  
                              _loginFuture.value.whenComplete(() async {
                                var user = await createUser();
                                if(user != null) {
                                  var userIsLoggedIn = await loginUser();
                                  if(userIsLoggedIn) {
                                    setState(() {
                                      isLoggedIn = true;
                                    });
                                    //if(context.mounted) {
                                    //  Navigator.of(context).pop();
                                    //}
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
                          child: const Text("Klicka här för att logga in"),
                        ),
                        loginError
                        ? const Text("Inloggningen misslyckades!")
                        : const SizedBox.shrink()
                    ]
                  ),
                ),
              )

            : Form(
                key: loginFormKey,
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
                            if(loginFormKey.currentState!.validate()) {
                              loginFormKey.currentState!.save();
                              _loginFuture.value = Future.delayed(
                                const Duration(seconds: 2)
                              );
                                  
                              _loginFuture.value.whenComplete(() async {
                                var userIsLoggedIn = await loginUser();
                                if(userIsLoggedIn) {
                                  setState(() {
                                    isLoggedIn = true;
                                  });
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

/*
class UserService {
  Future<Person?> getLoggedInUser() async {
    Person? user = await PersonRepository().getByEmail();
    return user;
  } 
}

final userProvider = Provider<UserService>(
  create: (_) => UserService(),
  child: const AccountView()
);
*/
/*
Container(
          child: Form(
            key: loginFormKey,
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
        )


 */