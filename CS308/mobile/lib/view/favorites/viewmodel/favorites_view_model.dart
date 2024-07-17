import 'package:flutter/material.dart';
import 'package:mobile/core/base/model/base_view_model.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/favorites/model/favorites_model.dart';
import 'package:mobile/view/favorites/repository/favorites_repository.dart';
import 'package:mobile/view/product/model/product_model.dart';
import 'package:mobile/view/product/repository/product_repository.dart';
import 'package:mobx/mobx.dart';
part 'favorites_view_model.g.dart';

class FavoritesViewModel = _FavoritesViewModelBase with _$FavoritesViewModel;

abstract class _FavoritesViewModelBase with Store, BaseViewModel {
  late FavoritesModel favorites;
  late FavoritesRepository _repository;
  late FavoritesResponseModel _favoritesResponseModel;
  late FavoriteItemResponseModel _favoriteItemResponseModel;
  late ProductRepository _repositoryProduct;
  late ProductResponseModel _productResponseModel;

  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    _repository = locator<FavoritesRepository>();
    _repositoryProduct = locator<ProductRepository>();
  }

  @observable
  var products = ObservableList<ProductModel>();

  @action
  void setProducts(List<ProductModel> products) {
    this.products.clear();
    for (var product in products) {
      addNewproduct(product);
    }
  }

  @action
  void addNewproduct(ProductModel product) {
    products.add(product);
  }

  @action
  submit() async {
    await addFavorite();
  }

  Future<void> addFavorite() async {
    _favoriteItemResponseModel =
        await _repository.setFavorite(
      context: context,
      productId: 3,
    );

    if (_favoriteItemResponseModel.isSuccess ?? false) {
      showToast(
          context: context!,
          message: _favoriteItemResponseModel.message ??
              ApplicationConstants.SUCCESS_MESSAGE,
          isSuccess: true);
    } else {
      showToast(
          context: context!,
          message: _favoriteItemResponseModel.message ??
              ApplicationConstants.ERROR_MESSAGE,
          isSuccess: false);
    }
  }

  void dispose() {}

  Future<bool> getData() async {
    _favoritesResponseModel = await _repository.getFavorites(
      context: context,
    );
    if (_favoritesResponseModel.isSuccess ?? false) {
      List<ProductModel> productList = [];
      for (var data in _favoritesResponseModel.data!) {
        _productResponseModel = await _repositoryProduct.getProduct(
          context: context,
          id: data.productId,
        );
        productList.add(_productResponseModel.data!);
      }
      setProducts(productList);
    } else {
      showToast(
          context: context!,
          message: _favoritesResponseModel.message ??
              ApplicationConstants.ERROR_MESSAGE,
          isSuccess: false);
    }
    return _favoritesResponseModel.isSuccess!;
  }
}
