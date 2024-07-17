import 'package:flutter/material.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/product/model/product_model.dart';
import 'package:mobile/view/product/service/product_serivce_base.dart';
import 'package:mobile/view/product/service/product_service.dart';

class ProductRepository with ProductServiceBase {
  final _service = locator<ProductService>();

  @override
  Future<ProductResponseModel> getProduct({
    BuildContext? context,
    int? id,
  }) async {
    ProductResponseModel _responseModel = await _service.getProduct(
      context: context,
      id: id ?? ApplicationConstants.PRODUCT_ID,
    );
    return _responseModel;
  }
}
