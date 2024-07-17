// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProductViewModel on _ProductViewModelBase, Store {
  final _$quantityAtom = Atom(name: '_ProductViewModelBase.quantity');

  @override
  int get quantity {
    _$quantityAtom.reportRead();
    return super.quantity;
  }

  @override
  set quantity(int value) {
    _$quantityAtom.reportWrite(value, super.quantity, () {
      super.quantity = value;
    });
  }

  final _$_ProductViewModelBaseActionController =
      ActionController(name: '_ProductViewModelBase');

  @override
  void incrementQuantity() {
    final _$actionInfo = _$_ProductViewModelBaseActionController.startAction(
        name: '_ProductViewModelBase.incrementQuantity');
    try {
      return super.incrementQuantity();
    } finally {
      _$_ProductViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrementQuantity() {
    final _$actionInfo = _$_ProductViewModelBaseActionController.startAction(
        name: '_ProductViewModelBase.decrementQuantity');
    try {
      return super.decrementQuantity();
    } finally {
      _$_ProductViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
quantity: ${quantity}
    ''';
  }
}
