import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsa_software_2024/data/medication/medication.dart';
import 'package:tsa_software_2024/widgets/medicine/medicine_overview.dart';

class MedicineConfirmationView extends StatefulWidget {
  final Medication data;
  final Function switchScreens;
  final Function saveData;
  final List<String> daysOfWeek = const ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

  const MedicineConfirmationView({super.key,
    required this.data,
    required this.switchScreens,
    required this.saveData
  });

  @override
  State<MedicineConfirmationView> createState() => _MedicineConfirmationViewState();
}

class _MedicineConfirmationViewState extends State<MedicineConfirmationView> {
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    var parent = widget.data;

    return Scaffold(
      body: Column(
        children: [
          const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Confirm Adding Medicine", style: TextStyle(fontSize: 32), textAlign: TextAlign.center),
                ],
              )
          ),
          MedicineOverview(parent: parent, switchScreens: widget.switchScreens),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget.saveData(context);
        },
        label: const Text("Confirm"),
        icon: const Icon(Icons.check),
      ),
    );
  }
  
  String trimEnding(String initial) {
    return initial.substring(0, initial.length - 2);
  }
}

