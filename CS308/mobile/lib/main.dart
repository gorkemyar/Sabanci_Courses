import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/constants/enums/locale_keys_enum.dart';
import 'package:mobile/core/init/cache/locale_manager.dart';
import 'package:mobile/core/init/lang/language_manager.dart';
import 'package:mobile/core/init/navigation/navigation_route.dart';
import 'package:mobile/core/init/navigation/navigation_service.dart';
import 'package:mobile/core/init/network/log_inceptor.dart';
import 'package:mobile/core/init/theme/app_theme.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/core/init/theme/light_theme.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/core/widgets/bottombar_view.dart';
import 'dart:io';

Future<void> main() async {
  await _init();

  try {
    final result = await InternetAddress.lookup('164.92.208.145');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      runApp(EasyLocalization(
        child: const MyApp(),
        supportedLocales: LanguageManager.instance.supportedLocales,
        path: ApplicationConstants.LANG_ASSET_PATH,
      ));
    }
  } on SocketException catch (_) {
    runApp(const NoInt());
  }
}

class NoInt extends StatelessWidget {
  const NoInt({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemeLight.instance.theme,
      home: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'No Internet Connection',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Voidture requires internet connection to run\n           Please check your connection.",
                  style: TextStyle(
                    color: AppColors.tertiary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: OutlinedButton(
                onPressed: () async {
                  try {
                    final result = await InternetAddress.lookup('google.com');
                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                      runApp(EasyLocalization(
                        child: const MyApp(),
                        supportedLocales:
                            LanguageManager.instance.supportedLocales,
                        path: ApplicationConstants.LANG_ASSET_PATH,
                      ));
                    }
                  } on SocketException catch (_) {
                    debugPrint("No Internet Connection");
                  }
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    primary: AppColors.white,
                    fixedSize: const Size(150, 50),
                    side: const BorderSide(width: 1.0, color: AppColors.white)),
                child: const Text(
                  'Try Again',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleManager.preferencesInit();
  await EasyLocalization.ensureInitialized();
  await setupLocator();
  await setUserToken();
}

Future<void> setUserToken() async {
  LocaleManager.instance.setBoolValue(PreferencesKeys.IS_REGISTERED, false);
  if (LocaleManager.instance.getBoolValue(PreferencesKeys.IS_LOGINED) ??
      false) {
    await getUserToken();
  }

  debugPrint(LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemeLight.instance.theme,
      navigatorKey: NavigationService.instance.navigatorKey,
      onGenerateRoute: NavigationRoute.instance.generateRoute,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      //darkTheme: DarkThemeData(),
      home: const Home(),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: AvoidGlowBehavior(),
          child: child!,
        );
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BottomBarView();
  }
}
