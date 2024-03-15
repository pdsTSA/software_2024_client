import 'package:tsa_software_2024/data/medication/medication.dart';

class AddMedicineArguments {
  final Medication medicine;
  int? screen;

  AddMedicineArguments({required this.medicine, this.screen});
}