import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/init/theme/color_theme.dart';

import 'app_theme.dart';

class AppThemeLight extends AppTheme {
  static AppThemeLight? _instance;
  static AppThemeLight get instance {
    return _instance ??= AppThemeLight._init();
  }

  AppThemeLight._init();

  @override
  ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: const Color(0xFFECEDF5),
        primaryColor: AppColors.primary,
        textTheme: textTheme,
        appBarTheme: appBarTheme,
        floatingActionButtonTheme: floatingActionButtonTheme,
        inputDecorationTheme: inputDecorationTheme,
        textButtonTheme: textButtonThemeData,
        elevatedButtonTheme: elevatedButtonTheme,
      );

  TextButtonThemeData get textButtonThemeData {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor:
            MaterialStateColor.resolveWith((states) => AppColors.primary),
        overlayColor:
            MaterialStateColor.resolveWith((states) => AppColors.transparent),
      ),
    );
  }

  TextTheme get textTheme {
    return const TextTheme(
      bodyText1: TextStyle(
        color: AppColors.primary,
      ),
      bodyText2: TextStyle(
        color: AppColors.primaryLight,
      ),
      subtitle1: TextStyle(
        color: AppColors.black,
      ),
    );
  }

  AppBarTheme get appBarTheme {
    return const AppBarTheme(
      color: AppColors.transparent,
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontSize: 20, color: AppColors.tertiary, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(
        color: AppColors.tertiary, //change your color here
      ),
      actionsIconTheme: IconThemeData(
        color: AppColors.tertiary, //change your color here
      ),
    );
  }

  InputDecorationTheme get inputDecorationTheme {
    return const InputDecorationTheme(
      labelStyle: TextStyle(
        color: Color(0xFF2C344F),
      ),
      hintStyle: TextStyle(
        color: Color(0xFF2C344F),
      ),
      errorStyle: TextStyle(
        color: Color(0xFF2C344F),
      ),
      helperStyle: TextStyle(
        color: Color(0xFF2C344F),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF2C344F),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF2C344F),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFF2C344F),
        ),
      ),
    );
  }

  FloatingActionButtonThemeData get floatingActionButtonTheme {
    return const FloatingActionButtonThemeData(
      backgroundColor: Colors.orange,
      elevation: 0,
    );
  }

  ElevatedButtonThemeData get elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(80, 48),
        primary:  AppColors.primary,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
