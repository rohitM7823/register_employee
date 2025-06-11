import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:register_employee/core/commons/device_details.dart';
import 'package:register_employee/helpers/storage_helper.dart';
import 'package:register_employee/routes/app_router.dart';

List<CameraDescription> cameraDescriptions = [];

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  await initialization();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

Future<void> initialization() async {
  try {
    await StorageHelper.init();
    cameraDescriptions = await availableCameras();
    await DeviceDetails.instance.init();
  } catch (Ex) {
    log(Ex.toString(), name: 'INITIALIZATION');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialRoute});

  final String? initialRoute;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: generateRoute,
      initialRoute: widget.initialRoute,
    );
  }
}
