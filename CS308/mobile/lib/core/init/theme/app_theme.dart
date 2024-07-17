import 'package:flutter/material.dart';

abstract class AppTheme {
  ThemeData? theme;
}
class AvoidGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}