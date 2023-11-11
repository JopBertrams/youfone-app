import 'package:youfone_app/models/login_data.dart';
import 'package:youfone_app/models/msisdn_data.dart';

class Data {
  LoginResponse loginResponse;
  List<MsisdnResponse> msisdnResponses;

  Data({required this.loginResponse, required this.msisdnResponses});

  Data.fromJson(Map<String, dynamic> json)
      : loginResponse = LoginResponse.fromJson(json['loginResponse'] ?? {}),
        msisdnResponses = (json['msisdnResponses'] as List? ?? [])
            .map((v) => MsisdnResponse.fromJson(v))
            .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['loginResponse'] = loginResponse.toJson();
    data['msisdnResponses'] = msisdnResponses.map((v) => v.toJson()).toList();
    return data;
  }
}
