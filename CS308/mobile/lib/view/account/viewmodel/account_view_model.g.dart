// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AccountViewModel on _AccountViewModelBase, Store {
  final _$userAtom = Atom(name: '_AccountViewModelBase.user');

  @override
  UserModel get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModel value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$_AccountViewModelBaseActionController =
      ActionController(name: '_AccountViewModelBase');

  @override
  dynamic setUser(UserModel user) {
    final _$actionInfo = _$_AccountViewModelBaseActionController.startAction(
        name: '_AccountViewModelBase.setUser');
    try {
      return super.setUser(user);
    } finally {
      _$_AccountViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user}
    ''';
  }
}
