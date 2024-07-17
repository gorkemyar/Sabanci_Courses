import 'package:flutter/material.dart';
import 'package:mobile/core/constants/enums/locale_keys_enum.dart';
import 'package:mobile/core/init/cache/locale_manager.dart';
import 'package:mobile/core/init/network/log_inceptor.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/account/model/account_model.dart';
import 'package:mobile/view/account/service/account_service.dart';
import 'package:mobile/view/account/service/account_service_base.dart';

class AccountRepository extends AccountServiceBase {
  final _service = locator<AccountService>();

  @override
  Future<UserResponseModel> getUser({
    BuildContext? context,
    String? token,
  }) async {
    await getUserToken();
    var token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)!;

    UserResponseModel _responseModel = await _service.getUser(
      context: context,
      token: token,
    );
    return _responseModel;
  }
}
