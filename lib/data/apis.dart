import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:register_employee/core/commons/device_details.dart';
import 'package:register_employee/core/commons/secure_storage.dart';
import 'package:register_employee/features/attendance/domain/models/site_model.dart';

class Apis {
  static Future<bool> registerDeviceIfNot() async {
    if (await SecureStorage.instance.deviceIdentifier != null) return true;

    try {
      final deviceDetails = await DeviceDetails.instance.currentDetails;
      final response = await http.post(
          Uri.parse('http://192.168.0.5:8000/api/device/register'),
          headers: deviceDetails);
      if (response.statusCode == 200) {
        final deviceToken = json.decode(response.body)['device_token'];
        if (deviceToken == null) return false;
        await SecureStorage.instance.setDeviceIdentifier(deviceToken);
        return true;
      }
    } catch (ex) {
      log(ex.toString(), name: 'REGISTER_DEVICE_ISSUE');
      return false;
    }

    return false;
  }

  static Future<bool?> isDeviceApproved() async {
    try {
      String? deviceToken = await SecureStorage.instance.deviceIdentifier;
      final response = await http.get(
          Uri.parse('http://192.168.0.5:8000/api/device/status'),
          headers: {
            'platform': DeviceDetails.instance.platform,
            'device_token': deviceToken!,
          });
      if (response.statusCode == 200) {
        String? deviceStatus = json.decode(response.body)['status'];
        if (deviceStatus == null) return null;
        await SecureStorage.instance.setDeviceStatus(deviceStatus);
        return deviceStatus.toLowerCase() == 'approved';
      }
    } catch (ex) {
      log(ex.toString(), name: 'IS_DEVICE_APPROVED_ISSUE');
      return null;
    }
    return null;
  }

  static Future<bool?> registerEmployee(Map<String, dynamic> data) async {
    try {
      final response =
          await http.post(Uri.parse('http://192.168.0.5:8000/api/employee'),
              headers: {
                'platform': 'web',
              },
              body: data);
      return json.decode(response.body)['status'] as bool?;
    } catch (ex) {
      log(ex.toString(), name: 'REGISTER_EMPLOYEE_ISSUE');
      return false;
    }
  }

  static Future<List<Site>?> availableSties() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.0.5:8000/api/sites'), headers: {
        'platform': 'web',
      });
      return List.from(
          json.decode(response.body)['sites']!.map((e) => Site.fromJson(e)));
    } catch (ex) {
      log(ex.toString(), name: 'REGISTER_EMPLOYEE_ISSUE');
      return null;
    }
  }
}
