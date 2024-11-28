import 'package:flutter/material.dart';
import 'package:parkingapp_admin/views/dashboard_view.dart';
import 'package:parkingapp_admin/views/parking_spaces_view.dart';
import 'package:parkingapp_admin/views/parkings_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  
  get destinations => const <NavigationRailDestination>[
    NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
    NavigationRailDestination(icon: Icon(Icons.list), label: Text('Parkings')),
    NavigationRailDestination(icon: Icon(Icons.list), label: Text('Parking spaces'))
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
      body: Row(
        children: [
          NavigationRail(
            destinations: destinations, 
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Container(
            child: views[_selectedIndex],
            alignment: Alignment.topLeft,
          )
        ],
      )
    );
  }
}