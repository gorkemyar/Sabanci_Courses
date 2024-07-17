import 'package:mobile/view/address/model/adress_model.dart';
import 'package:mobile/view/payment/model/payment_model.dart';
import 'package:mobile/view/product/model/product_model.dart';

class RefundResponseModel {
  String? message;
  bool? isSuccess;

  RefundResponseModel({this.message, this.isSuccess});

  RefundResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isSuccess = json['isSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['isSuccess'] = isSuccess;
    return data;
  }
}

class OrderResponseModel {
  String? message;
  bool? isSuccess;
  List<OrderModel>? data;

  OrderResponseModel({this.message, this.isSuccess, this.data});

  OrderResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isSuccess = json['isSuccess'];
    if (json['data'] != null) {
      data = <OrderModel>[];
      json['data'].forEach((v) {
        data!.add(OrderModel.fromJson(v));
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

class OrderModel {
  AddressModel? address;
  PaymentModel? credit;
  String? createdAt;
  List<OrderDetails>? orderDetails;

  OrderModel({this.address, this.credit, this.createdAt, this.orderDetails});

  OrderModel.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? AddressModel.fromJson(json['address']) : null;
    credit =
        json['credit'] != null ? PaymentModel.fromJson(json['credit']) : null;
    createdAt = json['created_at'];
    if (json['order_details'] != null) {
      orderDetails = <OrderDetails>[];
      json['order_details'].forEach((v) {
        orderDetails!.add(OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (credit != null) {
      data['credit'] = credit!.toJson();
    }
    data['created_at'] = createdAt;
    if (orderDetails != null) {
      data['order_details'] = orderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetails {
  int? id;
  ProductModel? product;
  int? quantity;
  String? orderStatus;
  double? price;

  OrderDetails(
      {this.id, this.product, this.quantity, this.orderStatus, this.price});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
        json['product'] != null ? ProductModel.fromJson(json['product']) : null;
    quantity = json['quantity'];
    orderStatus = json['order_status'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['quantity'] = quantity;
    data['order_status'] = orderStatus;
    data['price'] = price;
    return data;
  }
}
