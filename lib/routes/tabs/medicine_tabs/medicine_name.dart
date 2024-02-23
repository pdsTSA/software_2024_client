import 'package:flutter/material.dart';
import 'package:tsa_software_2024/routes/locations/add_medicine.dart';

class MedicineNameView extends StatelessWidget {
  const MedicineNameView({super.key});


  //TODO: rather than having so much empty space here, we should
  // have a description of the medicine (scraped) like you would see
  // after taking a picture
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
              decoration: const InputDecoration(
                labelText: "Medicine Name",
              ),
              onSubmitted: (String value) {
                AddMedicineRoute.of(context)!.data.name = value;
              },
            ),
          ],
        ),
      )
    );
  }
}
