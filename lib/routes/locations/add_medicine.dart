import 'package:flutter/material.dart';
import 'package:tsa_software_2024/data/data_manager.dart';
import 'package:tsa_software_2024/routes/tabs/medicine_tabs/medicine_confirmation.dart';
import 'package:tsa_software_2024/routes/tabs/medicine_tabs/medicine_dates.dart';
import 'package:tsa_software_2024/routes/tabs/medicine_tabs/medicine_name.dart';
import 'package:tsa_software_2024/routes/tabs/medicine_tabs/medicine_time.dart';

class AddMedicineRoute extends StatefulWidget {
  const AddMedicineRoute({super.key});

  @override
  State<StatefulWidget> createState() => AddMedicineRouteState();
}

class AddMedicineRouteState extends State<AddMedicineRoute>{
  Medication data = Medication();
  int currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (currentScreen == 0) {
              Navigator.pop(context);
            } else {
              setState(() {
                currentScreen--;
              });
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
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
          children: [
            MedicineNameView(data: data),
            MedicineTimeView(data: data),
            MedicineDatesView(data: data),
            MedicineConfirmationView(data: data, switchScreens: navigateScreen, saveData: addMedication,)
          ],
        ),
      )
    );
  }

  void navigateScreen(int tab) {
    setState(() {
      currentScreen = tab;
    });
  }

  void addMedication(BuildContext context) async {
    var appData = await getAppData();
    appData.medications.add(data);
    saveAppData(appData);
    Navigator.of(context).pop();
  }
}