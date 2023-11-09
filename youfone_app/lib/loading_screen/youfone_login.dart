import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<bool> youfoneLogin(String username, String password) async {
  // TODO: Change URL to real Youfone login API URL.
  // For testing purposes a mock API is used, to prevent IP blocking.
  final loginUrl = Uri.parse('http://192.168.1.149:3000/login');
  final Map<String, dynamic> requestBody = {
    'request': {
      'Login': username,
      'Password': password,
    }
  };
  final response = await http.post(
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

  final responseBody = jsonDecode(response.body);
  if (responseBody is Map<String, dynamic> && responseBody.containsKey('ResultCode')) {
    if (responseBody['ResultCode'] == 0) {
      // Successful login, save credentials and security key.
      await saveCredentialsToSecureStorage(username, password);
      String securitykey = response.headers['securitykey']!;
      debugPrint('securitykey: $securitykey');
      return true; // Indicate a successful login.
    } else {
      return false; // Indicate an unsuccessful login.
    }
  } else {
    return false; // Indicate an unsuccessful login.
  }
}

Future<void> saveCredentialsToSecureStorage(String username, String password) async {
  const storage = FlutterSecureStorage();

  await storage.write(key: 'username', value: username);
  await storage.write(key: 'password', value: password);
}

Future<bool> youfoneLoginFromSecureStorage() async {
  // TODO: Implement this function to get the login credentials from secure storage when user has logged in before.
  return false;
}
