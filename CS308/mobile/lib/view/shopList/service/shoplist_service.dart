import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/path/url_path_constants.dart';
import 'package:mobile/core/init/network/network_error.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/product/model/product_model.dart';
import 'package:mobile/view/shopList/model/shoplist_model.dart';
import 'package:mobile/view/shopList/service/shoplist_service_base.dart';

class ShopListService extends ShopListServiceBase {
  @override
  Future<ShopListResponseModel> getShopList({
    BuildContext? context,
    String? token,
    int? skip,
    int? limit,
  }) async {
    ShopListResponseModel _responseModel = locator<ShopListResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var data = {
        'skip': skip,
        'limit': limit,
      };

      response = await dio.get(
        PathConstants.SHOPLIST,
        queryParameters: data,
        options: Options(headers: header),
      );

      _responseModel = ShopListResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      NetworkError networkError =
          NetworkError.fromJson(exception.response!.data);
      _responseModel = locator<ShopListResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = networkError.message;
      return _responseModel;
    }
  }

  @override
  Future<ShopListItemResponseModel> deleteShopList({
    BuildContext? context,
    String? token,
  }) async {
    ShopListItemResponseModel _responseModel =
        locator<ShopListItemResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      response = await dio.delete(
        PathConstants.SHOPLIST,
        options: Options(headers: header),
      );

      _responseModel = ShopListItemResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      NetworkError networkError =
          NetworkError.fromJson(exception.response!.data);
      _responseModel = locator<ShopListItemResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = networkError.message;
      return _responseModel;
    }
  }

  @override
  Future<ShopListItemResponseModel> getShopListItem({
    BuildContext? context,
    String? token,
    int? id,
  }) async {
    ShopListItemResponseModel _responseModel =
        locator<ShopListItemResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      response = await dio.get(
        PathConstants.SHOPLIST + "/$id",
        options: Options(headers: header),
      );

      _responseModel = ShopListItemResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      NetworkError networkError =
          NetworkError.fromJson(exception.response!.data);
      _responseModel = locator<ShopListItemResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = networkError.message;
      return _responseModel;
    }
  }

  @override
  Future<ShopListItemResponseModel> deleteShopListItem({
    BuildContext? context,
    String? token,
    int? id,
  }) async {
    ShopListItemResponseModel _responseModel =
        locator<ShopListItemResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      response = await dio.delete(
        PathConstants.SHOPLIST + "/$id",
        options: Options(headers: header),
      );

      _responseModel = ShopListItemResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      NetworkError networkError =
          NetworkError.fromJson(exception.response!.data);
      _responseModel = locator<ShopListItemResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = networkError.message;
      return _responseModel;
    }
  }

  @override
  Future<ShopListItemResponseModel> addShopListItem({
    BuildContext? context,
    String? token,
    String? createdAt,
    ProductModel? product,
    int? quantity,
  }) async {
    ShopListItemResponseModel _responseModel =
        locator<ShopListItemResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var data = {
        'created_at': createdAt,
        'product_id': product?.id ?? 0,
        'quantity': quantity,
      };

      response = await dio.post(
        PathConstants.SHOPLIST,
        data: data,
        options: Options(headers: header),
      );

      _responseModel = ShopListItemResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      NetworkError networkError =
          NetworkError.fromJson(exception.response!.data);
      _responseModel = locator<ShopListItemResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = networkError.message;
      return _responseModel;
    }
  }

  @override
  Future<ShopListItemResponseModel> updateShopListItem({
    BuildContext? context,
    String? token,
    ProductModel? product,
    int? quantity,
  }) async {
    ShopListItemResponseModel _responseModel =
        locator<ShopListItemResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var data = {
        "product_id": product?.id ?? 0,
        "quantity": quantity,
      };
      response = await dio.patch(
        PathConstants.SHOPLIST,
        data: data,
        options: Options(headers: header),
      );

      _responseModel = ShopListItemResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      NetworkError networkError =
          NetworkError.fromJson(exception.response!.data);
      _responseModel = locator<ShopListItemResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = networkError.message;
      return _responseModel;
    }
  }
}
