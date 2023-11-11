class LoginResponse {
  String message;
  int resultCode;
  Object object;

  LoginResponse({required this.message, required this.resultCode, required this.object});

  LoginResponse.fromJson(Map<String, dynamic> json)
      : message = json['Message'] ?? '',
        resultCode = json['ResultCode'] ?? 0,
        object = json['Object'] != null
            ? Object.fromJson(json['Object'])
            : Object(
                customer: Customer(
                  customerNumber: 0,
                  email: '',
                  firstName: '',
                  gender: '',
                  id: 0,
                  initials: '',
                  isBusinessCustomer: false,
                  language: '',
                  lastName: '',
                  phoneNumber: '',
                  prefix: '',
                  roleId: 0,
                ),
                customers: [],
                customersCount: 0,
              );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Message'] = message;
    data['ResultCode'] = resultCode;
    data['Object'] = object.toJson();
    return data;
  }
}

class Object {
  Customer customer;
  List<Customers> customers;
  int customersCount;

  Object({required this.customer, required this.customers, required this.customersCount});

  Object.fromJson(Map<String, dynamic> json)
      : customer = json['Customer'] != null
            ? Customer.fromJson(json['Customer'])
            : Customer(
                customerNumber: 0,
                email: '',
                firstName: '',
                gender: '',
                id: 0,
                initials: '',
                isBusinessCustomer: false,
                language: '',
                lastName: '',
                phoneNumber: '',
                prefix: '',
                roleId: 0,
              ),
        customers = (json['Customers'] as List? ?? []).map((v) => Customers.fromJson(v)).toList(),
        customersCount = json['CustomersCount'] ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Customer'] = customer.toJson();
    data['Customers'] = customers.map((v) => v.toJson()).toList();
    data['CustomersCount'] = customersCount;
    return data;
  }
}

class Customer {
  int customerNumber;
  String email;
  String firstName;
  String? gender;
  int id;
  String initials;
  bool isBusinessCustomer;
  String language;
  String lastName;
  String phoneNumber;
  String? prefix;
  int roleId;

  Customer({
    required this.customerNumber,
    required this.email,
    required this.firstName,
    required this.gender,
    required this.id,
    required this.initials,
    required this.isBusinessCustomer,
    required this.language,
    required this.lastName,
    required this.phoneNumber,
    required this.prefix,
    required this.roleId,
  });

  Customer.fromJson(Map<String, dynamic> json)
      : customerNumber = json['CustomerNumber'] ?? 0,
        email = json['Email'] ?? '',
        firstName = json['FirstName'] ?? '',
        gender = json['Gender'] ?? '',
        id = json['Id'] ?? 0,
        initials = json['Initials'] ?? '',
        isBusinessCustomer = json['IsBusinessCustomer'] ?? false,
        language = json['Language'] ?? '',
        lastName = json['LastName'] ?? '',
        phoneNumber = json['PhoneNumber'] ?? '',
        prefix = json['Prefix'] ?? '',
        roleId = json['RoleId'] ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CustomerNumber'] = customerNumber;
    data['Email'] = email;
    data['FirstName'] = firstName;
    data['Gender'] = gender;
    data['Id'] = id;
    data['Initials'] = initials;
    data['IsBusinessCustomer'] = isBusinessCustomer;
    data['Language'] = language;
    data['LastName'] = lastName;
    data['PhoneNumber'] = phoneNumber;
    data['Prefix'] = prefix;
    data['RoleId'] = roleId;
    return data;
  }
}

class Customers {
  int customerId;
  int customerNumber;
  bool isDefaultCustomer;
  int msisdn;
  int provisioningTypeId;
  int roleId;

  Customers({
    required this.customerId,
    required this.customerNumber,
    required this.isDefaultCustomer,
    required this.msisdn,
    required this.provisioningTypeId,
    required this.roleId,
  });

  Customers.fromJson(Map<String, dynamic> json)
      : customerId = json['CustomerId'] ?? 0,
        customerNumber = json['CustomerNumber'] ?? 0,
        isDefaultCustomer = json['IsDefaultCustomer'] ?? false,
        msisdn = json['Msisdn'] ?? 0,
        provisioningTypeId = json['ProvisioningTypeId'] ?? 0,
        roleId = json['RoleId'] ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CustomerId'] = customerId;
    data['CustomerNumber'] = customerNumber;
    data['IsDefaultCustomer'] = isDefaultCustomer;
    data['Msisdn'] = msisdn;
    data['ProvisioningTypeId'] = provisioningTypeId;
    data['RoleId'] = roleId;
    return data;
  }
}
