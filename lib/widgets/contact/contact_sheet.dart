import 'package:flutter/material.dart';
import 'package:tsa_software_2024/data/contacts/contacts.dart';
import 'package:tsa_software_2024/data/data_manager.dart';

class ContactBottomSheet extends StatefulWidget {
  final AppData? data;
  final MedicalContact contact;
  final Function reloadCallback;
  const ContactBottomSheet({super.key, required this.contact, required this.data, required this.reloadCallback});

  @override
  State<ContactBottomSheet> createState() => _ContactBottomSheetState();
}

class _ContactBottomSheetState extends State<ContactBottomSheet> {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var addressController = TextEditingController();
  int rebuildCount = 0;


  @override
  void dispose() {
    super.dispose();
    if (nameController.text.isNotEmpty) {
      widget.contact.name = nameController.text;
      widget.contact.phone = phoneController.text;
      widget.contact.email = emailController.text;
      widget.contact.address = addressController.text;
      print(nameController.text);
      widget.data!.addContact(widget.contact);
    }

    widget.reloadCallback();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null) return Container();
    print("rebuild");

    if (rebuildCount == 0) {
      nameController.text = widget.contact.name;
      phoneController.text = widget.contact.phone;
      emailController.text = widget.contact.email;
      addressController.text = widget.contact.address;
      rebuildCount++;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: nameController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              labelText: "Name",
            ),
          ),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: "Phone",
            ),
          ),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
            ),
          ),
          TextField(
            controller: addressController,
            keyboardType: TextInputType.streetAddress,
            decoration: const InputDecoration(
              labelText: "Address",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Save")
            )
          )
        ],
      ),
    );
  }
}
