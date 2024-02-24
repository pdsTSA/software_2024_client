import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsa_software_2024/data/data_manager.dart';

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
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text(parent.name!),
                  subtitle: const Text("Medication name"),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      widget.switchScreens(0);
                    },
                  ),
                ),
                ListTile(
                  title: Text(trimEnding(parent.frequency.timeOfDay
                      .fold("", (value, element) => value += "${element.format(context)}, "))),
                  subtitle: const Text("Times of day"),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      widget.switchScreens(1);
                    },
                  ),
                ),
                (parent.frequency.daysOfWeek != null) ? ListTile(
                  title: Text(trimEnding(parent.frequency.daysOfWeek!
                      .map((e) => widget.daysOfWeek[e])
                      .fold("", (previousValue, element) => previousValue += "$element, "))),
                  subtitle: const Text("Medication days"),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      widget.switchScreens(2);
                    },
                  ),
                ) : ListTile(
                  title: Text("Once every ${parent.frequency.daysBetween} days"),
                  subtitle: const Text("Medication interval"),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      widget.switchScreens(2);
                    },
                  ),
                ),
                ListTile(
                  title: Text((!parent.frequency.hasEndDate) ? "Never" : dateFormatter.format(parent.frequency.endDate!)),
                  subtitle: const Text("Medication end date"),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      widget.switchScreens(2);
                    },
                  ),
                ),
              ],
            ),
          )
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

