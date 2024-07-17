import 'package:flutter/material.dart';
import 'package:mobile/core/base/model/base_view_model.dart';
import 'package:mobile/core/constants/navigation/navigation_constants.dart';
import 'package:mobile/core/extension/string_extension.dart';
import 'package:mobile/core/init/navigation/navigation_service.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/auth/register/model/register_model.dart';
import 'package:mobile/view/auth/register/repository/register_repository.dart';
import 'package:mobx/mobx.dart';
part 'register_view_model.g.dart';

class RegisterViewModel = _RegisterViewModelBase with _$RegisterViewModel;

abstract class _RegisterViewModelBase with Store, BaseViewModel {
  late RegisterRepository _repository;
  late String email;
  late String fullName;
  late String password;
  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    _repository = locator<RegisterRepository>();
  }

  @observable
  TextEditingController emailController = TextEditingController();

  @observable
  TextEditingController passwordController = TextEditingController();

  @observable
  TextEditingController passwordConfirmController = TextEditingController();

  @observable
  TextEditingController fullNameController = TextEditingController();

  void dispose() {}

  @action
  void _listener() {}

  @action
  submit() async {
    if (emailController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid email",
          isSuccess: false);
    } else if (passwordController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid password",
          isSuccess: false);
    } else if (passwordConfirmController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please confirm your password",
          isSuccess: false);
    } else if (passwordConfirmController.text != passwordController.text) {
      showToast(
          context: context!,
          message: "Passwords do not match",
          isSuccess: false);
    } else if (fullNameController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter your full name",
          isSuccess: false);
    } else {
      await register();
    }
  }

  Future<void> register() async {
    RegisterModel _register = RegisterModel(
      email: emailController.text,
      fullName: fullNameController.text,
      password: passwordController.text,
    );

    RegisterModelResponse _registerResponse = await _repository.setRegister(
      context: context,
      email: _register.email,
      fullName: _register.fullName,
      password: _register.password,
    );
    showToast(
        context: context!, message: "Register has been added", isSuccess: true);
    await NavigationService.instance.navigateToPage(
      path: NavigationConstants.LOGIN,
    );
  }
}
