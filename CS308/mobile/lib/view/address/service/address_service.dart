import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/path/url_path_constants.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/address/model/adress_model.dart';
import 'package:mobile/view/address/service/address_service_base.dart';

class AddressService extends AddressServiceBase {
  @override
  Future<AddressesResponseModel> getAddresses({
    BuildContext? context,
    String? token,
    int? skip,
    int? limit,
  }) async {
    AddressesResponseModel _responseModel = locator<AddressesResponseModel>();
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
        PathConstants.ADDRESS,
        queryParameters: data,
        options: Options(headers: header),
      );

      _responseModel = AddressesResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      debugPrint(exception.response!.toString());
      _responseModel = locator<AddressesResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = "Error!!!";
      return _responseModel;
    }
  }

  @override
  Future<AddressResponseModel> setAddress({
    BuildContext? context,
    String? token,
    AddressModel? address,
  }) async {
    AddressResponseModel _responseModel = locator<AddressResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      response = await dio.post(
        PathConstants.ADDRESS,
        data: address!.toJson(),
        options: Options(headers: header),
      );

      _responseModel = AddressResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      debugPrint("Error");
      debugPrint(exception.response!.data);
      _responseModel = locator<AddressResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = "Error!!!";
      return _responseModel;
    }
  }

  @override
  Future<AddressResponseModel> deleteAddress({
    BuildContext? context,
    String? token,
    int? id,
  }) async {
    AddressResponseModel _responseModel = locator<AddressResponseModel>();
    try {
      Response response;
      Dio dio = Dio();

      var header = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      response = await dio.delete(
        PathConstants.ADDRESS + "/$id",
        options: Options(headers: header),
      );

      _responseModel = AddressResponseModel.fromJson(response.data);
      return _responseModel;
    } on DioError catch (exception) {
      debugPrint("Error");
      debugPrint(exception.response!.data);
      _responseModel = locator<AddressResponseModel>();
      _responseModel.isSuccess = false;
      _responseModel.message = "Error!!!";
      return _responseModel;
    }
  }
}
