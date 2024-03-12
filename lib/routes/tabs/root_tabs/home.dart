import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tsa_software_2024/data/http/http_response.dart';
import 'package:tsa_software_2024/data/medication/medication.dart';
import 'package:tsa_software_2024/routes/arguments/arguments.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [

            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            final XFile? file =
                await _picker.pickImage(source: ImageSource.camera);

            if (file == null) return;

            var request = http.MultipartRequest(
                "POST", Uri.parse("https://phqsh.tech/drug"));
            var picture = await http.MultipartFile.fromPath("image", file.path);
            request.files.add(picture);

            showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (context) => FutureBuilder<http.StreamedResponse>(
                    future: request.send(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          !snapshot.hasError) {
                        print("done");
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: MedicationSheet(
                              future: snapshot.data!.stream.toBytes()),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        print("waiting");
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        print("error");
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Padding(
                            padding: EdgeInsets.all(60),
                            child: Text(
                              "Medication not found",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        );
                      }
                    }));
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}

class MedicationSheet extends StatefulWidget {
  final Future<Uint8List> future;

  const MedicationSheet({super.key, required this.future});

  @override
  State<MedicationSheet> createState() => _MedicationSheetState();
}

class _MedicationSheetState extends State<MedicationSheet> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
        future: widget.future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            try {
              var json = jsonDecode(utf8.decode(snapshot.data!));
              OCRResponse response = OCRResponse.fromJson(json);

              return Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(12),
                      child: Expanded(
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async => await launchUrlString(
                                  "https://www.drugs.com/mtm/${response.medication}.html"),
                              child: Text(
                                response.medication,
                                style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            IconButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, "/add_medicine",
                                    arguments: AddMedicineArguments(
                                        medicine: Medication())),
                                icon: const Icon(Icons.add))
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Used to treat ${response.condition}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.network(response.imageUrl)),
                ],
              );
            } catch (e) {
              return const Padding(
                padding: EdgeInsets.all(60),
                child: Text(
                  "Medication not found",
                  style: TextStyle(fontSize: 24),
                ),
              );
            }
          } else {
            return Container();
          }
        });
  }
}
