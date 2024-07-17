import 'package:flutter/material.dart';
import 'package:mobile/view/product/model/product_model.dart';

abstract class ProductServiceBase {
  Future<ProductResponseModel> getProduct({
    BuildContext context,
    int id,
  });
}