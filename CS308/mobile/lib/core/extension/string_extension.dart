import 'package:easy_localization/easy_localization.dart';
import 'package:mobile/core/constants/app/app_constants.dart';

extension StringExtension on String {
  String get locale => this.tr();

  bool get isValidEmails =>
      RegExp(ApplicationConstants.EMAIL_REGEX).hasMatch(this);

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String titleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.capitalize())
      .join(' ');
}
