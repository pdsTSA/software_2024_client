import 'package:flutter/material.dart';
import 'package:tsa_software_2024/data/data_manager.dart';
import 'package:tsa_software_2024/routes/tabs/medicine_tabs/medicine_name.dart';
import 'package:tsa_software_2024/routes/tabs/medicine_tabs/medicine_time.dart';

class AddMedicineRoute extends StatefulWidget {
  const AddMedicineRoute({super.key});

  @override
  State<StatefulWidget> createState() => AddMedicineRouteState();

  static AddMedicineRouteState? of(BuildContext context) {
    return context.findAncestorStateOfType<AddMedicineRouteState>();
  }
}

class AddMedicineRouteState extends State<AddMedicineRoute>{
  final Medication data = Medication();
  int currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (currentScreen == 0) {
              Navigator.pop(context);
            } else {
              setState(() {
                currentScreen = 0;
              });
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              setState(() {
                currentScreen++;
              });
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: IndexedStack(
          index: currentScreen,
          children: const [
            MedicineNameView(),
            MedicineTimeView(),
          ],
        ),
      )
    );
  }
}