import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/init/theme/color_theme.dart';

class AdvertProduct extends StatelessWidget {
  const AdvertProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      width: MediaQuery.of(context).size.width - 32,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Stack(
          children: [_image(), _content()],
        ),
      ),
    );
  }

  ClipRRect _image() => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: CachedNetworkImage(
          imageUrl: ApplicationConstants.PRODUCT_IMG,
          width: double.infinity,
          height: 240,
          fit: BoxFit.fill,
        ),
      );

  Padding _content() => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _type(),
              _texts(),
              _shopButton(),
            ]),
      );

  Container _type() {
    return Container(
      child: const Text(
        "New",
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      height: 20,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        color: AppColors.primary,
      ),
      padding: const EdgeInsets.fromLTRB(7.5, 2.5, 7.5, 2.5),
    );
  }

  SizedBox _texts() => SizedBox(
        width: 125,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_title(), const SizedBox(height: 8), _info()],
        ),
      );

  Text _title() => const Text(
        "Cyber Monday",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          fontSize: 15,
        ),
      );

  Text _info() => const Text(
        "Sales Up To 70% Off",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.white,
          fontSize: 20,
        ),
      );

  Container _shopButton() {
    return Container(
      child: const Text(
        "Shop Now",
        style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      height: 32,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: AppColors.primary,
      ),
      padding: const EdgeInsets.fromLTRB(8, 8.5, 8, 8.5),
    );
  }
}
