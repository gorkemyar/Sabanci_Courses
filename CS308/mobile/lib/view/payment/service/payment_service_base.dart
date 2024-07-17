import 'package:flutter/material.dart';
import 'package:mobile/view/payment/model/payment_model.dart';

abstract class PaymentServiceBase {
  Future<PaymentsResponseModel> getPayments({
    BuildContext context,
    String token,
    int skip,
    int limit,
  });

  Future<PaymentResponseModel> setPayment({
    BuildContext context,
    String token,
    PaymentModel payment,
  });

  Future<PaymentResponseModel> deletePayment({
    BuildContext context,
    String token,
    int id,
  });

  Future<PaymentResponseModel> order({
    BuildContext context,
    String token,
    int addressId,
    int cardId,
  });
}