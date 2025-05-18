import 'package:get_storage/get_storage.dart';

class StorageHelper {
  static GetStorage? _storage;

  static Future<bool> init() async {
    return await GetStorage.init();
  }

  static GetStorage get storage {
    _storage ??= GetStorage();
    return _storage!;
  }

  Future<String?> getAdminToken() async {
    return storage.read<String?>('secure_admin_token');
  }

  Future<void> setAdminToken(String token) async {
    await storage.write('secure_admin_token', token);
  }

  Future<void> clearToken() async {
    return await storage.remove('secure_admin_token');
  }
}
