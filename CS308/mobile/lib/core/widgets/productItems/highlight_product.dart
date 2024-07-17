import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/init/theme/color_theme.dart';

class HighlightProduct extends StatelessWidget {
  const HighlightProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: 264,
        child: Stack(children: [
          _image(),
          _content(),
        ]),
      ),
    );
  }

  ClipRRect _image() => ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    child: CachedNetworkImage(
          imageUrl: ApplicationConstants.PRODUCT_IMG,
          width: 264,
          height: 340,
          fit: BoxFit.fill,
        ),
  );

  Padding _content() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _price(),
              _favoriteButton(),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _productInfo(),
              _shoppingCartButton(),
            ],
          )
        ],
      ),
    );
  }

  Container _price() {
    return Container(
      child: const Text(
        "580₺",
        style: TextStyle(
          color: AppColors.white,
        ),
      ),
      height: 22,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        color: AppColors.primary,
      ),
      padding: const EdgeInsets.fromLTRB(7.5, 2.5, 7.5, 2.5),
    );
  }

  InkWell _favoriteButton() => InkWell(
        onTap: (() {
          debugPrint("Favorite Button Clicked...");
        }),
        child: Container(
          height: 22,
          width: 22,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(11)),
            color: AppColors.white,
          ),
          child: const Icon(
            Icons.star_border_rounded,
            size: 16,
          ),
        ),
      );

  Container _productInfo() {
    return Container(
      alignment: Alignment.centerLeft,
      width: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'English or Club Sofa',
            softWrap: true,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            'Goal Design',
            softWrap: true,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  InkWell _shoppingCartButton() => InkWell(
        onTap: (() {
          debugPrint("Shopping Cart Button Clicked...");
        }),
        child: Container(
          height: 22,
          width: 22,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(11)),
            color: AppColors.primary,
          ),
          child: const Icon(
            Icons.add_shopping_cart_outlined,
            color: AppColors.white,
            size: 12,
          ),
        ),
      );
}
