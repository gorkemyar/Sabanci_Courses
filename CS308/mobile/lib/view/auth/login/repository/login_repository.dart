import 'package:flutter/material.dart';
import 'package:mobile/core/constants/enums/locale_keys_enum.dart';
import 'package:mobile/core/init/cache/locale_manager.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/auth/login/model/login_model.dart';
import 'package:mobile/view/auth/login/service/login_service.dart';
import 'package:mobile/view/auth/login/service/login_service_base.dart';

class LoginRepository with LoginServiceBase {
  final _service = locator<LoginService>();

  @override
  Future<UserTokenModel> getUserToken({
    String? email,
    String? password,
    String? language,
    BuildContext? context,
  }) async {
    UserTokenModel _tokenResponse = await _service.getUserToken(
      email: email,
      password: password,
      context: context,
    );
    if (_tokenResponse.isSuccess ?? false) {
      await LocaleManager.instance.setStringValue(
          PreferencesKeys.TOKEN, _tokenResponse.data!.accessToken!);

      await LocaleManager.instance.setStringValue(
          PreferencesKeys.UT_EXP_DATE, DateTime.now().toIso8601String());

      await LocaleManager.instance
          .setBoolValue(PreferencesKeys.IS_LOGINED, true);

      await LocaleManager.instance
          .setStringValue(PreferencesKeys.EMAIL, email!);

      await LocaleManager.instance
          .setStringValue(PreferencesKeys.PASSWORD, password!);
    } else {
      await LocaleManager.instance.removeValue(PreferencesKeys.TOKEN);
      await LocaleManager.instance.removeValue(PreferencesKeys.UT_EXP_DATE);
      await LocaleManager.instance.removeValue(PreferencesKeys.IS_LOGINED);
      await LocaleManager.instance.removeValue(PreferencesKeys.EMAIL);
      await LocaleManager.instance.removeValue(PreferencesKeys.PASSWORD);
    }

    return _tokenResponse;
  }
}
