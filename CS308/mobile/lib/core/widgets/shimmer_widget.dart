// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final ShapeBorder shapeBorder;

  ShimmerWidget.rectangular({
    Key? key,
    this.width = double.infinity,
    this.radius = 0,
    required this.height,
  }) : shapeBorder = RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius));

  const ShimmerWidget.circular(
      {Key? key,
      this.radius = 0,
      required this.width,
      required this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: AppColors.secondary,
        highlightColor: Colors.grey.shade200,
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            shape: shapeBorder,
            color: AppColors.gray,
          ),
        ),
      );
}
