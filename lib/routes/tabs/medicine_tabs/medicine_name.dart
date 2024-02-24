import 'package:flutter/material.dart';
import 'package:tsa_software_2024/data/data_manager.dart';

class MedicineNameView extends StatefulWidget {
  final Medication data;
  const MedicineNameView({super.key, required this.data});

  @override
  State<MedicineNameView> createState() => _MedicineNameViewState();
}

class _MedicineNameViewState extends State<MedicineNameView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Medicine Name", style: TextStyle(fontSize: 32)),
              TextField(
                style: const TextStyle(fontSize: 24),
                onChanged: (String value) {
                  widget.data.name = value;
                },
              ),
            ],
          ),
        )
    );
  }
}

