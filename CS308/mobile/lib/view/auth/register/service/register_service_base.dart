import 'package:flutter/material.dart';
import 'package:mobile/view/auth/register/model/register_model.dart';

abstract class RegisterServiceBase{
  Future<RegisterModelResponse> setRegister({
    BuildContext context,
    String email,
    String fullName,
    String password,
  });
}
