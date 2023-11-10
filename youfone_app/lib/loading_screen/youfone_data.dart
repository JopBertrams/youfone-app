import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<bool> securitykeyExpired() async {
  // Check if the security key in secure storage is older than 1 hour.
  const storage = FlutterSecureStorage();

  String? securitykeyUtc = await storage.read(key: 'securitykey_utc');

  if (securitykeyUtc == null) {
    return true;
  } else {
    DateTime securitykeyUtcDateTime = DateTime.parse(securitykeyUtc);
    DateTime dateTimeNow = DateTime.now().toUtc();
    Duration difference = dateTimeNow.difference(securitykeyUtcDateTime);
    if (difference.inHours >= 1) {
      await storage.delete(key: 'securitykey');
      await storage.delete(key: 'securitykey_utc');
      return true;
    } else {
      return false;
    }
  }
}
