import 'package:flutter/material.dart';
import 'package:mobile/core/base/model/base_view_model.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/comments/model/comments_model.dart';
import 'package:mobile/view/product/model/product_model.dart';
import 'package:mobile/view/product/repository/product_repository.dart';
import 'package:mobx/mobx.dart';
part 'product_view_model.g.dart';

class ProductViewModel = _ProductViewModelBase with _$ProductViewModel;

abstract class _ProductViewModelBase with Store, BaseViewModel {
  late ProductModel product;
  late CommentsModelResponse comments;
  late ProductRepository _repository;
  late ProductResponseModel _productResponseModel;

  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    _repository = locator<ProductRepository>();
  }

  void dispose() {}

  @observable
  int quantity = 1;

  @action
  void incrementQuantity() {
    quantity++;
  }

  @action
  void decrementQuantity() {
    quantity--;
  }

  Future<bool> getData() async {
    _productResponseModel = await _repository.getProduct(
      context: context,
      id: product.id,
    );
    debugPrint(_productResponseModel.isSuccess.toString());
    if (_productResponseModel.isSuccess ?? false) {
      product = _productResponseModel.data!;
    } else {
      showToast(
          context: context!,
          message: _productResponseModel.message ??
              ApplicationConstants.ERROR_MESSAGE,
          isSuccess: false);
    }
    return _productResponseModel.isSuccess ?? false;
  }

  // void navigateToCommentsView(BuildContext context) =>
  //     pushNewScreenWithRouteSettings(
  //       context,
  //       screen: CommentsView(
  //         comments: comments,
  //       ),
  //       settings: const RouteSettings(name: NavigationConstants.COMMENTS),
  //       withNavBar: true,
  //       pageTransitionAnimation: PageTransitionAnimation.cupertino,
  //     );
}
