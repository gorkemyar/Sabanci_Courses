import 'package:flutter/material.dart';
import 'package:mobile/core/constants/navigation/navigation_constants.dart';
import 'package:mobile/core/init/navigation/navigation_service.dart';
import 'package:mobile/core/init/theme/color_theme.dart';

class LoginRequired extends StatelessWidget {
  final String message;
  const LoginRequired({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() => AppBar();

  Center _body() => Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.darkGray,
                      fontSize: 21,
                      fontWeight: FontWeight.w500),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(240, 48)),
                  onPressed: (() => NavigationService.instance
                      .navigateToPageClear(path: NavigationConstants.LOGIN)),
                  child: const Text(
                    "Go to Login",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                    ),
                  ))
            ]),
      );
}
