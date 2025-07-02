import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tsa_software_2024/data/config/globals.dart';
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
  ImagePicker? _picker;

  Future<void> getLostData() async {
    _picker = ImagePicker();
    final LostDataResponse response = await _picker!.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    final List<XFile>? files = response.files;
    if (files != null) {
      showMedication(files[0].path);
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getLostData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: const [
              Center(
                child: Image(
                  image: AssetImage("images/icon.png"),
                  width: 128,
                ),
              ),
              Text(
                APP_NAME,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 48),
              ),
              SizedBox(height: 20),
              Text(
                "Quickly figure out what your medication does and remind yourself to take it with $APP_NAME!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                "To get started, click on the camera icon below.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            final XFile? file = await _picker!
                .pickImage(source: ImageSource.camera, imageQuality: 20);

            if (file == null) return;

            await showMedication(file.path);
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }

  Future showMedication(String filepath) async {
    var request =
        http.MultipartRequest("POST", Uri.parse("https://phqsh.tech/drug"));
    var picture = await http.MultipartFile.fromPath("image", filepath);
    request.files.add(picture);

    showModalBottomSheet(
        context: context,
        showDragHandle: false,
        enableDrag: false,
        builder: (context) => FutureBuilder<http.StreamedResponse>(
            future: request.send(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasError) {
                print("done");
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child:
                      MedicationSheet(future: snapshot.data!.stream.toBytes()),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
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
              print("deserializing data");
              var utf = utf8.decode(snapshot.data!);
              var json = jsonDecode(utf);
              print(json);
              OCRResponse response = OCRResponse.fromJson(json);
              print("loaded data structure");

              return Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return Flex(
                              direction: Axis.horizontal,
                              children: [
                                Flexible(
                                  child: Wrap(
                                    alignment: WrapAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () async => await launchUrlString(
                                            "https://www.drugs.com/mtm/${response.drug.split(" ")[0].split("/")[0]}.html"),
                                        child: Text(
                                          response.drug,
                                          style: const TextStyle(
                                              fontSize: 36,
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            var medicine = Medication();
                                            medicine.name = response.drug;

                                            Navigator.pushNamed(
                                                context, "/add_medicine",
                                                arguments: AddMedicineArguments(
                                                    medicine: medicine));
                                          },
                                          icon: const Icon(
                                              Icons.add_circle_outline))
                                    ],
                                  ),
                                )
                              ],
                            );
                          case 1:
                            return Text(
                              "Used to treat ${response.condition}",
                              style: const TextStyle(fontSize: 24),
                            );
                          case 2:
                            return Image.network(response.image);
                          default:
                            return Container();
                        }
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                      itemCount: 3));
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
            return const CircularProgressIndicator();
          }
        });
  }
}
