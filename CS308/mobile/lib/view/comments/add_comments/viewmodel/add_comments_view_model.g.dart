// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_comments_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AddCommentsViewModel on _AddCommentsViewModelBase, Store {
  final _$contentControllerAtom =
      Atom(name: '_AddCommentsViewModelBase.contentController');

  @override
  TextEditingController get contentController {
    _$contentControllerAtom.reportRead();
    return super.contentController;
  }

  @override
  set contentController(TextEditingController value) {
    _$contentControllerAtom.reportWrite(value, super.contentController, () {
      super.contentController = value;
    });
  }

  final _$submitAsyncAction = AsyncAction('_AddCommentsViewModelBase.submit');

  @override
  Future submit() {
    return _$submitAsyncAction.run(() => super.submit());
  }

  final _$_AddCommentsViewModelBaseActionController =
      ActionController(name: '_AddCommentsViewModelBase');

  @override
  void _listener() {
    final _$actionInfo = _$_AddCommentsViewModelBaseActionController
        .startAction(name: '_AddCommentsViewModelBase._listener');
    try {
      return super._listener();
    } finally {
      _$_AddCommentsViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
contentController: ${contentController}
    ''';
  }
}
