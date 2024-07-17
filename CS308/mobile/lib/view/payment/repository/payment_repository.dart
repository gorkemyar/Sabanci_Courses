import 'package:flutter/material.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/constants/enums/locale_keys_enum.dart';
import 'package:mobile/core/init/cache/locale_manager.dart';
import 'package:mobile/core/init/network/log_inceptor.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/payment/model/payment_model.dart';
import 'package:mobile/view/payment/service/payment_service.dart';
import 'package:mobile/view/payment/service/payment_service_base.dart';

class PaymentRepository extends PaymentServiceBase {
  final _service = locator<PaymentService>();

  @override
  Future<PaymentsResponseModel> getPayments({
    BuildContext? context,
    String? token,
    int? skip,
    int? limit,
  }) async {
    await getUserToken();
    var token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)!;

    PaymentsResponseModel _responseModel = await _service.getPayments(
      context: context,
      token: token,
      skip: skip ?? ApplicationConstants.PAYMENT_SKIP,
      limit: limit ?? ApplicationConstants.PAYMENT_LIMIT,
    );

    return _responseModel;
  }

  @override
  Future<PaymentResponseModel> setPayment({
    BuildContext? context,
    String? token,
    PaymentModel? payment,
  }) async {
    await getUserToken();
    var token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)!;

    PaymentResponseModel _responseModel = await _service.setPayment(
      context: context,
      token: token,
      payment: payment,
    );

    return _responseModel;
  }

  @override
  Future<PaymentResponseModel> deletePayment({
    BuildContext? context,
    String? token,
    int? id,
  }) async {
    await getUserToken();
    var token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)!;

    PaymentResponseModel _responseModel = await _service.deletePayment(
      context: context,
      token: token,
      id: id,
    );

    return _responseModel;
  }

  @override
  Future<PaymentResponseModel> order({
    BuildContext? context,
    String? token,
    int? addressId,
    int? cardId,
  }) async {
    await getUserToken();
    var token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)!;

    PaymentResponseModel _responseModel = await _service.order(
      context: context,
      token: token,
      addressId: addressId ?? 0,
      cardId: cardId ?? 0,
    );

    return _responseModel;
  }
}
