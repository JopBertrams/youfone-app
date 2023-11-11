import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();

Future<String?> storageRead({required String key}) async {
  String? val = await _storage.read(key: key);
  return val;
}

Future<void> storageWrite({required String key, required String value}) async {
  await _storage.write(key: key, value: value);
}

Future<void> storageDelete({required String key}) async {
  await _storage.delete(key: key);
}

Future<void> storageDeleteAll() async {
  await _storage.deleteAll();
}
