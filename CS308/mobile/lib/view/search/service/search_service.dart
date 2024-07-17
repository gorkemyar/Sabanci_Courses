import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/path/url_path_constants.dart';
import 'package:mobile/core/init/network/network_error.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/search/model/search_model.dart';
import 'package:mobile/view/search/service/search_service_base.dart';

class SearchService extends SearchServiceBase{
  @override
  Future<SearchResponseModel> search({
    BuildContext? context,
    String? query,
    int? skip,
    int? limit,
  }) async {
    SearchResponseModel _responseModel = locator<SearchResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
      };

      var data = {
        'query': query ?? "null",
        'skip': skip ?? 0,
        'limit': limit ?? 25,
      };

      response = await dio.get(
        PathConstants.PRODUCT,
        queryParameters: data,
        options: Options(headers: header),
      );

      _responseModel = SearchResponseModel.fromJson(response.data);
      return _responseModel;

    }  on DioError catch (exception) {
      debugPrint(exception.response!.data.toString());
      NetworkError networkError =
          NetworkError.fromJson(exception.response!.data);
      _responseModel = locator<SearchResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = networkError.message;
      return _responseModel;
    }
  }
}
    