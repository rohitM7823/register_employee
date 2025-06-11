
import 'package:flutter/material.dart';
import 'package:register_employee/routes/app_router.dart';

import '../../../../helpers/storage_helper.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkLogin();
    },);
  }

  Future<void> _checkLogin() async {
    final prefs = StorageHelper();
    String? token = await prefs.getAdminToken();
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, registerEmployee);
    } else {
      Navigator.pushReplacementNamed(context, login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
