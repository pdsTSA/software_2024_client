import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tsa_software_2024/data/data_manager.dart';
import 'package:workmanager/workmanager.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class Notifier {
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true
    );

    scheduleAll();
  }

  static void notify(String channel, String title, String message) async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(channel, 'pillmate-notifications',
        channelDescription: 'Notifications for the Pillmate app',
        importance: Importance.max,
        priority: Priority.high,
        ticker: '');
    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        Random().nextInt(0x7FFFFFFF), title, message, notificationDetails);
  }

  static void scheduleAll() async {
    await Workmanager().cancelAll();

    final appData = await getAppData();
    for (var medication in appData.medications) {
      schedule(medication);
    }
  }

  static void schedule(Medication medication) async {
    await Workmanager().cancelByUniqueName(medication.uuid);

    if (medication.enabled) {
      await Workmanager().registerOneOffTask(
        medication.uuid,
        medication.uuid,
        initialDelay: _frequencyToDuration(medication.frequency, DateTime.now()),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    }
  }


  //TODO: write tests for this. I have no idea if it works
  static Duration _frequencyToDuration(Frequency frequency, DateTime startTime) {
    DateTime now = startTime;
    DateTime next = DateTime.now();

    var latestTime = frequency.getLatestTime();

    //check if its today or not
    if (now.hour > latestTime.hour && now.minute > latestTime.minute) {
      if (frequency.daysBetween != null) {
        //interval repeat mode
        var lastDay = DateTime.fromMillisecondsSinceEpoch(frequency.lastDay);
        lastDay = DateTime(lastDay.year, lastDay.month, lastDay.day, 0, 0);

        next = lastDay.add(Duration(days: frequency.daysBetween!));
        if (next.isBefore(now)) {
          next = DateTime(now.year, now.month, now.day, latestTime.hour, latestTime.minute);
          next = next.add(Duration(days: frequency.daysBetween!));
        }
        next = DateTime(next.year, next.month, next.day, 0, 0);
      } else if (frequency.daysOfWeek != null) {
        //weekday repeat mode
        for (var i = 1; i < 8; i++) {
          if (frequency.daysOfWeek!.contains((now.weekday + i) % 7)) {
            next = now.add(Duration(days: i));
            next = DateTime(next.year, next.month, next.day, 0, 0);
            break;
          }
        }
      }
    }

    //set to earliest time
    for (final e in frequency.timesOfDay) {
      next = DateTime(next.year, next.month, next.day, e.hour, e.minute);
      if (next.isAfter(now)) {
        return next.difference(now);
      }
    }

    throw Exception("No time found");
  }

  static Future<void> onDidReceiveNotificationResponse(NotificationResponse response) async {
    print("Notification received");
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    var appData = await getAppData();

    //notify
    var index = appData.medications.indexWhere((element) => element.uuid == task);
    if (index == -1) {
      return Future.value(false);
    }

    var medication = appData.medications[index];
    //TODO: improve this message
    Notifier.notify("pillmate", "Take your medication", medication.name!);

    medication.frequency.lastDay = DateTime.now().millisecondsSinceEpoch;
    appData.medications[index] = medication;
    Notifier.schedule(medication);
    saveAppData(appData);

    return Future.value(true);
  });
}
