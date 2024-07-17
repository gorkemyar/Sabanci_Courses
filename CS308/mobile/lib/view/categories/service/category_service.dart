import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/path/url_path_constants.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/categories/model/category_model.dart';
import 'package:mobile/view/categories/service/category_service_base.dart';

class CategoryService with CategoryServiceBase {
  @override
  Future<CategoriesResponseModel> getCategories({
    BuildContext? context,
    int? skip,
    int? limit,
  }) async {
    CategoriesResponseModel _responseModel = locator<CategoriesResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
      };

      var data = {
        'skip': skip,
        'limit': limit,
      };
      response = await dio.get(
        PathConstants.CATEGORY,
        queryParameters: data,
        options: Options(headers: header),
      );

      _responseModel = CategoriesResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      debugPrint("Error");
      debugPrint(exception.response!.data);
      _responseModel = locator<CategoriesResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = "Error!!!";
      return _responseModel;
    }
  }

  @override
  Future<CategoryResponseModel> getCategory({
    BuildContext? context,
    int? id,
  }) async {
    CategoryResponseModel _responseModel = locator<CategoryResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
      };

      response = await dio.get(
        PathConstants.CATEGORY + "/$id",
        options: Options(headers: header),
      );
      _responseModel = CategoryResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      debugPrint("Error");
      debugPrint(exception.response!.data);
      _responseModel = locator<CategoryResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = "Error!!!";
      return _responseModel;
    }
  }
}
