class UserResponseModel {
  String? message;
  bool? isSuccess;
  UserModel? data;

  UserResponseModel({this.message, this.isSuccess, this.data});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isSuccess = json['isSuccess'];
    data = json['data'] != null ? UserModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['isSuccess'] = isSuccess;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserModel {
  String? email;
  bool? isActive;
  String? fullName;
  String? userType;

  UserModel({this.email, this.isActive, this.fullName, this.userType});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    isActive = json['is_active'];
    fullName = json['full_name'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['is_active'] = isActive;
    data['full_name'] = fullName;
    data['user_type'] = userType;
    return data;
  }
}
