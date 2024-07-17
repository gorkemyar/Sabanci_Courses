import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/path/url_path_constants.dart';
import 'package:mobile/core/init/network/network_error.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/auth/login/model/login_model.dart';
import 'package:mobile/view/auth/login/service/login_service_base.dart';

class LoginService with LoginServiceBase {
  @override
  Future<UserTokenModel> getUserToken({
    String? email,
    String? password,
    String? language,
    BuildContext? context,
  }) async {
    UserTokenModel _tokenResponse = locator<UserTokenModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      var data = {
        'username': email,
        'password': password,
      };

      response = await dio.post(
        PathConstants.LOGIN,
        data: data,
        options: Options(headers: header),
      );
      debugPrint(response.data.toString());
      _tokenResponse = UserTokenModel(
        message: "Successfull Login",
        isSuccess: true,
        data: Data.fromJson(response.data),
      );
      debugPrint(_tokenResponse.isSuccess.toString());
      return _tokenResponse;
    } on DioError catch (exception) {
      NetworkError networkError =
          NetworkError.fromJson(exception.response!.data);
      _tokenResponse = locator<UserTokenModel>();
      _tokenResponse.isSuccess = false;
      _tokenResponse.message = networkError.message;
      return _tokenResponse;
    }
  }
}
