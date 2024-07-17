import 'package:flutter/material.dart';
import 'package:mobile/core/constants/enums/locale_keys_enum.dart';
import 'package:mobile/core/init/cache/locale_manager.dart';
import 'package:mobile/core/init/network/log_inceptor.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/orders/model/order_model.dart';
import 'package:mobile/view/orders/service/orders_service.dart';
import 'package:mobile/view/orders/service/orders_service_base.dart';

class OrderRepository extends OrderServiceBase {
  final _service = locator<OrderService>();

  @override
  Future<OrderResponseModel> getOrders({
    BuildContext? context,
    String? token,
    int? skip,
    int? limit,
  }) async {
    await getUserToken();
    var token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)!;

    OrderResponseModel _responseModel = await _service.getOrders(
      context: context,
      token: token,
      skip: skip,
      limit: limit,
    );
    return _responseModel;
  }

  @override
  Future<RefundResponseModel> refund({
    BuildContext? context,
    String? token,
    int? orderId,
  }) async {
    await getUserToken();
    var token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)!;

    RefundResponseModel _responseModel = await _service.refund(
      context: context,
      token: token,
      orderId: orderId,
    );
    return _responseModel;
  }
}
