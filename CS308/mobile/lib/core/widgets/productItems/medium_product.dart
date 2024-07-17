import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/navigation/navigation_constants.dart';
import 'package:mobile/core/init/navigation/navigation_service.dart';
import 'package:mobile/core/init/theme/color_theme.dart';

class MediumProduct extends StatelessWidget {
  const MediumProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NavigationService.instance
          .navigateToPage(path: NavigationConstants.PRODUCT),
      child: Container(
        width: 120,
        height: 185,
        decoration: const BoxDecoration(
          color: AppColors.white,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Column(children: [_content(), _infos()]),
        ),
      ),
    );
  }

  SizedBox _content() {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(children: [
        _image(),
        Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _favoriteButton(),
              const SizedBox(height: 12),
              _shoppingCartButton(),
            ],
          ),
        )
      ]),
    );
  }

  CachedNetworkImage _image() {
    return CachedNetworkImage(
      imageUrl:
          "http://employee-self-service.de/wp-content/themes/dante/images/default-thumb.png",
      width: 120,
      height: 120,
      fit: BoxFit.fill,
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

  SizedBox _infos() => SizedBox(
        height: 65,
        width: 120,
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

  Text _title() => const Text(
        "Wing Chair",
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColors.tertiary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );

  Text _producer() => const Text(
        "Goal Design",
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColors.darkGray,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      );

  Text _price() => const Text(
        "380₺",
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      );
}
