import 'package:flutter/material.dart';
import 'package:mobile/core/base/model/base_view_model.dart';
import 'package:mobile/core/constants/navigation/navigation_constants.dart';
import 'package:mobile/core/extension/string_extension.dart';
import 'package:mobile/core/init/navigation/navigation_service.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/auth/login/model/login_model.dart';
import 'package:mobile/view/auth/login/repository/login_repository.dart';
import 'package:mobile/view/shopList/repository/shoplist_repository.dart';
import 'package:mobx/mobx.dart';
part 'login_view_model.g.dart';

class LoginViewModel = _LoginViewModelBase with _$LoginViewModel;

abstract class _LoginViewModelBase with Store, BaseViewModel {
  late LoginRepository _repository;

  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    _repository = locator<LoginRepository>();
  }

  void dispose() {}

  @observable
  TextEditingController emailController = TextEditingController();

  @observable
  TextEditingController passwordController = TextEditingController();

  @action
  submit() async {
    if (emailController.text.isEmpty || !emailController.text.isValidEmails) {
      showToast(
          context: context!,
          message: "Please enter a valid email",
          isSuccess: false);
    } else if (passwordController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid password",
          isSuccess: false);
    } else {
      await getUserToken();
      var _shopList = locator<ShopListRepository>();
      await _shopList.saveShopListItems();
    }
  }

  Future<void> getUserToken() async {
    UserTokenModel _tokenResponse = await _repository.getUserToken(
      email: emailController.text,
      password: passwordController.text,
      context: context,
    );

    if (_tokenResponse.isSuccess ?? false) {
      NavigationService.instance
          .navigateToPageClear(path: NavigationConstants.BOTTOM_BAR);
    }

    showToast(
        context: context!,
        message: _tokenResponse.message!,
        isSuccess: _tokenResponse.isSuccess!);
  }
}
