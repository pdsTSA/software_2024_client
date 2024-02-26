import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tsa_software_2024/notification/notifier.dart';
import 'package:tsa_software_2024/routes/locations/add_medicine.dart';
import 'package:tsa_software_2024/routes/locations/root.dart';

class SoftwareApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const SoftwareApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

    return MaterialApp(
      title: 'Software App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RootRoute(cameras: cameras, routeObserver: routeObserver,),
      routes: {
        "/root": (BuildContext context) => RootRoute(cameras: cameras, routeObserver: routeObserver),
        "/add_medicine": (BuildContext context) => AddMedicineRoute(),
      },
      navigatorObservers: [routeObserver],
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  Notifier.initialize();
  runApp(SoftwareApp(cameras: cameras));
}

