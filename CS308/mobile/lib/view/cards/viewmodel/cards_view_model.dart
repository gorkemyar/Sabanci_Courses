import 'package:flutter/material.dart';
import 'package:mobile/core/base/model/base_view_model.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/payment/model/payment_model.dart';
import 'package:mobx/mobx.dart';

import '../../payment/repository/payment_repository.dart';
part 'cards_view_model.g.dart';

class CardsViewModel = _CardsViewModelBase with _$CardsViewModel;

abstract class _CardsViewModelBase with Store, BaseViewModel {
  late PaymentRepository _repository;
  late PaymentResponseModel _paymentResponseModel;
  late PaymentsResponseModel _paymentsResponseModel;
  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    _repository = locator<PaymentRepository>();
  }

  void dispose() {}

  @observable
  var payments = ObservableList<PaymentModel>();

  void setPayments(List<PaymentModel> payments) {
    this.payments.clear();
    for (var payment in payments) {
      addNewPayment(payment);
    }
  }

  @action
  void addNewPayment(PaymentModel payment) {
    payments.add(payment);
  }

  @action
  Future<void> deletePayment({required int index, required int id}) async {
    _paymentResponseModel = await _repository.deletePayment(
      context: context,
      id: id,
    );           
    if (_paymentResponseModel.isSuccess ?? false) {
      payments.removeAt(index);
      showToast(
          context: context!,
          message: "Payment deleted successfully",
          isSuccess: false);
    } else {
      showToast(
          context: context!,
          message: _paymentResponseModel.message ??
              ApplicationConstants.ERROR_MESSAGE,
          isSuccess: false);
    }
  }

  Future<bool> getData() async {
    _paymentsResponseModel = await _repository.getPayments(
      context: context,
    );
    setPayments(_paymentsResponseModel.data!);
    return _paymentsResponseModel.isSuccess!;
  }
}
