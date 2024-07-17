import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/path/url_path_constants.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/comments/model/comments_model.dart';
import 'package:mobile/view/comments/service/comments_service_base.dart';

class CommentsService with CommentsServiceBase {
  @override
  Future<CommentsModelResponse> getComments({
    BuildContext? context,
    int? productId,
  }) async {
    CommentsModelResponse _responseModel = locator<CommentsModelResponse>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
      };

      response = await dio.get(
        PathConstants.PRODUCT + "/$productId" + "/comments",
        options: Options(headers: header),
      );
      _responseModel = CommentsModelResponse.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      debugPrint("Error");
      debugPrint(exception.response!.data);
      _responseModel = locator<CommentsModelResponse>();
      _responseModel.isSuccess = false;
      return _responseModel;
    }
  }

  @override
  Future<CommentsModelResponse> setComment({
    BuildContext? context,
    int? productId,
    String? token,
    CommentModel? comment,
  }) async {
    CommentsModelResponse _responseModel = locator<CommentsModelResponse>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      response = await dio.post(
        PathConstants.PRODUCT + "/$productId" + "/comment",
        data: comment!.toJson(),
        options: Options(headers: header),
      );

      _responseModel = CommentsModelResponse.fromJson(response.data);
      debugPrint(_responseModel.message);
      return _responseModel;
    } on DioError catch (exception) {
      debugPrint("Error");
      debugPrint(exception.response?.data);
      _responseModel = locator<CommentsModelResponse>();
      _responseModel.isSuccess = false;
      return _responseModel;
    }
  }
}
