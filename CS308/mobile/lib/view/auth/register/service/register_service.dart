import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/path/url_path_constants.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/auth/register/model/register_model.dart';
import 'package:mobile/view/auth/register/service/register_service_base.dart';

class RegisterService with RegisterServiceBase{
@override
Future<RegisterModelResponse> setRegister({
  BuildContext? context,
  String? email,
  String? fullName,
  String? password,
}) async {
  RegisterModelResponse _responseModel = locator<RegisterModelResponse>();
  try {
    Response response;
    Dio dio = Dio();

    var header = {
      'Content-Type': 'application/json',
    };

    response = await dio.post(
      PathConstants.REGISTER,
      data: RegisterModel(
        email: email,
        fullName: fullName,
        password: password,
      ).toJson(),
      options: Options(headers: header),
    );

    _responseModel = RegisterModelResponse.fromJson(response.data);
    return _responseModel;
  } on DioError catch (exception) {
    debugPrint("Error");
    debugPrint(exception.response!.data);
    _responseModel = locator<RegisterModelResponse>();
    _responseModel.isSuccess = false;
    return _responseModel;
  }
}

}
