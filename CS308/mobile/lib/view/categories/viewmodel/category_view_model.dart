import 'package:flutter/material.dart';
import 'package:mobile/core/base/model/base_view_model.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/categories/model/category_model.dart';
import 'package:mobile/view/categories/repository/category_repository.dart';
import 'package:mobile/view/product/model/product_model.dart';
import 'package:mobx/mobx.dart';
part 'category_view_model.g.dart';

class CategoryViewModel = _CategoryViewModelBase with _$CategoryViewModel;

abstract class _CategoryViewModelBase with Store, BaseViewModel {
  late CategoryModel category;
  late CategoryRepository _repository;
  late CategoryResponseModel _categoryResponseModel;

  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    _repository = locator<CategoryRepository>();
  }

  @observable
  var products = ObservableList<ProductModel>();

  var sortItems = [
    {"name": "None", "value": 0},
    {"name": "Popularity", "value": 1},
    {"name": "Price from high to low", "value": 2},
    {"name": "Price from low to hight", "value": 3},
  ];

  @observable
  int sortBy = 0;

  @action
  void setSortBy(int sortBy) => this.sortBy = sortBy;

  @action
  void setProducts(List<ProductModel> products) {
    this.products.clear();
    for (var product in products) {
      addNewproduct(product);
    }
    
  }

  @action
  sortProducts() {
    if (sortBy == 0) {
      setProducts(_categoryResponseModel.data!.products!);
    } else if (sortBy == 1) {
      products.sort((a, b) => b.commentCount!.compareTo(a.commentCount!));
    } else if (sortBy == 2) {
      products.sort((a, b) => b.price!.compareTo(a.price!));
    } else if (sortBy == 3) {
      products.sort((a, b) => a.price!.compareTo(b.price!));
    }
  }

  @action
  void addNewproduct(ProductModel product) {
    products.add(product);
  }

  Future<bool> getData() async {
    _categoryResponseModel = await _repository.getCategory(
      context: context,
      id: category.id,
    );
    if (_categoryResponseModel.isSuccess ?? false) {
      setProducts(_categoryResponseModel.data!.products!);
    } else {
      showToast(
          context: context!,
          message: _categoryResponseModel.message ??
              ApplicationConstants.ERROR_MESSAGE,
          isSuccess: false);
    }
    return _categoryResponseModel.isSuccess!;
  }

  List<String> getSubcategories() {
    return category.subcategories!.map((e) => e.title!).toList();
  }
}
