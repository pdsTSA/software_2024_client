import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'data_manager.g.dart';

var uuidgen = const Uuid();

@JsonSerializable()
class AppData {
  AppData();
  List<Medication> medications = [];

  void addMedication(Medication medication) {
    medications.removeWhere((element) => element.uuid == medication.uuid);
    medications.add(medication);
    saveAppData(this);
  }

  factory AppData.fromJson(Map<String, dynamic> json) => _$AppDataFromJson(json);
  Map<String, dynamic> toJson() => _$AppDataToJson(this);
}

@JsonSerializable()
class Medication {
  Medication();

  /// UUID for the medication
  String uuid = uuidgen.v4();

  /// The name of the medication
  String? name;

  /// Whether the medication is enabled or not
  bool enabled = true;

  /// The frequency of the medication
  Frequency frequency = Frequency();

  bool verifyFields() {
    if (name == null || name!.isEmpty) {
      print("name uninitialized");
      return false;
    }
    return true;
  }

  factory Medication.fromJson(Map<String, dynamic> json) => _$MedicationFromJson(json);
  Map<String, dynamic> toJson() => _$MedicationToJson(this);
}

///Supply either a time of day, days of the week, or days between doses
@JsonSerializable()
class Frequency {
  Frequency();

  ///Hour of the day to take it
  List<MedicationTime> timesOfDay = [];

  ///Days of the week to take it (optional)
  List<int>? daysOfWeek;

  ///How many days between doses (optional)
  int? daysBetween;

  DateTime? startDate;

  DateTime? endDate;
  bool hasEndDate = false;

  MedicationTime getEarliestTime() {
    if (timesOfDay.isEmpty) {
      return MedicationTime();
    }
    var earliest = timesOfDay[0];
    for (var time in timesOfDay) {
      if (time.hour < earliest.hour) {
        earliest = time;
      } else if (time.hour == earliest.hour && time.minute < earliest.minute) {
        earliest = time;
      }
    }
    return earliest;
  }

  MedicationTime getLatestTime() {
    if (timesOfDay.isEmpty) {
      return MedicationTime();
    }
    var latest = timesOfDay[0];
    for (var time in timesOfDay) {
      if (time.hour > latest.hour) {
        latest = time;
      } else if (time.hour == latest.hour && time.minute > latest.minute) {
        latest = time;
      }
    }
    return latest;
  }

  int _daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Duration? nextDuration(DateTime startTime) {
    DateTime now = startTime;
    if (hasEndDate && now.isAfter(endDate!)) {
      return null;
    }
    if (now.isBefore(startDate!)) {
      return null;
    }
    DateTime next = now.copyWith();

    if (daysBetween != null) {
      //interval repeat mode
      var daysSince = _daysBetween(startDate!, now);
      if (daysSince % daysBetween! == 0) {
        next = now;
      } else {
        next = now.add(Duration(days: daysBetween! - (daysSince % daysBetween!)));
      }
    } else if (daysOfWeek != null) {
      //weekday repeat mode
      for (var i = 0; i < 7; i++) {
        if (daysOfWeek!.contains((now.weekday + i) % 7)) {
          next = now.add(Duration(days: i));
          next = DateTime(next.year, next.month, next.day, 0, 0);
          break;
        }
      }
    }

    //set to earliest time
    for (final e in timesOfDay) {
      next = DateTime(next.year, next.month, next.day, e.hour, e.minute);
      if (next.isAfter(now)) {
        return next.difference(now);
      }
    }

    return null;
  }

  factory Frequency.fromJson(Map<String, dynamic> json) => _$FrequencyFromJson(json);
  Map<String, dynamic> toJson() => _$FrequencyToJson(this);
}

@JsonSerializable()
class MedicationTime {
  int hour = 0;
  int minute = 0;

  MedicationTime({TimeOfDay? time}) {
    if (time != null){
      hour = time.hour;
      minute = time.minute;
    }
  }

  TimeOfDay toTime() {
    return TimeOfDay(hour: hour, minute: minute);
  }

  factory MedicationTime.fromJson(Map<String, dynamic> json) => _$MedicationTimeFromJson(json);
  Map<String, dynamic> toJson() => _$MedicationTimeToJson(this);
}

Future<AppData> getAppData() async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory.path);
  try {
    var file = File("${directory.path}/app.data");
    if (!await file.exists()) {
      var data = AppData();
      saveAppData(data);
      return data;
    }
    final json = await file.readAsString();
    return AppData.fromJson(jsonDecode(json) as Map<String, dynamic>);
  } catch (e) {
    print("could not open appdata");
    print(e);
    return AppData();
  }
}

void saveAppData(AppData appData) async {
  final directory = await getApplicationDocumentsDirectory();
  try {
    var file = File("${directory.path}/app.data");
    file.writeAsString(jsonEncode(appData.toJson()));
  } catch (e) {
    print("could not save appdata");
    print(e);
  }
}