// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SearchViewModel on _SearchViewModelBase, Store {
  final _$searchControllerAtom =
      Atom(name: '_SearchViewModelBase.searchController');

  @override
  TextEditingController get searchController {
    _$searchControllerAtom.reportRead();
    return super.searchController;
  }

  @override
  set searchController(TextEditingController value) {
    _$searchControllerAtom.reportWrite(value, super.searchController, () {
      super.searchController = value;
    });
  }

  final _$isFocusedAtom = Atom(name: '_SearchViewModelBase.isFocused');

  @override
  bool get isFocused {
    _$isFocusedAtom.reportRead();
    return super.isFocused;
  }

  @override
  set isFocused(bool value) {
    _$isFocusedAtom.reportWrite(value, super.isFocused, () {
      super.isFocused = value;
    });
  }

  final _$isSearchEmptyAtom = Atom(name: '_SearchViewModelBase.isSearchEmpty');

  @override
  bool get isSearchEmpty {
    _$isSearchEmptyAtom.reportRead();
    return super.isSearchEmpty;
  }

  @override
  set isSearchEmpty(bool value) {
    _$isSearchEmptyAtom.reportWrite(value, super.isSearchEmpty, () {
      super.isSearchEmpty = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_SearchViewModelBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$resultsAtom = Atom(name: '_SearchViewModelBase.results');

  @override
  ObservableList<ProductModel> get results {
    _$resultsAtom.reportRead();
    return super.results;
  }

  @override
  set results(ObservableList<ProductModel> value) {
    _$resultsAtom.reportWrite(value, super.results, () {
      super.results = value;
    });
  }

  final _$sortByAtom = Atom(name: '_SearchViewModelBase.sortBy');

  @override
  int get sortBy {
    _$sortByAtom.reportRead();
    return super.sortBy;
  }

  @override
  set sortBy(int value) {
    _$sortByAtom.reportWrite(value, super.sortBy, () {
      super.sortBy = value;
    });
  }

  final _$onTextChangedAsyncAction =
      AsyncAction('_SearchViewModelBase.onTextChanged');

  @override
  Future<void> onTextChanged() {
    return _$onTextChangedAsyncAction.run(() => super.onTextChanged());
  }

  final _$_SearchViewModelBaseActionController =
      ActionController(name: '_SearchViewModelBase');

  @override
  void _listener() {
    final _$actionInfo = _$_SearchViewModelBaseActionController.startAction(
        name: '_SearchViewModelBase._listener');
    try {
      return super._listener();
    } finally {
      _$_SearchViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSortBy(int sortBy) {
    final _$actionInfo = _$_SearchViewModelBaseActionController.startAction(
        name: '_SearchViewModelBase.setSortBy');
    try {
      return super.setSortBy(sortBy);
    } finally {
      _$_SearchViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setProducts(List<ProductModel> results) {
    final _$actionInfo = _$_SearchViewModelBaseActionController.startAction(
        name: '_SearchViewModelBase.setProducts');
    try {
      return super.setProducts(results);
    } finally {
      _$_SearchViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic sortProducts() {
    final _$actionInfo = _$_SearchViewModelBaseActionController.startAction(
        name: '_SearchViewModelBase.sortProducts');
    try {
      return super.sortProducts();
    } finally {
      _$_SearchViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addNewproduct(ProductModel product) {
    final _$actionInfo = _$_SearchViewModelBaseActionController.startAction(
        name: '_SearchViewModelBase.addNewproduct');
    try {
      return super.addNewproduct(product);
    } finally {
      _$_SearchViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchEmpty(bool value) {
    final _$actionInfo = _$_SearchViewModelBaseActionController.startAction(
        name: '_SearchViewModelBase.setSearchEmpty');
    try {
      return super.setSearchEmpty(value);
    } finally {
      _$_SearchViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_SearchViewModelBaseActionController.startAction(
        name: '_SearchViewModelBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_SearchViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchController: ${searchController},
isFocused: ${isFocused},
isSearchEmpty: ${isSearchEmpty},
isLoading: ${isLoading},
results: ${results},
sortBy: ${sortBy}
    ''';
  }
}
