import 'package:mobile/view/product/model/product_model.dart';

class ShopListResponseModel {
  String? message;
  bool? isSuccess;
  List<ShopListItem>? data;

  ShopListResponseModel({this.message, this.isSuccess, this.data});

  ShopListResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isSuccess = json['isSuccess'];
    if (json['data'] != null) {
      data = <ShopListItem>[];
      json['data'].forEach((v) {
        data!.add(ShopListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['isSuccess'] = isSuccess;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShopListItemResponseModel {
  String? message;
  bool? isSuccess;
  ShopListItem? data;

  ShopListItemResponseModel({this.message, this.isSuccess, this.data});

  ShopListItemResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isSuccess = json['isSuccess'];
    data = json['data'] != null ? ShopListItem.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['isSuccess'] = isSuccess;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ShopListItem {
  int? quantity;
  ProductModel? product;

  ShopListItem({this.quantity, this.product});

  ShopListItem.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    product =
        json['product'] != null ? ProductModel.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity'] = quantity;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

