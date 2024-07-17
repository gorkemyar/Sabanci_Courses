import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/core/base/state/base_state.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/constants/navigation/navigation_constants.dart';
import 'package:mobile/core/init/navigation/navigation_service.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/core/widgets/productItems/product_page_product.dart';
import 'package:mobile/view/favorites/model/favorites_model.dart';
import 'package:mobile/view/favorites/repository/favorites_repository.dart';
import 'package:mobile/view/product/model/product_model.dart';
import 'package:mobile/view/product/viewmodel/product_view_model.dart';
import 'package:mobile/view/shopList/model/shoplist_model.dart';
import 'package:mobile/view/shopList/viewmodel/shoplist_view_model.dart';

class ProductView extends StatefulWidget {
  final ProductModel product;
  const ProductView({Key? key, required this.product}) : super(key: key);
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends BaseState<ProductView> {
  late ProductViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView(
        viewModel: ProductViewModel(),
        onModelReady: (dynamic model) async {
          model.setContext(context);
          model.init();
          viewModel = model;
          viewModel.product = widget.product;
        },
        onPageBuilder: (context, value) {
          return Scaffold(
            appBar: _appBar(),
            body: _body(),
            bottomNavigationBar: _bottomNavBar(),
          );
        });

    /*Scaffold(
          appBar: _appBar(),
          body: _body(),
          bottomNavigationBar: Container(
            height: 100,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12.0),
                topLeft: Radius.circular(12.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                addToCart(),
                buyNow(),
              ],
            ),
          ),
        );*/
  }

  Container _bottomNavBar() {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.0),
          topLeft: Radius.circular(12.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          addToFavorites(),
          addToCart(),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: const BackButton(
        color: AppColors.black,
      ),
      title: const Text("Product Details"),
      actions: [
        IconButton(
          onPressed: () {
            NavigationService.instance
                .navigateToPage(path: NavigationConstants.SHOPLIST);
          },
          icon: const Icon(Icons.shopping_bag),
        )
      ],
    );
  }

  RefreshIndicator _body() => RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
            () {
              setState(() {
                viewModel.init();
              });
              viewModel.getData();
            },
          );
        },
        child: ListView(
          children: [
            RoundedContainer(
                child: Column(
              children: [
                PageProduct(product: viewModel.product),
              ],
            )),
          ],
        ),
      );

  OutlinedButton addToFavorites() => OutlinedButton(
        onPressed: () async {
          FavoritesRepository _favoritesRepository =
              locator<FavoritesRepository>();

          FavoriteItemResponseModel _response =
              await _favoritesRepository.setFavorite(
            productId: viewModel.product.id,
          );
          if (_response.isSuccess ?? false) {
            showToast(
                message: "Item added to favorites",
                isSuccess: true,
                context: context);
          } else {
            showToast(
                message: "Item already added to favorites",
                isSuccess: false,
                context: context);
          }
        },
        child: const Text(
          "Add To Favorites",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
            primary: AppColors.primary,
            fixedSize: const Size(150, 50),
            side: const BorderSide(width: 1.0, color: AppColors.white)),
      );

  Observer addToCart() => Observer(builder: (_) {
        return OutlinedButton(
          onPressed: () async {
            ShopListViewModel _shopList = locator<ShopListViewModel>();
            _shopList.init();
            bool _isSuccess = await _shopList.addQuantity(
                ShopListItem(
                  quantity: viewModel.quantity,
                  product: widget.product,
                ),
                context: context);
            showToast(
                context: context,
                message: _isSuccess
                    ? "Product added to shopping cart"
                    : "You cannot add items more than there is in stock.",
                isSuccess: _isSuccess);
          },
          child: const Text(
            "Add To Cart",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.white,
              primary: AppColors.white,
              fixedSize: const Size(150, 50),
              side: const BorderSide(width: 1.0, color: AppColors.white)),
        );
      });
}

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          )),
      child: child,
    );
  }
}
