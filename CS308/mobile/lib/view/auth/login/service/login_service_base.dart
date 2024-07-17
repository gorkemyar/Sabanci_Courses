import 'package:flutter/material.dart';
import 'package:mobile/view/auth/login/model/login_model.dart';

abstract class LoginServiceBase {
  Future<UserTokenModel> getUserToken({
    String email,
    String password,
    String language,
    BuildContext context,
  });
}
