import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsa_software_2024/data/data_manager.dart';
import 'package:weekday_selector/weekday_selector.dart';

class MedicineDatesView extends StatefulWidget {
  final Medication data;
  const MedicineDatesView({super.key, required this.data});

  @override
  State<MedicineDatesView> createState() => _MedicineDatesViewState();
}

class _MedicineDatesViewState extends State<MedicineDatesView> {
  var repeatMode = RepeatMode.interval;
  final weekdays = List.filled(7, false);
  var daysBetween = 0;
  var hasEndDate = false;
  var endDate = DateTime.now();

  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

  void updateData() {
    switch(repeatMode) {
      case RepeatMode.weekday:
        widget.data.frequency.daysOfWeek = weekdays.asMap()
            .map((key, value) => MapEntry(key, (value) ? key : -1))
            .values
            .where((e) => e != -1)
            .toList();
        widget.data.frequency.daysBetween = null;
      case RepeatMode.interval:
        widget.data.frequency.daysBetween = daysBetween;
        widget.data.frequency.daysOfWeek = null;
    }

    widget.data.frequency.hasEndDate = hasEndDate;
    if (hasEndDate) {
      widget.data.frequency.endDate = endDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text("Medicine Dates", style: TextStyle(fontSize: 32), textAlign: TextAlign.center),
                  Text("Indicate what dates you're scheduled to take the medication", style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
                ],
              )
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                    child: ListTile(
                      title: const Text("Interval", style: TextStyle(fontSize: 16)),
                      leading: Radio<RepeatMode>(
                        value: RepeatMode.interval,
                        groupValue: repeatMode,
                        onChanged: (value) => {
                          setState(() {
                            repeatMode = value!;
                            updateData();
                          })
                        },
                      ),
                    )
                ),
                Expanded(
                    child: ListTile(
                      title: const Text("Weekday", style: TextStyle(fontSize: 16)),
                      leading: Radio<RepeatMode>(
                        value: RepeatMode.weekday,
                        groupValue: repeatMode,
                        onChanged: (value) => {
                          setState(() {
                            repeatMode = value!;
                            updateData();
                          })
                        },
                      ),
                    )
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: (repeatMode == RepeatMode.weekday) ?
            WeekdaySelector(
              onChanged: (int day) => {
                setState(() {
                  weekdays[day % 7] = !weekdays[day % 7];
                  updateData();
                })
              },
              values: weekdays,
              shortWeekdays: const [
                "Sun",
                "Mon",
                "Tue",
                "Wed",
                "Thu",
                "Fri",
                "Sat"
              ],
            ) : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Repeat every ", style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 32,
                  child: TextField(
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      daysBetween = int.parse(value);
                    },
                  ),
                ),
                const Text(" days", style: TextStyle(fontSize: 16))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text("Has End Date"),
                    leading: Checkbox(
                      value: hasEndDate,
                      onChanged: (e) => {
                        setState(() {
                          hasEndDate = e!;
                          updateData();
                        })
                      },
                    ),
                  )
                ),
                Container(
                  child: (hasEndDate) ? OutlinedButton(
                    onPressed: () async {
                      var date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.utc(2100)
                      );

                      setState(() {
                        if (date != null) {
                          endDate = date;
                          updateData();
                        }
                      });
                    },
                    child: Text(dateFormatter.format(endDate)),
                  ) : Container()
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

enum RepeatMode {
  weekday,
  interval
}
