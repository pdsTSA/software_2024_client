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
  late String name;

  /// The frequency of the medication
  Frequency frequency = Frequency();

  bool verifyFields() {
    if (name.isEmpty) {
      return false;
    }
    if (!frequency.verifyFields()) {
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
  late List<int>? daysOfWeek;

  ///How many days between doses (optional)
  late int? daysBetween;

  bool verifyFields() {
    if (timeOfDay.isEmpty) {
      return false;
    }
    if (daysOfWeek == null && daysBetween == null) {
      return false;
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