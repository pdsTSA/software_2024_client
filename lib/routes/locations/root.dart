import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tsa_software_2024/routes/tabs/root_tabs/about.dart';
import 'package:tsa_software_2024/routes/tabs/root_tabs/calendar.dart';
import 'package:tsa_software_2024/routes/tabs/root_tabs/contact.dart';
import 'package:tsa_software_2024/routes/tabs/root_tabs/home.dart';
import 'package:tsa_software_2024/routes/tabs/root_tabs/medicine.dart';

class RootRoute extends StatefulWidget {
  final RouteObserver<ModalRoute> routeObserver;

  const RootRoute({super.key, required this.routeObserver});

  @override
  RootRouteState createState() => RootRouteState();
}

class RootRouteState extends State<RootRoute> {
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            setState(() {
              currentIndex = 2;
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
                  icon: Icon(Icons.perm_phone_msg),
                  label: "Contacts"
              ),
              NavigationDestination(
                  icon: Icon(Icons.medication),
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
              NavigationDestination(
                  icon: Icon(Icons.question_mark),
                  label: "About"
              )
            ],
          ),
          body: IndexedStack(
            index: currentIndex,
            children: [
              (currentIndex == 0) ? ContactView() : Container(),
              (currentIndex == 1) ? MedicineView(routeObserver: widget.routeObserver) : Container(),
              (currentIndex == 2) ? HomeView() : Container(),
              (currentIndex == 3) ? CalendarView() : Container(),
              (currentIndex == 4) ? AboutView() : Container(),
            ],
          ),
        )
    );
  }
}