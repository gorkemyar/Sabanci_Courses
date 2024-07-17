import 'package:flutter/material.dart';
import 'package:mobile/core/base/model/base_view_model.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/constants/navigation/navigation_constants.dart';
import 'package:mobile/core/init/navigation/navigation_service.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/categories/model/category_model.dart';
import 'package:mobile/view/categories/repository/category_repository.dart';
import 'package:mobx/mobx.dart';
part 'categories_view_model.g.dart';

class CategoriesViewModel = _CategoriesViewModelBase with _$CategoriesViewModel;

abstract class _CategoriesViewModelBase with Store, BaseViewModel {
  late CategoryRepository _repository;
  late CategoriesResponseModel _categoriesResponseModel;

  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    _repository = locator<CategoryRepository>();
  }

  @observable
  var categories = ObservableList<CategoryModel>();

  void dispose() {}

  @action
  void setCategories(List<CategoryModel> categories) {
    this.categories.clear();
    for (var category in categories) {
      addNewCategory(category);
    }
    this.categories.insert(0, this.categories[this.categories.length - 2]);
    this.categories.removeAt(this.categories.length - 2);
    //this.categories.removeLast();
  }

  @action
  void addNewCategory(CategoryModel category) {
    categories.add(category);
  }

  Future<bool> getData() async {
    _categoriesResponseModel = await _repository.getCategories(
      context: context,
    );

    if (_categoriesResponseModel.isSuccess ?? false) {
      setCategories(_categoriesResponseModel.data!);
    } else {
      showToast(
          context: context!,
          message: _categoriesResponseModel.message ??
              ApplicationConstants.ERROR_MESSAGE,
          isSuccess: false);
    }

    return _categoriesResponseModel.isSuccess!;
  }

  void navigateToCategory(CategoryModel category) {
    NavigationService.instance.navigateToPage(
      path: NavigationConstants.CATEGORY,
      data: category,
    );
  }
}
