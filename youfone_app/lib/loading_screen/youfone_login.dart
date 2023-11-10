import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// TODO: Change URL to real Youfone login API URL.
// For testing purposes a mock API is used, to prevent IP blocking.
Uri youfoneLoginUrl = Uri.parse('http://192.168.1.149:3000/login');

Future<Map<String, dynamic>> youfoneLogin(String username, String password) async {
  final response = await httpResponse(httpRequestBody(username, password), youfoneLoginUrl);
  return processLoginResponse(response, username, password);
}

Future<Map<String, dynamic>> youfoneLoginFromSecureStorage() async {
  const storage = FlutterSecureStorage();
  String? username = await storage.read(key: 'username');
  String? password = await storage.read(key: 'password');

  if (username == null || password == null) {
    return {'loginSuccessful': false}; // Indicate an unsuccessful login.
  }

  final response = await httpResponse(httpRequestBody(username, password), youfoneLoginUrl);
  return processLoginResponse(response, username, password);
}

Map<String, dynamic> httpRequestBody(String username, String password) {
  return {
    'request': {
      'Login': username,
      'Password': password,
    }
  };
}

Future<http.Response> httpResponse(Map<String, dynamic> requestBody, Uri loginUrl) async {
  return await http.post(
    loginUrl,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Origin': 'https://my.youfone.nl',
      'Referer': 'https://my.youfone.nl/login',
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36'
    },
    body: jsonEncode(requestBody),
  );
}

Future<Map<String, dynamic>> processLoginResponse(
    http.Response response, String username, String password) async {
  final responseBody = jsonDecode(response.body);
  bool loginSuccessful = false;

  if (responseBody is Map<String, dynamic> && responseBody.containsKey('ResultCode')) {
    if (responseBody['ResultCode'] == 0) {
      // Save credentials and security key.
      await saveCredentialsToSecureStorage(username, password);
      String securitykey = response.headers['securitykey']!;
      await saveSecurityKeyToSecureStorage(securitykey);
      loginSuccessful = true; // Indicate a successful login.
    }
  }

  return {
    'loginSuccessful': loginSuccessful,
    'responseBody': responseBody,
  };
}

Future<void> saveCredentialsToSecureStorage(String username, String password) async {
  const storage = FlutterSecureStorage();

  await storage.write(key: 'username', value: username);
  await storage.write(key: 'password', value: password);
}

Future<void> saveSecurityKeyToSecureStorage(String securitykey) async {
  const storage = FlutterSecureStorage();
  DateTime dateTimeNow = DateTime.now().toUtc();

  await storage.write(key: 'securitykey', value: securitykey);
  await storage.write(key: 'securitykey_utc', value: dateTimeNow.toString());
}
