import 'package:flutter/material.dart';
import 'package:register_employee/features/attendance/presentation/pages/device_not_registered.dart';
import 'package:register_employee/features/attendance/presentation/pages/recognition_employee.dart';
import 'package:register_employee/features/attendance/presentation/pages/register_employee.dart';
import 'package:register_employee/main.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (_) => const RegisterEmployeePage(),
        maintainState: true,
      );
    case '/face_recognition_page':
      return MaterialPageRoute(
          builder: (_) =>
              FaceRecognitionScreen(camera: cameraDescriptions.last));
    case '/not_registered':
      return MaterialPageRoute(
        builder: (context) => const DeviceNotRegistered(),
      );
    default:
      return MaterialPageRoute(builder: (_) => const RegisterEmployeePage());
  }
}
