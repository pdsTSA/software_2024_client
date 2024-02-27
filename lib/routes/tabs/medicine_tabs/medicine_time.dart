import 'package:flutter/material.dart';
import 'package:tsa_software_2024/data/medication/medication.dart';

class MedicineTimeView extends StatefulWidget {
  final Medication data;
  const MedicineTimeView({super.key, required this.data});

  @override
  State<MedicineTimeView> createState() => MedicineTimeViewState();
}

class MedicineTimeViewState extends State<MedicineTimeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text("Medicine Times", style: TextStyle(fontSize: 32), textAlign: TextAlign.center),
                Text("Add the times of day you're scheduled to take the medication", style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
              ],
            )
          ),
          Expanded(
              child: ListView(
                children: widget.data.frequency.timesOfDay.map((time) {
                  return ListTile(
                    title: Text(time.toTime().format(context), style: const TextStyle(fontSize: 24)),
                    trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() {
                      widget.data.frequency.timesOfDay.remove(time);
                    })),
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: time.toTime(),
                      ).then((TimeOfDay? value) {
                        if (value != null) {
                          setState(() {
                            widget.data.frequency.timesOfDay[widget.data.frequency.timesOfDay.indexOf(time)] = MedicationTime(time: value);
                          });
                        }
                      });
                    },
                  );
                }).toList()
              )
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          ).then((TimeOfDay? value) {
            if (value != null) {
              setState(() {
                widget.data.frequency.timesOfDay.add(MedicationTime(time: value));
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
