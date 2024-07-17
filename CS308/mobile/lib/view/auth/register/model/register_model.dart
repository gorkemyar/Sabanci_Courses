class RegisterModelResponse {
  String? message;
  bool? isSuccess;
  List<RegisterModel>? data;

  RegisterModelResponse({this.message, this.isSuccess, this.data});

  RegisterModelResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isSuccess = json['isSuccess'];
    if (json['data'] != null) {
      data = <RegisterModel>[];
      json['data'].forEach((v) {
        data!.add(RegisterModel.fromJson(v));
      });
    }
  }
}

class RegisterModel {
  String? email;
  bool? isActive;
  String? fullName;
  String? password;

  RegisterModel({this.email, this.isActive, this.fullName, this.password});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    isActive = json['is_active'];
    fullName = json['full_name'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['is_active'] = this.isActive;
    data['full_name'] = this.fullName;
    data['password'] = this.password;
    return data;
  }
}
