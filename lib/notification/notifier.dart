import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tsa_software_2024/data/config/globals.dart';
import 'package:tsa_software_2024/data/data_manager.dart';
import 'package:tsa_software_2024/data/medication/medication.dart';
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
      await schedule(medication);
    }
    saveAppData(appData);
  }

  static Future<void> schedule(Medication medication) async {
    await Workmanager().cancelByUniqueName(medication.uuid);

    if (medication.enabled) {
      var nextDuration = medication.frequency.nextDuration(DateTime.now());

      if (nextDuration != null) {
        await Workmanager().registerOneOffTask(
          medication.uuid,
          medication.uuid,
          initialDelay: nextDuration,
          constraints: Constraints(
            networkType: NetworkType.connected,
          ),
        );
      }
    }
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
    Notifier.notify("pillmate", "Time to take ${medication.name!}!", "Notification scheduled by $APP_NAME");
    await Notifier.schedule(medication);
    appData.medications[index] = medication;
    saveAppData(appData);

    return Future.value(true);
  });
}
