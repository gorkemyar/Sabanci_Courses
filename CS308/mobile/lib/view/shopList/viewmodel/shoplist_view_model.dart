import 'package:flutter/material.dart';
import 'package:mobile/core/base/model/base_view_model.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/constants/enums/locale_keys_enum.dart';
import 'package:mobile/core/constants/navigation/navigation_constants.dart';
import 'package:mobile/core/init/cache/locale_manager.dart';
import 'package:mobile/core/init/navigation/navigation_service.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/shopList/model/shoplist_model.dart';
import 'package:mobile/view/shopList/repository/shoplist_repository.dart';
import 'package:mobx/mobx.dart';
part 'shoplist_view_model.g.dart';

class ShopListViewModel = _ShopListViewModelBase with _$ShopListViewModel;

abstract class _ShopListViewModelBase with Store, BaseViewModel {
  late ShopListRepository _repository;
  late ShopListResponseModel _shopListResponseModel;
  late ShopListItemResponseModel _shopListItemResponseModel;

  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    _repository = locator<ShopListRepository>();
    //_repository.deleteShopList();
  }

  void dispose() {}

  @observable
  var shopList = ObservableList<ShopListItem>();

  @observable
  num totalPrice = 0;

  @action
  void setShopList(List<ShopListItem> shopList) {
    totalPrice = 0;
    this.shopList.clear();
    for (var shopItem in shopList) {
      addShop(shopItem);
    }
  }

  @action
  void clearShopList() {
    shopList.clear();
    totalPrice = 0;
  }

  @action
  void addShop(ShopListItem shopItem) {
    shopList.add(shopItem);
    increasePrice(shopItem.quantity! * shopItem.product!.price!.toInt());
  }

  @action
  void removeShop(ShopListItem shopItem) {
    shopList.remove(shopItem);
    decreasePrice(shopItem.quantity! * shopItem.product!.price!.toInt());
  }

  @action
  void increasePrice(int price) {
    totalPrice += price;
  }

  @action
  void decreasePrice(int price) {
    totalPrice -= price;
  }

  @action
  void clearShopListAndGetData() {
    clearShopList();
    getShopList();
  }

  Future<bool> increaseQuantity(ShopListItem shopItem) async {
    debugPrint('increaseQuantity');
    shopItem.quantity = shopItem.quantity! + 1;
    bool _isSucess = await updateShopListItem(shopItem);
    if (_isSucess) {
      increasePrice(shopItem.product!.price!.toInt());
    } else {
      shopItem.quantity = shopItem.quantity! - 1;
    }

    return _isSucess;
  }

  Future<bool> addQuantity(ShopListItem shopItem,
      {BuildContext? context}) async {
    debugPrint('addQuantity');
    ShopListItemResponseModel _item =
        await getShopListItem(shopItem.product!.id!);

    bool isExist = _item.isSuccess!;
    debugPrint('isExist: $isExist');
    if (isExist) {
      _item.data!.quantity = _item.data!.quantity! + shopItem.quantity!;
      bool _isSucess = await updateShopListItem(_item.data!, context: context);
      debugPrint('_isSucess: $_isSucess');
      if (_isSucess) {
        increasePrice(shopItem.product!.price!.toInt() * shopItem.quantity!);
      } else {
        _item.data!.quantity = _item.data!.quantity! - shopItem.quantity!;
      }
      return _isSucess;
    } else {
      bool _isSucess = await addShopListItem(shopItem,context: context);
      if (!_isSucess) {
        shopItem.quantity = shopItem.quantity! - shopItem.quantity!;
      }

      return _isSucess;
    }
  }

  Future<bool> decreaseQuantity(ShopListItem shopItem,
      {BuildContext? context}) async {
    debugPrint('decreaseQuantity');
    if (shopItem.quantity! > 1) {
      shopItem.quantity = shopItem.quantity! - 1;
      bool _isSucess = await updateShopListItem(shopItem, context: context);
      if (_isSucess) {
        decreasePrice(shopItem.product!.price!.toInt());
      } else {
        shopItem.quantity = shopItem.quantity! + 1;
      }
      return _isSucess;
    } else {
      bool _isSucess = await deleteShopListItem(shopItem);
      if (_isSucess) {
        removeShop(shopItem);
      } else {
        shopItem.quantity = shopItem.quantity! + 1;
      }
      return _isSucess;
    }
  }

  Future<bool> getShopList({BuildContext? context}) async {
    _shopListResponseModel = await _repository.getShopList(
      context: this.context,
    );
    if (_shopListResponseModel.isSuccess ?? false) {
      setShopList(_shopListResponseModel.data!);
    } else {
      showToast(
          context: context ?? this.context!,
          message: _shopListResponseModel.message ??
              ApplicationConstants.ERROR_MESSAGE,
          isSuccess: false);
    }

    return _shopListResponseModel.isSuccess!;
  }

  Future<bool> updateShopListItem(ShopListItem shopItem,
      {BuildContext? context}) async {
    _shopListItemResponseModel = await _repository.updateShopListItem(
      context: this.context,
      product: shopItem.product,
      quantity: shopItem.quantity,
    );
    if (!(_shopListItemResponseModel.isSuccess ?? false)) {
      showToast(
          context: context ?? this.context!,
          message: _shopListItemResponseModel.message ??
              ApplicationConstants.ERROR_MESSAGE,
          isSuccess: false);
    }

    return _shopListItemResponseModel.isSuccess!;
  }

  Future<bool> deleteShopListItem(ShopListItem shopItem,
      {BuildContext? context}) async {
    _shopListItemResponseModel = await _repository.deleteShopListItem(
      context: context,
      id: shopItem.product?.id,
    );

    if (!(_shopListItemResponseModel.isSuccess ?? false)) {
      showToast(
          context: context ?? this.context!,
          message: _shopListItemResponseModel.message ??
              ApplicationConstants.ERROR_MESSAGE,
          isSuccess: false);
    }

    return _shopListItemResponseModel.isSuccess!;
  }

  Future<bool> addShopListItem(ShopListItem shopItem,
      {BuildContext? context}) async {
    _shopListItemResponseModel = await _repository.addShopListItem(
      context: context,
      product: shopItem.product,
      quantity: shopItem.quantity,
    );

    if (_shopListItemResponseModel.isSuccess ?? false) {
      addShop(shopItem);
    } else {
      debugPrint("check");
      showToast(
          context: context ?? this.context!,
          message: _shopListItemResponseModel.message ??
              ApplicationConstants.ERROR_MESSAGE,
          isSuccess: false);
    }

    return _shopListItemResponseModel.isSuccess ?? false;
  }

  Future<ShopListItemResponseModel> getShopListItem(int id) async {
    _shopListItemResponseModel = await _repository.getShopListItem(
      context: context,
      id: id,
    );
    return _shopListItemResponseModel;
  }

  void navigateToPayment(BuildContext context) => totalPrice > 0
      ? NavigationService.instance.navigateToPage(
          path: (LocaleManager.instance
                          .getBoolValue(PreferencesKeys.IS_LOGINED) ??
                      false) ||
                  (LocaleManager.instance
                          .getBoolValue(PreferencesKeys.IS_REGISTERED) ??
                      false)
              ? NavigationConstants.PAYMENT
              : NavigationConstants.LOGIN_REQUIRED,
          data: "Please login to complete the purchase")
      : showToast(
          context: context,
          message: "Please add items to cart",
          isSuccess: false);
}
