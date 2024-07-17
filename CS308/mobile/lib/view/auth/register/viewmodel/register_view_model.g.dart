// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RegisterViewModel on _RegisterViewModelBase, Store {
  final _$emailControllerAtom =
      Atom(name: '_RegisterViewModelBase.emailController');

  @override
  TextEditingController get emailController {
    _$emailControllerAtom.reportRead();
    return super.emailController;
  }

  @override
  set emailController(TextEditingController value) {
    _$emailControllerAtom.reportWrite(value, super.emailController, () {
      super.emailController = value;
    });
  }

  final _$passwordControllerAtom =
      Atom(name: '_RegisterViewModelBase.passwordController');

  @override
  TextEditingController get passwordController {
    _$passwordControllerAtom.reportRead();
    return super.passwordController;
  }

  @override
  set passwordController(TextEditingController value) {
    _$passwordControllerAtom.reportWrite(value, super.passwordController, () {
      super.passwordController = value;
    });
  }

  final _$passwordConfirmControllerAtom =
      Atom(name: '_RegisterViewModelBase.passwordConfirmController');

  @override
  TextEditingController get passwordConfirmController {
    _$passwordConfirmControllerAtom.reportRead();
    return super.passwordConfirmController;
  }

  @override
  set passwordConfirmController(TextEditingController value) {
    _$passwordConfirmControllerAtom
        .reportWrite(value, super.passwordConfirmController, () {
      super.passwordConfirmController = value;
    });
  }

  final _$fullNameControllerAtom =
      Atom(name: '_RegisterViewModelBase.fullNameController');

  @override
  TextEditingController get fullNameController {
    _$fullNameControllerAtom.reportRead();
    return super.fullNameController;
  }

  @override
  set fullNameController(TextEditingController value) {
    _$fullNameControllerAtom.reportWrite(value, super.fullNameController, () {
      super.fullNameController = value;
    });
  }

  final _$submitAsyncAction = AsyncAction('_RegisterViewModelBase.submit');

  @override
  Future submit() {
    return _$submitAsyncAction.run(() => super.submit());
  }

  final _$_RegisterViewModelBaseActionController =
      ActionController(name: '_RegisterViewModelBase');

  @override
  void _listener() {
    final _$actionInfo = _$_RegisterViewModelBaseActionController.startAction(
        name: '_RegisterViewModelBase._listener');
    try {
      return super._listener();
    } finally {
      _$_RegisterViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
emailController: ${emailController},
passwordController: ${passwordController},
passwordConfirmController: ${passwordConfirmController},
fullNameController: ${fullNameController}
    ''';
  }
}
