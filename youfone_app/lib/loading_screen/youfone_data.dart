import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import '../models/data.dart';
import '../models/login_data.dart';
import '../models/msisdn_data.dart';
import '../storage.dart';

final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5)));

Future<bool> securitykeyExpired() async {
  // Check if the security key in secure storage is older than 1 hour.
  String? securitykeyUtc = await storageRead(key: 'securitykey_utc');

  if (securitykeyUtc == null) {
    return true;
  } else {
    DateTime securitykeyUtcDateTime = DateTime.parse(securitykeyUtc);
    DateTime dateTimeNow = DateTime.now().toUtc();
    Duration difference = dateTimeNow.difference(securitykeyUtcDateTime);
    if (difference.inHours >= 1) {
      await storageDelete(key: 'securitykey');
      await storageDelete(key: 'securitykey_utc');
      await storageDelete(key: 'loginResponse');
      return true;
    } else {
      return false;
    }
  }
}

Future<Data> getYoufoneData() async {
  String? loginResponseString = await storageRead(key: 'loginResponse');
  LoginResponse loginResponse = LoginResponse.fromJson(jsonDecode(loginResponseString!));
  List<MsisdnResponse> msisdnResponses = await _getMsisdnData(loginResponse);

  Data data = Data(
    loginResponse: loginResponse,
    msisdnResponses: msisdnResponses,
  );

  return data;
}

Future<List<MsisdnResponse>> _getMsisdnData(LoginResponse loginResponse) async {
  // TODO: Change URL to real Youfone login API URL.
  // For testing purposes a mock API is used, to prevent IP blocking.
  Uri youfoneDataUrl = Uri.parse('http://192.168.1.149:3000/data');

  String? securitykey = await storageRead(key: 'securitykey');

  // Msisdn is the phone number of the user.
  List<MsisdnResponse> allMsisdnResponses = [];

  for (Customers customer in loginResponse.object.customers) {
    try {
      Map<String, dynamic> requestBody = {
        'request': {
          'Msisdn': customer.msisdn,
        }
      };

      final response = await dio.postUri(youfoneDataUrl,
          data: requestBody,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Origin': 'https://my.youfone.nl',
            'Referer': 'https://my.youfone.nl/',
            'securitykey': securitykey!,
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36'
          }));

      MsisdnResponse msisdnResponse = MsisdnResponse.fromJson(response.data);
      allMsisdnResponses.add(msisdnResponse);

      // 1 second delay to prevent overloading the Youfone API.
      await Future.delayed(const Duration(seconds: 1));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        Fluttertoast.showToast(
            msg: 'Kon geen verbinding maken met Youfone, probeer het later opnieuw.',
            toastLength: Toast.LENGTH_LONG);
      } else {
        Fluttertoast.showToast(
            msg: 'Er is een fout opgetreden, probeer het later opnieuw.',
            toastLength: Toast.LENGTH_LONG);
      }
      rethrow;
    }
  }

  return allMsisdnResponses;
}
