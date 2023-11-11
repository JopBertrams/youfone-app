class MsisdnResponse {
  String? message;
  int? resultCode;
  List<Object>? object;

  MsisdnResponse({this.message, this.resultCode, this.object});

  MsisdnResponse.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    resultCode = json['ResultCode'];
    if (json['Object'] != null) {
      object = <Object>[];
      json['Object'].forEach((v) {
        object!.add(Object.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Message'] = message;
    data['ResultCode'] = resultCode;
    if (object != null) {
      data['Object'] = object!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Object {
  List<Properties>? properties;
  int? sectionId;

  Object({this.properties, this.sectionId});

  Object.fromJson(Map<String, dynamic> json) {
    if (json['Properties'] != null) {
      properties = <Properties>[];
      json['Properties'].forEach((v) {
        properties!.add(Properties.fromJson(v));
      });
    }
    sectionId = json['SectionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (properties != null) {
      data['Properties'] = properties!.map((v) => v.toJson()).toList();
    }
    data['SectionId'] = sectionId;
    return data;
  }
}

class Properties {
  String? key;
  String? value;

  Properties({this.key, this.value});

  Properties.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Key'] = key;
    data['Value'] = value;
    return data;
  }
}
