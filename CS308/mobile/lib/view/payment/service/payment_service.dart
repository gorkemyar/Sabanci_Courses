import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/path/url_path_constants.dart';
import 'package:mobile/core/init/network/network_error.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/payment/service/payment_service_base.dart';
import 'package:mobile/view/payment/model/payment_model.dart';

class PaymentService extends PaymentServiceBase {
  @override
  Future<PaymentsResponseModel> getPayments({
    BuildContext? context,
    String? token,
    int? skip,
    int? limit,
  }) async {
    PaymentsResponseModel _responseModel = locator<PaymentsResponseModel>();
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
        PathConstants.PAYMENT,
        queryParameters: data,
        options: Options(headers: header),
      );

      _responseModel = PaymentsResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      debugPrint(exception.response!.toString());
      _responseModel = locator<PaymentsResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = "Error!!!";
      return _responseModel;
    }
  }

  @override
  Future<PaymentResponseModel> setPayment({
    BuildContext? context,
    String? token,
    PaymentModel? payment,
  }) async {
    PaymentResponseModel _responseModel = locator<PaymentResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var data = payment!.toJson();

      response = await dio.post(
        PathConstants.PAYMENT,
        data: data,
        options: Options(headers: header),
      );

      _responseModel = PaymentResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      debugPrint(exception.response!.toString());
      _responseModel = locator<PaymentResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = "Error!!!";
      return _responseModel;
    }
  }

  @override
  Future<PaymentResponseModel> deletePayment({
    BuildContext? context,
    String? token,
    int? id,
  }) async {
    PaymentResponseModel _responseModel = locator<PaymentResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      response = await dio.delete(
        PathConstants.PAYMENT + "/$id",
        options: Options(headers: header),
      );

      _responseModel = PaymentResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      debugPrint(exception.response!.toString());
      _responseModel = locator<PaymentResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = "Error!!!";
      return _responseModel;
    }
  }

  @override
  Future<PaymentResponseModel> order({
    BuildContext? context,
    String? token,
    int? addressId,
    int? cardId,
  }) async {
    PaymentResponseModel _responseModel = locator<PaymentResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var data = {
        'address_id': addressId,
        'credit_id': cardId,
      };

      response = await dio.post(
        PathConstants.SHOPLIST + "/order",
        data: data,
        options: Options(headers: header),
      );

      _responseModel = PaymentResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      debugPrint(exception.toString());
      NetworkError networkError =
          NetworkError.fromJson(exception.response!.data);
      _responseModel = locator<PaymentResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = networkError.message;
      return _responseModel;
    }
  }
}
