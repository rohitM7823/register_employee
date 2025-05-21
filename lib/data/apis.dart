import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:register_employee/core/commons/device_details.dart';
import 'package:register_employee/core/commons/secure_storage.dart';
import 'package:register_employee/features/attendance/domain/models/site_model.dart';

import '../features/attendance/domain/models/shift_model.dart';

class Apis {
  
  static const BASE_URL = 'http://192.168.0.5:8000/api';

  static Future<String?> login(String userId, String password) async {
    try {
      final response = await http.post(Uri.parse('$BASE_URL/admin/login'),
          body: {'admin_id': userId, 'password': password});

      if (response.statusCode == 200) {
        return json.decode(response.body)['token'] as String?;
      }
      return null;
    } catch (ex) {
      rethrow;
    }
  }

  static Future<bool> logout(String token) async {
    try {
      final response = await http.post(Uri.parse('$BASE_URL/admin/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });
      log('${response.statusCode}', name: 'LOGOUT');
      return response.statusCode == 200;
    } catch (ex) {
      rethrow;
    }
  }

  static Future<bool> forgotPassword(String adminId, String newPassword) async {
    try {
      final response =
      await http.post(Uri.parse('$BASE_URL/admin/forgot-password'), body: {
        'admin_id': adminId,
        'new_password': newPassword
      });

      log(response.body.toString(), name: 'FORGOT_PASSWORD');
      return response.statusCode == 200;
    } catch (ex) {
      rethrow;
    }
  }
  
  static Future<bool> registerDeviceIfNot() async {
    if (await SecureStorage.instance.deviceIdentifier != null) return true;

    try {
      final deviceDetails = await DeviceDetails.instance.currentDetails;
      final response = await http.post(
          Uri.parse('$BASE_URL/device/register'),
          headers: deviceDetails);
      log('${response.body}', name: 'REGISTER_DEVICE');
      if (response.statusCode == 200) {
        final deviceToken = json.decode(response.body)['device_token'];
        if (deviceToken == null) return false;
        await SecureStorage.instance.setDeviceIdentifier(deviceToken);
        return true;
      }
      return false;
    } catch (ex) {
      log(ex.toString(), name: 'REGISTER_DEVICE_ISSUE');
      return false;
    }

    //return false;
  }

  static Future<bool?> isDeviceApproved() async {
    try {
      String? deviceToken = await SecureStorage.instance.deviceIdentifier;
      final response = await http.get(
          Uri.parse('$BASE_URL/device/status'),
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
          await http.post(Uri.parse('$BASE_URL/employee'),
              headers: {
                'platform': 'web',
                'Content-Type': 'application/json'
              },
              body: jsonEncode(data));
      return json.decode(response.body)['status'] as bool?;
    } catch (ex) {
      log(ex.toString(), name: 'REGISTER_EMPLOYEE_ISSUE_OR');
      return false;
    }
  }

  static Future<List<Site>?> availableSties() async {
    try {
      final response = await http.get(Uri.parse('$BASE_URL/sites'), headers: {
        'platform': DeviceDetails.instance.platform,
      });
      return List.from(
          json.decode(response.body)['sites']!.map((e) => Site.fromJson(e)));
    } catch (ex) {
      log(ex.toString(), name: 'AVAILABLE_STIES_ISSUE');
      return null;
    }
  }

  static Future<List<Shift>?> shifts() async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/shifts'),
      );
      if (response.statusCode == 200) {
        return List<Shift>.from(json
            .decode(response.body)['shifts']!
            .map((e) => Shift.fromJson(e)));
      }
      return null;
    } catch (ex) {
      log(ex.toString(), name: 'SHIFTS_ISSUE');
      return null;
    }
  }
}
