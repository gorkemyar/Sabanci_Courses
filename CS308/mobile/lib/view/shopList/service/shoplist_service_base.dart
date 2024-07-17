// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mobile/view/product/model/product_model.dart';
import 'package:mobile/view/shopList/model/shoplist_model.dart';

abstract class ShopListServiceBase {
  Future<ShopListResponseModel> getShopList({
    BuildContext context,
    String token,
    int skip,
    int limit,
  });

  Future<ShopListItemResponseModel> deleteShopList({
    BuildContext context,
    String token,
  });

  Future<ShopListItemResponseModel> getShopListItem({
    BuildContext context,
    String token,
    int id,
  });

  Future<ShopListItemResponseModel> deleteShopListItem({
    BuildContext context,
    String token,
    int id,
  });

  Future<ShopListItemResponseModel> addShopListItem({
    BuildContext context,
    String token,
    String createdAt,
    ProductModel product,
    int quantity,
  });

  Future<ShopListItemResponseModel> updateShopListItem({
    BuildContext context,
    String token,
    ProductModel product,
    int quantity,
  });
}
