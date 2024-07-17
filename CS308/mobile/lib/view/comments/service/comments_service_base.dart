import 'package:flutter/material.dart';
import 'package:mobile/view/comments/model/comments_model.dart';

abstract class CommentsServiceBase {
  Future<CommentsModelResponse> getComments({
    BuildContext context,
    int productId,
  });

  Future<CommentsModelResponse> setComment({
    BuildContext context,
    int productId,
    CommentModel comment,
    String token,
  });
}
