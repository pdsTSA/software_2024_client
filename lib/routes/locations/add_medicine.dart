import 'package:flutter/material.dart';
import 'package:tsa_software_2024/data/data_manager.dart';
import 'package:tsa_software_2024/notification/notifier.dart';
import 'package:tsa_software_2024/routes/arguments/arguments.dart';
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
    final args = ModalRoute.of(context)!.settings.arguments as AddMedicineArguments?;

    if (args != null) {
      data = args.medicine;
    }

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
            (currentScreen == 0) ? MedicineNameView(data: data) : Container(),
            (currentScreen == 1) ? MedicineTimeView(data: data) : Container(),
            (currentScreen == 2) ? MedicineDatesView(data: data) : Container(),
            (currentScreen == 3) ? MedicineConfirmationView(data: data, switchScreens: navigateScreen, saveData: addMedication,) : Container()
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
    if (!data.verifyFields()) return;
    var appData = await getAppData();
    appData.addMedication(data);
    Notifier.schedule(data);
    Navigator.of(context).pop();
  }
}