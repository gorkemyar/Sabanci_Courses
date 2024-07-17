import 'package:flutter/material.dart';
import 'package:mobile/core/base/model/base_view_model.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/comments/add_comments/view/add_comments_view.dart';
import 'package:mobile/view/comments/model/comments_model.dart';
import 'package:mobile/view/comments/repository/comments_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:mobile/view/comments/view/comments_view.dart';
part 'add_comments_view_model.g.dart';

class AddCommentsViewModel = _AddCommentsViewModelBase
    with _$AddCommentsViewModel;

abstract class _AddCommentsViewModelBase with Store, BaseViewModel {
  late int product_id = product_id;
  late int rate;
  late CommentsRepository _repository;
  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    _repository = locator<CommentsRepository>();
  }

  void dispose() {}

  @action
  void _listener() {}

  @observable
  TextEditingController contentController = TextEditingController();

  @action
  submit() async {
    if (contentController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid content",
          isSuccess: false);
    } else {
      await addComment();
    }
  }

  Future<void> addComment() async {
    CommentModel _comment = CommentModel(
      content: contentController.text,
      productId: productId,
      rate: productRating,
    );

    CommentsModelResponse _commentResponse = await _repository.setComment(
      comment: _comment,
      context: context,
      productId: _comment.productId,
    );

    if (_commentResponse.isSuccess ?? false) {
      showToast(
          context: context!,
          message: "Comment has been added",
          isSuccess: true);
    } else {
      showToast(
          context: context!,
          message: "Comment has not been added",
          isSuccess: false);
    }
  }
}
