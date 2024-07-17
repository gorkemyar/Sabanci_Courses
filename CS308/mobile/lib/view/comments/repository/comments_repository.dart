import 'package:flutter/material.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/constants/enums/locale_keys_enum.dart';
import 'package:mobile/core/init/cache/locale_manager.dart';
import 'package:mobile/core/init/network/log_inceptor.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/comments/model/comments_model.dart';
import 'package:mobile/view/comments/service/comments_service_base.dart';
import 'package:mobile/view/comments/service/comments_service.dart';

class CommentsRepository with CommentsServiceBase {
  final _service = locator<CommentsService>();

  @override
  Future<CommentsModelResponse> getComments({
    BuildContext? context,
    int? productId,
  }) async {
    CommentsModelResponse _responseModel = await _service.getComments(
      context: context,
      productId: productId ?? ApplicationConstants.PRODUCT_ID,
    );
    return _responseModel;
  }

  @override
  Future<CommentsModelResponse> setComment({
    BuildContext? context,
    int? productId,
    String? token,
    CommentModel? comment,
  }) async {
    await getUserToken();
    var token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)!;

    CommentsModelResponse _responseModel = await _service.setComment(
      context: context,
      productId: productId,
      token: token,
      comment: comment ?? CommentModel(),
    );
    return _responseModel;
  }
}
