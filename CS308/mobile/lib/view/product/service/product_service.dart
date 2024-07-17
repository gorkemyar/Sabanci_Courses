import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/path/url_path_constants.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/product/model/product_model.dart';
import 'package:mobile/view/product/service/product_serivce_base.dart';

class ProductService with ProductServiceBase {
  @override
  Future<ProductResponseModel> getProduct({
    BuildContext? context,
    int? id,
  }) async {
    ProductResponseModel _responseModel = locator<ProductResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
      };

      response = await dio.get(
        PathConstants.PRODUCT + "/$id",
        options: Options(headers: header),
      );

      _responseModel = ProductResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      debugPrint("Error");
      debugPrint(exception.response!.data);
      _responseModel = locator<ProductResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = "Error!!!";
      return _responseModel;
    }
  }
}
