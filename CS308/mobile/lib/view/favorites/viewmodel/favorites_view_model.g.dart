// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FavoritesViewModel on _FavoritesViewModelBase, Store {
  final _$productsAtom = Atom(name: '_FavoritesViewModelBase.products');

  @override
  ObservableList<ProductModel> get products {
    _$productsAtom.reportRead();
    return super.products;
  }

  @override
  set products(ObservableList<ProductModel> value) {
    _$productsAtom.reportWrite(value, super.products, () {
      super.products = value;
    });
  }

  final _$submitAsyncAction = AsyncAction('_FavoritesViewModelBase.submit');

  @override
  Future submit() {
    return _$submitAsyncAction.run(() => super.submit());
  }

  final _$_FavoritesViewModelBaseActionController =
      ActionController(name: '_FavoritesViewModelBase');

  @override
  void setProducts(List<ProductModel> products) {
    final _$actionInfo = _$_FavoritesViewModelBaseActionController.startAction(
        name: '_FavoritesViewModelBase.setProducts');
    try {
      return super.setProducts(products);
    } finally {
      _$_FavoritesViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addNewproduct(ProductModel product) {
    final _$actionInfo = _$_FavoritesViewModelBaseActionController.startAction(
        name: '_FavoritesViewModelBase.addNewproduct');
    try {
      return super.addNewproduct(product);
    } finally {
      _$_FavoritesViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
products: ${products}
    ''';
  }
}
