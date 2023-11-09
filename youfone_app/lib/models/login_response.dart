class LoginResponse {
  String? message;
  int? resultCode;
  Object? object;

  LoginResponse({this.message, this.resultCode, this.object});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    resultCode = json['ResultCode'];
    object = json['Object'] != null ? new Object.fromJson(json['Object']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['ResultCode'] = this.resultCode;
    if (this.object != null) {
      data['Object'] = this.object!.toJson();
    }
    return data;
  }
}

class Object {
  Customer? customer;
  List<Customers>? customers;
  int? customersCount;

  Object({this.customer, this.customers, this.customersCount});

  Object.fromJson(Map<String, dynamic> json) {
    customer = json['Customer'] != null ? new Customer.fromJson(json['Customer']) : null;
    if (json['Customers'] != null) {
      customers = <Customers>[];
      json['Customers'].forEach((v) {
        customers!.add(new Customers.fromJson(v));
      });
    }
    customersCount = json['CustomersCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customer != null) {
      data['Customer'] = this.customer!.toJson();
    }
    if (this.customers != null) {
      data['Customers'] = this.customers!.map((v) => v.toJson()).toList();
    }
    data['CustomersCount'] = this.customersCount;
    return data;
  }
}

class Customer {
  int? customerNumber;
  String? email;
  String? firstName;
  Null? gender;
  int? id;
  String? initials;
  bool? isBusinessCustomer;
  String? language;
  String? lastName;
  String? phoneNumber;
  Null? prefix;
  int? roleId;

  Customer(
      {this.customerNumber,
      this.email,
      this.firstName,
      this.gender,
      this.id,
      this.initials,
      this.isBusinessCustomer,
      this.language,
      this.lastName,
      this.phoneNumber,
      this.prefix,
      this.roleId});

  Customer.fromJson(Map<String, dynamic> json) {
    customerNumber = json['CustomerNumber'];
    email = json['Email'];
    firstName = json['FirstName'];
    gender = json['Gender'];
    id = json['Id'];
    initials = json['Initials'];
    isBusinessCustomer = json['IsBusinessCustomer'];
    language = json['Language'];
    lastName = json['LastName'];
    phoneNumber = json['PhoneNumber'];
    prefix = json['Prefix'];
    roleId = json['RoleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerNumber'] = this.customerNumber;
    data['Email'] = this.email;
    data['FirstName'] = this.firstName;
    data['Gender'] = this.gender;
    data['Id'] = this.id;
    data['Initials'] = this.initials;
    data['IsBusinessCustomer'] = this.isBusinessCustomer;
    data['Language'] = this.language;
    data['LastName'] = this.lastName;
    data['PhoneNumber'] = this.phoneNumber;
    data['Prefix'] = this.prefix;
    data['RoleId'] = this.roleId;
    return data;
  }
}

class Customers {
  int? customerId;
  int? customerNumber;
  bool? isDefaultCustomer;
  int? msisdn;
  int? provisioningTypeId;
  int? roleId;

  Customers(
      {this.customerId,
      this.customerNumber,
      this.isDefaultCustomer,
      this.msisdn,
      this.provisioningTypeId,
      this.roleId});

  Customers.fromJson(Map<String, dynamic> json) {
    customerId = json['CustomerId'];
    customerNumber = json['CustomerNumber'];
    isDefaultCustomer = json['IsDefaultCustomer'];
    msisdn = json['Msisdn'];
    provisioningTypeId = json['ProvisioningTypeId'];
    roleId = json['RoleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerId'] = this.customerId;
    data['CustomerNumber'] = this.customerNumber;
    data['IsDefaultCustomer'] = this.isDefaultCustomer;
    data['Msisdn'] = this.msisdn;
    data['ProvisioningTypeId'] = this.provisioningTypeId;
    data['RoleId'] = this.roleId;
    return data;
  }
}
