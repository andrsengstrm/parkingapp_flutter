import 'package:flutter/material.dart';
import 'package:parkingapp_user/views/dashboard_view.dart';
import 'package:parkingapp_user/views/parking_spaces_view.dart';
import 'package:parkingapp_user/views/parkings_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  
  get destinations => const <NavigationDestination>[
    NavigationDestination(icon: Icon(Icons.dashboard), label:"Start"),
    NavigationDestination(icon: Icon(Icons.list), label:"Parkeringar"),
    NavigationDestination(icon: Icon(Icons.list), label:"Parkeringsplatser")
  ];

  int _selectedIndex = 0;

  var views = const [
    DashboardView(),
    ParkingsView(),
    ParkingSpacesView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: views[_selectedIndex]
          ),
          NavigationBar(
            destinations: destinations, 
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ],
      )
    );
  }
}