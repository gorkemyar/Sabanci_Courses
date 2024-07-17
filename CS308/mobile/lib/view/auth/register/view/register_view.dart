import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/base/state/base_state.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/constants/navigation/navigation_constants.dart';
import 'package:mobile/core/extension/string_extension.dart';
import 'package:mobile/core/init/lang/locale_keys.g.dart';
import 'package:mobile/core/init/navigation/navigation_service.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/auth/login/viewmodel/login_view_model.dart';
import 'package:mobile/view/auth/register/viewmodel/register_view_model.dart';
import '../../../../core/init/theme/color_theme.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late RegisterViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: locator<RegisterViewModel>(),
      onModelReady: (dynamic model) async {
        model.setContext(context);
        model.init();
        viewModel = model;
      },
      onPageBuilder: (context, value) {
        return Scaffold(
          appBar: _appBar(),
          body: _body(),
        );
      },
    );
  }

  AppBar _appBar() => AppBar(
        title: Text("Regsiter"),
        leading: BackButton(
          color: AppColors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );

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
            const SizedBox(height: 16.0),
            confirmPassword(),
            const SizedBox(height: 16.0),
            fullName(),
            const SizedBox(height: 24.0),
            registerButton(),
            login(),
          ],
        ),
      );

  final title = const Text(
    "Register",
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

  TextFormField confirmPassword() => TextFormField(
        autofocus: false,
        obscureText: true,
        controller: viewModel.passwordConfirmController,
        decoration: const InputDecoration(
          labelText: "Confirm Password",
          labelStyle: TextStyle(
              color: AppColors.gray, fontSize: 12, fontWeight: FontWeight.bold),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.secondary)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary)),
        ),
      );

  TextFormField fullName() => TextFormField(
        autofocus: false,
        obscureText: false,
        controller: viewModel.fullNameController,
        decoration: const InputDecoration(
          labelText: "Full Name",
          labelStyle: TextStyle(
              color: AppColors.gray, fontSize: 12, fontWeight: FontWeight.bold),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.secondary)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary)),
        ),
      );

  Padding registerButton() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: MaterialButton(
          height: 50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onPressed: () async {
            await viewModel.register();
          },
          padding: const EdgeInsets.all(12),
          color: AppColors.primary,
          child: Text("Create an account",
              style: const TextStyle(color: Colors.white)),
        ),
      );

  Row login() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RichText(
              text: TextSpan(
            children: [
              TextSpan(
                text: "Already have an account? ",
                style: const TextStyle(color: AppColors.gray),
              ),
              TextSpan(
                text: "Login",
                style: const TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    NavigationService.instance
                        .navigateToPageClear(path: NavigationConstants.LOGIN);
                  },
              ),
            ],
          ))
        ],
      );
}
