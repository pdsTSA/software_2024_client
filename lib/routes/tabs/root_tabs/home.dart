import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tsa_software_2024/data/http/http_response.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeView extends StatefulWidget {
  final CameraDescription camera;

  const HomeView({super.key, required this.camera});

  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: CameraPreview(_controller),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            //TODO: add logic for pill identification
            var request = http.MultipartRequest("POST", Uri.parse("https://phqsh.tech/drug"));
            var picture = await http.MultipartFile.fromPath("image", image.path);
            request.files.add(picture);

            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (context) => FutureBuilder<http.StreamedResponse>(
                future: request.send(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && !snapshot.hasError) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: MedicationSheet(future: snapshot.data!.stream.toBytes()),
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Center(child: CircularProgressIndicator(),),
                    );
                  } else {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Padding(
                        padding: EdgeInsets.all(60),
                        child: Text("Medication not found", style: TextStyle(fontSize: 24),),
                      ),
                    );
                  }
                }
              )
            );
          } catch (e) {
            print(e);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                  child: InkWell(
                    onTap: () async => await launchUrlString("https://www.drugs.com/mtm/${response.medication}.html"),
                    child: Text(response.medication, style: const TextStyle(fontSize: 24, color: Colors.blue, decoration: TextDecoration.underline),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text("Used to treat ${response.condition}", style: const TextStyle(fontSize: 16),),
                ),
                Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.network(response.imageUrl)
                ),
              ],
            );
          } catch (e) {
            return const Padding(
              padding: EdgeInsets.all(60),
              child: Text("Medication not found", style: TextStyle(fontSize: 24),),
            );
          }
        } else {
          return Container();
        }
      }
    );
  }
}
