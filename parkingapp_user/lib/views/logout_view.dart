import 'package:flutter/material.dart';

class LogoutView extends StatelessWidget {
  const LogoutView({super.key, required this.onLogout});

  final Function onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
            onPressed: (()=> {
              onLogout
            }),
            child: const Text("Logga ut")),
        )
    );
  }
}