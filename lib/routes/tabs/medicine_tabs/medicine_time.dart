import 'package:flutter/material.dart';
import 'package:tsa_software_2024/data/data_manager.dart';

class MedicineTimeView extends StatefulWidget {
  final Medication data;
  const MedicineTimeView({super.key, required this.data});

  @override
  State<MedicineTimeView> createState() => MedicineTimeViewState();
}

class MedicineTimeViewState extends State<MedicineTimeView> {
  List<TimeOfDay> times = [];

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
                children: widget.data.frequency.timeOfDay.map((time) {
                  return ListTile(
                    title: Text(time.format(context), style: const TextStyle(fontSize: 24)),
                    trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() {
                      widget.data.frequency.timeOfDay.remove(time);
                      times = widget.data.frequency.timeOfDay;
                    })),
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: time,
                      ).then((TimeOfDay? value) {
                        if (value != null) {
                          widget.data.frequency.timeOfDay[widget.data.frequency.timeOfDay.indexOf(time)] = value;
                          setState(() {
                            times = widget.data.frequency.timeOfDay;
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
              widget.data.frequency.timeOfDay.add(value);
              setState(() {
                times = widget.data.frequency.timeOfDay;
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
