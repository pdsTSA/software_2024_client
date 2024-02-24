import 'package:flutter/material.dart';

class AppData {
  List<Medication> medications = [];

  void addMedication(Medication medication) {
    medications.add(medication);
    saveAppData(this);
  }
}

class Medication {
  Medication();

  /// The name of the medication
  String? name;

  /// The frequency of the medication
  Frequency frequency = Frequency();

  bool verifyFields() {
    if (name == null || name!.isEmpty) {
      print("name uninitialized");
      return false;
    }
    if (!frequency.verifyFields()) {
      print("frequency error");
      return false;
    }
    return true;
  }
}

///Supply either a time of day, days of the week, or days between doses
class Frequency {
  Frequency();

  ///Hour of the day to take it
  List<TimeOfDay> timeOfDay = [];

  ///Days of the week to take it (optional)
  List<int>? daysOfWeek;

  ///How many days between doses (optional)
  int? daysBetween;

  DateTime? endDate;
  bool hasEndDate = false;

  bool verifyFields() {
    if (timeOfDay.isEmpty) {
      print("no time of day");
      return false;
    }
    if (daysOfWeek == null && daysBetween == null) {
      print("no interval");
      return false;
    }
    if (endDate == null) {
      if (hasEndDate) {
        print("end date not set");
        return false;
      }
    }
    return true;
  }
}

Future<AppData> getAppData() async {
  return AppData();
}

void saveAppData(AppData appData) async {
  //TODO: save app data
}