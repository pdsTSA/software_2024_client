import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tsa_software_2024/routes/tabs/root_tabs/calendar.dart';
import 'package:tsa_software_2024/routes/tabs/root_tabs/home.dart';
import 'package:tsa_software_2024/routes/tabs/root_tabs/medicine.dart';

class RootRoute extends StatefulWidget {
  final List<CameraDescription> cameras;

  const RootRoute({super.key, required this.cameras});

  @override
  RootRouteState createState() => RootRouteState();
}

class RootRouteState extends State<RootRoute> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            setState(() {
              currentIndex = 1;
            });
          }
        },
        child: Scaffold(
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.list_alt),
                  label: "Medicine"
              ),
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_today),
                label: 'Calendar',
              ),
            ],
          ),
          body: IndexedStack(
            index: currentIndex,
            children: [
              (currentIndex == 0) ? MedicineView() : Container(),
              (currentIndex == 1) ? HomeView(camera: widget.cameras.first) : Container(),
              (currentIndex == 2) ? CalendarView() : Container(),
            ],
          ),
        )
    );
  }
}