import 'dart:async';
import 'dart:convert';
import '../storage.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

// TODO: Change URL to real Youfone login API URL.
// For testing purposes a mock API is used, to prevent IP blocking.
Uri youfoneLoginUrl = Uri.parse('http://192.168.1.149:3000/login');
final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5)));

Future<bool?> youfoneLogin(String username, String password) async {
  try {
    Response response = await httpResponse(httpRequestBody(username, password), youfoneLoginUrl);
    return processLoginResponse(response, username, password);
  } catch (_) {
    return null;
  }
}

Future<bool?> youfoneLoginFromSecureStorage() async {
  String? username = await storageRead(key: 'username');
  String? password = await storageRead(key: 'password');

  if (username == null || password == null) {
    return false;
  }

  try {
    final response = await httpResponse(httpRequestBody(username, password), youfoneLoginUrl);
    return processLoginResponse(response, username, password);
  } catch (_) {
    return null;
  }
}

Map<String, dynamic> httpRequestBody(String username, String password) {
  return {
    'request': {
      'Login': username,
      'Password': password,
    }
  };
}

Future<Response> httpResponse(Map<String, dynamic> requestBody, Uri loginUrl) async {
  try {
    final options = Options(headers: {
      'Content-Type': 'application/json',
      'Origin': 'https://my.youfone.nl',
      'Referer': 'https://my.youfone.nl/login',
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36'
    });
    final response = await dio.postUri(loginUrl, data: requestBody, options: options);
    return response;
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      Fluttertoast.showToast(
          msg: 'Kon geen verbinding maken met Youfone, probeer het later opnieuw.',
          toastLength: Toast.LENGTH_LONG);
    }
    rethrow;
  }
}

Future<bool> processLoginResponse(Response response, String username, String password) async {
  Map<String, dynamic> responseBody = response.data;
  bool loginSuccessful = false;

  if (responseBody.containsKey('ResultCode')) {
    if (responseBody['ResultCode'] == 0) {
      // Save credentials and security key.
      String securitykey = response.headers.value('securitykey')!;
      await saveToSecureStorage(username, password, responseBody, securitykey);
      loginSuccessful = true; // Indicate a successful login.
    }
  }

  return loginSuccessful;
}

Future<void> saveToSecureStorage(
    String username, String password, Map<String, dynamic> responseBody, String securitykey) async {
  DateTime dateTimeNow = DateTime.now().toUtc();

  await storageWrite(key: 'username', value: username);
  await storageWrite(key: 'password', value: password);

  await storageWrite(key: 'loginResponse', value: jsonEncode(responseBody));

  await storageWrite(key: 'securitykey', value: securitykey);
  await storageWrite(key: 'securitykey_utc', value: dateTimeNow.toString());
}
