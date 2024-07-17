// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shoplist_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ShopListViewModel on _ShopListViewModelBase, Store {
  final _$shopListAtom = Atom(name: '_ShopListViewModelBase.shopList');

  @override
  ObservableList<ShopListItem> get shopList {
    _$shopListAtom.reportRead();
    return super.shopList;
  }

  @override
  set shopList(ObservableList<ShopListItem> value) {
    _$shopListAtom.reportWrite(value, super.shopList, () {
      super.shopList = value;
    });
  }

  final _$totalPriceAtom = Atom(name: '_ShopListViewModelBase.totalPrice');

  @override
  num get totalPrice {
    _$totalPriceAtom.reportRead();
    return super.totalPrice;
  }

  @override
  set totalPrice(num value) {
    _$totalPriceAtom.reportWrite(value, super.totalPrice, () {
      super.totalPrice = value;
    });
  }

  final _$_ShopListViewModelBaseActionController =
      ActionController(name: '_ShopListViewModelBase');

  @override
  void setShopList(List<ShopListItem> shopList) {
    final _$actionInfo = _$_ShopListViewModelBaseActionController.startAction(
        name: '_ShopListViewModelBase.setShopList');
    try {
      return super.setShopList(shopList);
    } finally {
      _$_ShopListViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearShopList() {
    final _$actionInfo = _$_ShopListViewModelBaseActionController.startAction(
        name: '_ShopListViewModelBase.clearShopList');
    try {
      return super.clearShopList();
    } finally {
      _$_ShopListViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addShop(ShopListItem shopItem) {
    final _$actionInfo = _$_ShopListViewModelBaseActionController.startAction(
        name: '_ShopListViewModelBase.addShop');
    try {
      return super.addShop(shopItem);
    } finally {
      _$_ShopListViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeShop(ShopListItem shopItem) {
    final _$actionInfo = _$_ShopListViewModelBaseActionController.startAction(
        name: '_ShopListViewModelBase.removeShop');
    try {
      return super.removeShop(shopItem);
    } finally {
      _$_ShopListViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void increasePrice(int price) {
    final _$actionInfo = _$_ShopListViewModelBaseActionController.startAction(
        name: '_ShopListViewModelBase.increasePrice');
    try {
      return super.increasePrice(price);
    } finally {
      _$_ShopListViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decreasePrice(int price) {
    final _$actionInfo = _$_ShopListViewModelBaseActionController.startAction(
        name: '_ShopListViewModelBase.decreasePrice');
    try {
      return super.decreasePrice(price);
    } finally {
      _$_ShopListViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearShopListAndGetData() {
    final _$actionInfo = _$_ShopListViewModelBaseActionController.startAction(
        name: '_ShopListViewModelBase.clearShopListAndGetData');
    try {
      return super.clearShopListAndGetData();
    } finally {
      _$_ShopListViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
shopList: ${shopList},
totalPrice: ${totalPrice}
    ''';
  }
}
