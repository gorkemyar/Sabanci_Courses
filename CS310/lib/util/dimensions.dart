import 'package:flutter/material.dart';

class Dimen {
  static const double parentMargin = 16.0;
  static const double regularMargin = 8.0;

  static get regularParentPadding => const EdgeInsets.all(parentMargin);
  static get regularPadding => const EdgeInsets.all(regularMargin);
  static get regularPaddingLR => const EdgeInsets.symmetric(horizontal: regularMargin);
  static get regularParentPaddingLR => const EdgeInsets.symmetric(horizontal: parentMargin);
  static get regularPaddingTB => const EdgeInsets.symmetric(vertical: regularMargin);
  static get regularParentPaddingTB => const EdgeInsets.symmetric(vertical: parentMargin);
  static get regularDoubleParentPadding => const EdgeInsets.all(parentMargin*2);
  static get regularDoubleParentPaddingLR => const EdgeInsets.symmetric(horizontal: parentMargin*2);
  static get regularDoubleParentPaddingTB => const EdgeInsets.symmetric(vertical: parentMargin*2);
  static get moreHorizontal=>const EdgeInsets.fromLTRB(18, parentMargin, 18, parentMargin);


}