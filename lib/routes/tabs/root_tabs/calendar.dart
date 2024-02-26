import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tsa_software_2024/data/data_manager.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<StatefulWidget> createState() => CalendarViewState();
}

class CalendarViewState extends State<CalendarView> {
  var firstDay = DateTime.utc(2024, 1, 1);
  var lastDay = DateTime.utc(2100);
  var focusedDay = DateTime.now();
  var calendarFormat = CalendarFormat.month;

  List<CalendarEvent> dailyMedications = [];

  Future<List<CalendarEvent>> generateDailyMedications(DateTime day) async {
    var appData = await getAppData();
    var medications = appData.medications;
    var currentTime = day;
    var events = <CalendarEvent>[];

    for (var medication in medications) {
      var nextDate = currentTime;
      while (nextDate.day == currentTime.day) {
        var nextDuration = medication.frequency.nextDuration(nextDate);
        nextDate = nextDate.add(nextDuration ?? const Duration(days: 1));

        if (nextDate.day == day.day) {
          events.add(CalendarEvent(
              title: medication.name!, time: TimeOfDay.fromDateTime(nextDate)));
        }
      }
    }

    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          firstDay: firstDay,
          lastDay: lastDay,
          focusedDay: focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(focusedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) async {
            var newDailyMedications = await generateDailyMedications(DateTime(
                focusedDay.year, focusedDay.month, focusedDay.day, 0, 0));
            setState(() {
              this.focusedDay = focusedDay;
              dailyMedications = newDailyMedications;
            });
          },
          calendarFormat: calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              calendarFormat = format;
            });
          },
        ),
      ),
      Expanded(
          child: ListView.builder(
        itemCount: dailyMedications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dailyMedications[index].title),
            subtitle: Text(dailyMedications[index].time.format(context)),
          );
        },
      )),
    ]));
  }
}

class CalendarEvent {
  final String title;
  final TimeOfDay time;

  const CalendarEvent({required this.title, required this.time});
}
