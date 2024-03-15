import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsa_software_2024/data/medication/medication.dart';

class MedicineOverview extends StatelessWidget {
  final Medication parent;
  final List<String> daysOfWeek = const ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  final Function? switchScreens;

  MedicineOverview({super.key, required this.parent, this.switchScreens});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text(parent.name!),
          subtitle: const Text("Medication name"),
          trailing: (switchScreens != null) ? IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              switchScreens!(0);
            },
          ) : null,
        ),
        ListTile(
          title: Text(trimEnding(parent.frequency.timesOfDay
              .fold("", (value, element) =>
          value += "${element.toTime().format(context)}, "))),
          subtitle: const Text("Times of day"),
          trailing: (switchScreens != null) ? IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              switchScreens!(1);
            },
          ) : null,
        ),
        (parent.frequency.daysOfWeek != null) ? ListTile(
          title: Text(trimEnding(parent.frequency.daysOfWeek!
              .map((e) => daysOfWeek[e])
              .fold("", (previousValue, element) =>
          previousValue += "$element, "))),
          subtitle: const Text("Medication days"),
          trailing: (switchScreens != null) ? IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              switchScreens!(2);
            },
          ) : null,
        ) : ListTile(
          title: Text("Once every ${parent.frequency.daysBetween} days"),
          subtitle: const Text("Medication interval"),
          trailing: (switchScreens != null) ? IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              switchScreens!(2);
            },
          ) : null,
        ),
        ListTile(
          title: Text(
              (!parent.frequency.hasEndDate) ? "Never" : dateFormatter.format(
                  parent.frequency.endDate!)),
          subtitle: const Text("Medication end date"),
          trailing: (switchScreens != null) ? IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              switchScreens!(2);
            },
          ) : null,
        ),
      ],
    );
  }

  String trimEnding(String initial) {
    return initial.substring(0, initial.length - 2);
  }
}
