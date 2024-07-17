import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/path/url_path_constants.dart';
import 'package:mobile/core/init/network/network_error.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/orders/model/order_model.dart';
import 'package:mobile/view/orders/service/orders_service_base.dart';

class OrderService extends OrderServiceBase {
  @override
  Future<OrderResponseModel> getOrders({
    BuildContext? context,
    String? token,
    int? skip,
    int? limit,
  }) async {
    OrderResponseModel _responseModel = locator<OrderResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var data = {
        'skip': skip ?? 0,
        'limit': limit ?? 100,
      };

      response = await dio.get(
        PathConstants.ORDER,
        queryParameters: data,
        options: Options(headers: header),
      );
      _responseModel = OrderResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      NetworkError networkError =
          NetworkError.fromJson(exception.response!.data);
      _responseModel = locator<OrderResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = networkError.message;
      return _responseModel;
    }
  }

  @override
  Future<RefundResponseModel> refund({
    BuildContext? context,
    String? token,
    int? orderId,
  }) async {
    RefundResponseModel _responseModel = locator<RefundResponseModel>();

    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var data = {
        'orderitem_id': orderId ?? 0,
        'reason': '',
      };

      response = await dio.post(
        PathConstants.REFUND,
        data: data,
        options: Options(headers: header),
      );

      _responseModel = RefundResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      NetworkError networkError =
          NetworkError.fromJson(exception.response!.data);
      _responseModel = locator<RefundResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = networkError.message;
      return _responseModel;
    }
  }
}
