import 'package:flutter/material.dart';
import 'package:tsa_software_2024/data/contacts/contacts.dart';
import 'package:tsa_software_2024/data/data_manager.dart';
import 'package:tsa_software_2024/widgets/contact/contact_sheet.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  var dirty = false;
  var future = getAppData();
  AppData? appData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<AppData>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            appData = snapshot.data;
            return ListView(
              children: appData!.contacts.asMap().map((key, value) =>
                MapEntry(key, ListTile(
                  title: Text(value.name),
                  subtitle: Text(value.phone),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      builder: (context) {
                        return ContactBottomSheet(
                          contact: value,
                          data: appData!,
                          reloadCallback: _reload,
                        );
                      }
                    );
                  },
                  trailing: Wrap(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            appData!.contacts.removeAt(key);
                            saveAppData(appData!);
                            _reload();
                          }
                      ),
                      IconButton(
                          icon: const Icon(Icons.phone),
                          onPressed: () async {
                            await launchUrlString("tel:${value.phone}");
                          }
                      ),
                      IconButton(
                          icon: const Icon(Icons.email),
                          onPressed: () async {
                            await launchUrlString("mailto:${value.email}");
                          }
                      ),
                    ],
                  )
                ))
              ).values.toList()
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (context) {
                return ContactBottomSheet(
                  contact: MedicalContact(
                      name: '',
                      phone: '',
                      email: '',
                      address: ''
                  ),
                  data: appData!,
                  reloadCallback: _reload,
                );
              }
          );
        },
        label: const Text("Add Contact"),
        icon: const Icon(Icons.add),
      )
    );
  }

  void _reload() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        future = getAppData();
      });
    });
  }
}

