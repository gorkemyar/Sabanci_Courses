import 'package:flutter/material.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/constants/enums/locale_keys_enum.dart';
import 'package:mobile/core/init/cache/locale_manager.dart';
import 'package:mobile/core/init/network/log_inceptor.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/auth/register/model/register_model.dart';
import 'package:mobile/view/auth/register/service/register_service_base.dart';
import 'package:mobile/view/auth/register/service/register_service.dart';

class RegisterRepository with RegisterServiceBase{
  final _service = locator<RegisterService>();

  @override
  Future<RegisterModelResponse> setRegister({
    BuildContext? context,
    String? email,
    String? fullName,
    String? password,
  }) async {
    RegisterModelResponse _responseModel = await _service.setRegister(
      context: context,
      email: email,
      fullName: fullName,
      password: password,
    );
    return _responseModel;
  }
}