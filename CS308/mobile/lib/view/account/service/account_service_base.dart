import 'package:flutter/material.dart';
import 'package:mobile/view/account/model/account_model.dart';

abstract class AccountServiceBase {
  Future<UserResponseModel> getUser({
    BuildContext context,
    String token,
  });
}
