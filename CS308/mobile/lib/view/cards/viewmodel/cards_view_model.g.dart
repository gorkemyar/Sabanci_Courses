// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cards_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CardsViewModel on _CardsViewModelBase, Store {
  final _$paymentsAtom = Atom(name: '_CardsViewModelBase.payments');

  @override
  ObservableList<PaymentModel> get payments {
    _$paymentsAtom.reportRead();
    return super.payments;
  }

  @override
  set payments(ObservableList<PaymentModel> value) {
    _$paymentsAtom.reportWrite(value, super.payments, () {
      super.payments = value;
    });
  }

  final _$deletePaymentAsyncAction =
      AsyncAction('_CardsViewModelBase.deletePayment');

  @override
  Future<void> deletePayment({required int index, required int id}) {
    return _$deletePaymentAsyncAction
        .run(() => super.deletePayment(index: index, id: id));
  }

  final _$_CardsViewModelBaseActionController =
      ActionController(name: '_CardsViewModelBase');

  @override
  void addNewPayment(PaymentModel payment) {
    final _$actionInfo = _$_CardsViewModelBaseActionController.startAction(
        name: '_CardsViewModelBase.addNewPayment');
    try {
      return super.addNewPayment(payment);
    } finally {
      _$_CardsViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
payments: ${payments}
    ''';
  }
}
