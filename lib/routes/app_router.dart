import 'package:flutter/material.dart';
import 'package:register_employee/features/attendance/presentation/pages/admin_login.dart';
import 'package:register_employee/features/attendance/presentation/pages/entry_screen.dart';
import 'package:register_employee/features/attendance/presentation/pages/recognition_employee.dart';
import 'package:register_employee/features/attendance/presentation/pages/register_employee.dart';
import 'package:register_employee/main.dart';

const String login = '/login';
const String faceRecognition = '/face_recognition_page';
const String registerEmployee = '/register_employee';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case registerEmployee:
      return MaterialPageRoute(
        builder: (_) => const RegisterEmployeePage(),
        maintainState: true,
      );
    case faceRecognition:
      return MaterialPageRoute(
          builder: (_) =>
              FaceRecognitionScreen(camera: cameraDescriptions.last));
    case login:
      return MaterialPageRoute(
        builder: (context) => const AdminLoginScreen(),
      );
    default:
      return MaterialPageRoute(builder: (_) => const EntryScreen());
  }
}
