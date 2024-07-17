import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/path/url_path_constants.dart';
import 'package:mobile/core/init/network/network_error.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/account/model/account_model.dart';
import 'package:mobile/view/account/service/account_service_base.dart';

class AccountService extends AccountServiceBase{
  @override
  Future<UserResponseModel> getUser({
    BuildContext? context,
    String? token,
  }) async {
    UserResponseModel _responseModel = locator<UserResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      response = await dio.get(
        PathConstants.USER,
        options: Options(headers: header),
      );

      _responseModel = UserResponseModel.fromJson(response.data);
      return _responseModel;

    } on DioError catch (exception) {
      debugPrint(exception.response!.data.toString());
      NetworkError networkError =
          NetworkError.fromJson(exception.response!.data);
      _responseModel = locator<UserResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = networkError.message;
      return _responseModel;
    }
  }
}