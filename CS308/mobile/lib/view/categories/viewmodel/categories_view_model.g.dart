// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CategoriesViewModel on _CategoriesViewModelBase, Store {
  final _$categoriesAtom = Atom(name: '_CategoriesViewModelBase.categories');

  @override
  ObservableList<CategoryModel> get categories {
    _$categoriesAtom.reportRead();
    return super.categories;
  }

  @override
  set categories(ObservableList<CategoryModel> value) {
    _$categoriesAtom.reportWrite(value, super.categories, () {
      super.categories = value;
    });
  }

  final _$_CategoriesViewModelBaseActionController =
      ActionController(name: '_CategoriesViewModelBase');

  @override
  void setCategories(List<CategoryModel> categories) {
    final _$actionInfo = _$_CategoriesViewModelBaseActionController.startAction(
        name: '_CategoriesViewModelBase.setCategories');
    try {
      return super.setCategories(categories);
    } finally {
      _$_CategoriesViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addNewCategory(CategoryModel category) {
    final _$actionInfo = _$_CategoriesViewModelBaseActionController.startAction(
        name: '_CategoriesViewModelBase.addNewCategory');
    try {
      return super.addNewCategory(category);
    } finally {
      _$_CategoriesViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
categories: ${categories}
    ''';
  }
}
