import 'package:flutter/material.dart';
import 'package:mobile/core/base/model/base_view_model.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/constants/navigation/navigation_constants.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/comments/add_comments/view/add_comments_view.dart';
import 'package:mobile/view/comments/model/comments_model.dart';
import 'package:mobile/view/comments/repository/comments_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
part 'comments_view_model.g.dart';

class CommentsViewModel = _CommentsViewModelBase with _$CommentsViewModel;

abstract class _CommentsViewModelBase with Store, BaseViewModel {
  late int productId;
  late CommentsRepository _repository;
  late CommentsModelResponse _commentsModel;

  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    _repository = locator<CommentsRepository>();
  }

  void dispose() {}

  @observable
  var comments = ObservableList<CommentModel>();

  @action
  void addComment(CommentModel comment) {
    comments.add(comment);
  }

  @action
  void removeComment(CommentModel comment) {
    comments.remove(comment);
  }

  @action
  void setComments(List<CommentModel> comments) {
    this.comments.clear();
    for (var comment in comments) {
      this.comments.add(comment);
    }
  }

  Future<bool> getData() async {
    _commentsModel = await _repository.getComments(
      context: context,
      productId: productId,
    );
    if (_commentsModel.isSuccess ?? false) {
      setComments(_commentsModel.data ?? []);
    } else {
      showToast(
          context: context!,
          message: _commentsModel.message ?? ApplicationConstants.ERROR_MESSAGE,
          isSuccess: false);
    }
    return _commentsModel.isSuccess ?? false;
  }

  void navigateToAddCommentsView(BuildContext context) =>
      pushNewScreenWithRouteSettings(
        context,
        screen: const AddCommentsView(),
        settings: const RouteSettings(name: NavigationConstants.ADD_COMMENT),
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
}
