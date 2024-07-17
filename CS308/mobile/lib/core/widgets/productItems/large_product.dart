import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/constants/image/image_constants.dart';
import 'package:mobile/core/constants/navigation/navigation_constants.dart';
import 'package:mobile/core/init/navigation/navigation_service.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/favorites/model/favorites_model.dart';
import 'package:mobile/view/favorites/repository/favorites_repository.dart';
import 'package:mobile/view/favorites/viewmodel/favorites_view_model.dart';
import 'package:mobile/view/product/model/product_model.dart';
import 'package:mobile/view/shopList/model/shoplist_model.dart';
import 'package:mobile/view/shopList/viewmodel/shoplist_view_model.dart';

class LargeProduct extends StatelessWidget {
  final ProductModel? product;
  const LargeProduct({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NavigationService.instance.navigateToPage(
        path: NavigationConstants.PRODUCT,
        data: product,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_content(context), _infos(), Container()],
          ),
        ),
      ),
    );
  }

  SizedBox _content(BuildContext context) {
    return SizedBox(
      child: Stack(children: [
        _image(),
        Container(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _favoriteButton(context),
              const SizedBox(height: 12),
              _shoppingCartButton(context),
            ],
          ),
        )
      ]),
    );
  }

  AspectRatio _image() {
    bool isExist = product?.photos?.isNotEmpty ?? false;
    return AspectRatio(
      aspectRatio: 1,
      child: CachedNetworkImage(
          imageUrl: isExist
              ? product!.photos!.first.photoUrl!
              : ApplicationConstants.PRODUCT_IMG,
          width: double.infinity,
          fit: BoxFit.fill,
          placeholder: (BuildContext context, String string) =>
              Image(image: AssetImage(ImageConstants.instance.logo))),
    );
  }

  InkWell _favoriteButton(BuildContext context) => InkWell(
        onTap: (() async {
          bool isAdded = false;
          FavoritesResponseModel _favoritesResponseModel;
          FavoritesRepository _favoritesRepository =
              locator<FavoritesRepository>();
          _favoritesResponseModel = await _favoritesRepository.getFavorites();
          for (var data in _favoritesResponseModel.data!) {
            if (data.productId == product?.id) {
              isAdded = true;
              break;
            }
          }
          if (isAdded) {
            _favoritesRepository.deleteFavorite(
              productId: product!.id,
            );
            if (_favoritesResponseModel.isSuccess ?? false) {
              showToast(
                  context: context,
                  message: _favoritesResponseModel.message ??
                      ApplicationConstants.SUCCESS_MESSAGE,
                  isSuccess: true);
            } else {
              showToast(
                  context: context,
                  message: _favoritesResponseModel.message ??
                      ApplicationConstants.ERROR_MESSAGE,
                  isSuccess: false);
            }
            showToast(
                message: "Item removed from favorites",
                isSuccess: true,
                context: context);
          } else {
            _favoritesRepository.setFavorite(
              productId: product!.id,
            );
            showToast(
                message: "Item added to favorites",
                isSuccess: true,
                context: context);
          }
        }),
        child: Container(
          height: 28,
          width: 28,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            color: AppColors.white,
          ),
          child: const Icon(
            Icons.star_border_rounded,
            size: 16,
          ),
        ),
      );

  InkWell _shoppingCartButton(BuildContext context) => InkWell(
        onTap: (() async {
          ShopListViewModel _shopList = locator<ShopListViewModel>();
          _shopList.init();
          bool _isSuccess = await _shopList.addQuantity(
              ShopListItem(quantity: 1, product: product),
              context: context);
          showToast(
              context: context,
              message: _isSuccess
                  ? "Product added to shopping cart"
                  : "You cannot add items more than there is in stock.",
              isSuccess: _isSuccess);
        }),
        child: Container(
          height: 28,
          width: 28,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            color: AppColors.primary,
          ),
          child: const Icon(
            Icons.add_shopping_cart_outlined,
            color: AppColors.white,
            size: 12,
          ),
        ),
      );

  SizedBox _infos() => SizedBox(
        height: 72,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [_producer(), _price()],
              ),
            ],
          ),
        ),
      );

  Text _title() {
    bool isExist = product?.title?.isNotEmpty ?? false;
    return Text(
      isExist ? product!.title! : "Wing Chair",
      textAlign: TextAlign.start,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: AppColors.tertiary,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Text _producer() {
    bool isExist = product?.distributor?.isNotEmpty ?? false;
    return Text(
      isExist ? product!.distributor! : "Goal Design",
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: AppColors.darkGray,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    );
  }

  Text _price() {
    bool isExist = product?.price?.isFinite ?? false;
    return Text(
      (isExist ? product!.price!.toString() : "380") + "₺",
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    );
  }
}
