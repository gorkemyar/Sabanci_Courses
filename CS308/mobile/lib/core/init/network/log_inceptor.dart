import 'package:mobile/core/constants/enums/locale_keys_enum.dart';
import 'package:mobile/core/init/cache/locale_manager.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/auth/login/repository/login_repository.dart';

Future<void> getUserToken() async {
  DateTime? expDate = DateTime.tryParse(
      LocaleManager.instance.getStringValue(PreferencesKeys.UT_EXP_DATE) ?? "");

  Duration duration = const Duration(minutes: 3600);

  if (expDate != null && -expDate.difference(DateTime.now()) >= duration) {
    await locator<LoginRepository>().getUserToken(
        email: LocaleManager.instance.getStringValue(PreferencesKeys.EMAIL),
        password:
            LocaleManager.instance.getStringValue(PreferencesKeys.PASSWORD));
  }
}
