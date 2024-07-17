import 'package:flutter/material.dart';
import 'package:mobile/core/base/model/base_view_model.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/product/model/product_model.dart';
import 'package:mobile/view/search/model/search_model.dart';
import 'package:mobile/view/search/repository/search_repository.dart';
import 'package:mobx/mobx.dart';
part 'search_view_model.g.dart';

class SearchViewModel = _SearchViewModelBase with _$SearchViewModel;

abstract class _SearchViewModelBase with Store, BaseViewModel {
  late ProductModel product;
  late SearchRepository _repository;
  late SearchResponseModel _searchResponseModel;

  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    searchNode.addListener(_listener);
    _repository = locator<SearchRepository>();
  }

  void dispose() {
    searchNode.removeListener(_listener);
  }

  FocusNode searchNode = FocusNode();

  @observable
  TextEditingController searchController = TextEditingController();

  @action
  void _listener() {
    isFocused = searchNode.hasFocus;
  }

  @observable
  bool isFocused = false;

  @observable
  bool isSearchEmpty = true;

  @observable
  bool isLoading = false;

  @observable
  var results = ObservableList<ProductModel>();

  var sortItems = [
    {"name": "None", "value": 0},
    {"name": "Popularity", "value": 1},
    {"name": "Price from high to low", "value": 2},
    {"name": "Price from low to hight", "value": 3},
  ];

  @action
  void setSortBy(int sortBy) => this.sortBy = sortBy;

  @observable
  int sortBy = 0;

  @action
  void setProducts(List<ProductModel> results) {
    this.results.clear();
    for (var product in results) {
      addNewproduct(product);
    }
  }

  @action
  sortProducts() {
    if (sortBy == 0) {
      setProducts(_searchResponseModel.data!);
    } else if (sortBy == 1) {
      results.sort((a, b) => b.commentCount!.compareTo(a.commentCount!));
    } else if (sortBy == 2) {
      results.sort((a, b) => b.price!.compareTo(a.price!));
    } else if (sortBy == 3) {
      results.sort((a, b) => a.price!.compareTo(b.price!));
    }
  }

  @action
  void addNewproduct(ProductModel product) {
    results.add(product);
  }

  @action
  void setSearchEmpty(bool value) => isSearchEmpty = value;

  @action
  void setLoading(bool value) => isLoading = value;

  @action
  Future<void> onTextChanged() async {
    setSearchEmpty(searchController.text.length < 3);
    if (!isSearchEmpty) {
      await search();
    }
  }

  Future<bool> search() async {
    setLoading(true);
    _searchResponseModel = await _repository.search(
      context: context,
      query: searchController.text,
    );

    if (_searchResponseModel.isSuccess ?? false) {
      setProducts(_searchResponseModel.data!);
      sortProducts();
      setLoading(false);
    } else {
      setLoading(false);
      showToast(
          context: context!,
          message: _searchResponseModel.message ??
              ApplicationConstants.ERROR_MESSAGE,
          isSuccess: false);
    }

    return _searchResponseModel.isSuccess ?? false;
  }
}
