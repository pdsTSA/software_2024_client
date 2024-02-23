import 'package:flutter/material.dart';

class MedicineView extends StatefulWidget {
  const MedicineView({super.key});

  @override
  State<StatefulWidget> createState() => MedicineViewState();
}

class MedicineViewState extends State<MedicineView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(

      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, "/add_medicine");
          },
          label: const Text("Add Medicine"),
          icon: const Icon(Icons.add)
      ),
    );
  }
}