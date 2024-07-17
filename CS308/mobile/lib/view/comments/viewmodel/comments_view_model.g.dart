// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CommentsViewModel on _CommentsViewModelBase, Store {
  final _$commentsAtom = Atom(name: '_CommentsViewModelBase.comments');

  @override
  ObservableList<CommentModel> get comments {
    _$commentsAtom.reportRead();
    return super.comments;
  }

  @override
  set comments(ObservableList<CommentModel> value) {
    _$commentsAtom.reportWrite(value, super.comments, () {
      super.comments = value;
    });
  }

  final _$_CommentsViewModelBaseActionController =
      ActionController(name: '_CommentsViewModelBase');

  @override
  void addComment(CommentModel comment) {
    final _$actionInfo = _$_CommentsViewModelBaseActionController.startAction(
        name: '_CommentsViewModelBase.addComment');
    try {
      return super.addComment(comment);
    } finally {
      _$_CommentsViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeComment(CommentModel comment) {
    final _$actionInfo = _$_CommentsViewModelBaseActionController.startAction(
        name: '_CommentsViewModelBase.removeComment');
    try {
      return super.removeComment(comment);
    } finally {
      _$_CommentsViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setComments(List<CommentModel> comments) {
    final _$actionInfo = _$_CommentsViewModelBaseActionController.startAction(
        name: '_CommentsViewModelBase.setComments');
    try {
      return super.setComments(comments);
    } finally {
      _$_CommentsViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
comments: ${comments}
    ''';
  }
}
