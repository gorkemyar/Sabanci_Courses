import 'package:flutter/material.dart';
import 'package:mobile/view/orders/model/order_model.dart';

abstract class OrderServiceBase {
  Future<OrderResponseModel> getOrders({
    BuildContext context,
    String token,
    int skip,
    int limit,
  });

  Future<RefundResponseModel> refund({
    BuildContext context,
    String token,
    int orderId,
  });
}
