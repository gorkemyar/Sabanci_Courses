import 'package:flutter/material.dart';
import 'package:mobile/core/base/state/base_state.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/constants/navigation/navigation_constants.dart';
import 'package:mobile/core/extension/string_extension.dart';
import 'package:mobile/core/init/lang/locale_keys.g.dart';
import 'package:mobile/core/init/navigation/navigation_service.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/auth/login/viewmodel/login_view_model.dart';

import '../../../../core/init/theme/color_theme.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends BaseState<LoginView> {
  late LoginViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: locator<LoginViewModel>(),
      onModelReady: (dynamic model) async {
        model.setContext(context);
        model.init();
        viewModel = model;
      },
      onPageBuilder: (context, value) {
        return Scaffold(
          body: _body(),
        );
      },
    );
  }

  Center _body() => Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            title,
            const SizedBox(height: 12.0),
            email(),
            const SizedBox(height: 16.0),
            password(),
            const SizedBox(height: 24.0),
            loginButton(),
            forgotLabel,
            register,
            withoutLogin(),
          ],
        ),
      );

  Row withoutLogin() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              NavigationService.instance
                  .navigateToPageClear(path: NavigationConstants.DEFAULT);
            },
            child: const Text("Continue without login"),
          )
        ],
      );

  final title = const Text(
    "WELCOME",
    style: TextStyle(
      color: AppColors.black,
      fontSize: 36,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.01,
    ),
  );

  TextFormField email() => TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: viewModel.emailController,
        autocorrect: false,
        autofocus: false,
        decoration: const InputDecoration(
          labelText: "Email",
          labelStyle: TextStyle(
              color: AppColors.gray, fontSize: 12, fontWeight: FontWeight.bold),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.secondary)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary)),
        ),
      );

  TextFormField password() => TextFormField(
        autofocus: false,
        obscureText: true,
        controller: viewModel.passwordController,
        decoration: const InputDecoration(
          labelText: "Password",
          labelStyle: TextStyle(
              color: AppColors.gray, fontSize: 12, fontWeight: FontWeight.bold),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.secondary)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary)),
        ),
      );

  Padding loginButton() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: MaterialButton(
          height: 50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onPressed: () => viewModel.submit(),
          padding: const EdgeInsets.all(12),
          color: AppColors.primary,
          child: Text(LocaleKeys.login.locale,
              style: const TextStyle(color: Colors.white)),
        ),
      );

  final register = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        LocaleKeys.dontAccount.locale,
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 16.0,
        ),
      ),
      TextButton(
        onPressed: () {
          NavigationService.instance
              .navigateToPage(path: NavigationConstants.REGISTER);
        },
        child: Text(
          LocaleKeys.signUp.locale,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 16.0,
          ),
        ),
      ),
    ],
  );
  final forgotLabel = TextButton(
    child: Text(
      LocaleKeys.forgotPassword.locale,
      style: const TextStyle(color: Colors.black54),
    ),
    onPressed: () {},
  );
}
