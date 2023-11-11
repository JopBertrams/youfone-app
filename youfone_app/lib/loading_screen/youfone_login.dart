import 'dart:convert';
import '../storage.dart';
import 'package:http/http.dart' as http;

// TODO: Change URL to real Youfone login API URL.
// For testing purposes a mock API is used, to prevent IP blocking.
Uri youfoneLoginUrl = Uri.parse('http://192.168.1.149:3000/login');

Future<bool> youfoneLogin(String username, String password) async {
  final response = await httpResponse(httpRequestBody(username, password), youfoneLoginUrl);
  return processLoginResponse(response, username, password);
}

Future<bool> youfoneLoginFromSecureStorage() async {
  String? username = await storageRead(key: 'username');
  String? password = await storageRead(key: 'password');

  if (username == null || password == null) {
    return false;
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

Future<bool> processLoginResponse(http.Response response, String username, String password) async {
  final responseBody = jsonDecode(response.body);
  bool loginSuccessful = false;

  if (responseBody is Map<String, dynamic> && responseBody.containsKey('ResultCode')) {
    if (responseBody['ResultCode'] == 0) {
      // Save credentials and security key.
      String securitykey = response.headers['securitykey']!;
      await saveToSecureStorage(username, password, response.body, securitykey);
      loginSuccessful = true; // Indicate a successful login.
    }
  }

  return loginSuccessful;
}

Future<void> saveToSecureStorage(
    String username, String password, String responseBody, String securitykey) async {
  DateTime dateTimeNow = DateTime.now().toUtc();

  await storageWrite(key: 'username', value: username);
  await storageWrite(key: 'password', value: password);

  await storageWrite(key: 'loginResponse', value: responseBody);

  await storageWrite(key: 'securitykey', value: securitykey);
  await storageWrite(key: 'securitykey_utc', value: dateTimeNow.toString());
}
