// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:mobile/core/init/icon/font_awesome5.dart';
import 'package:mobile/core/extension/context_extension.dart';

class ToastMessage extends StatelessWidget {
  final String message;
  final bool isSuccess;
  const ToastMessage({Key? key, required this.message, required this.isSuccess})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: context.width-30,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isSuccess ? Colors.green.shade300 : Colors.redAccent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuccess ? FontAwesome5.check_circle : FontAwesome5.times_circle,
              color: const Color(0xFFFFFFFF),
            ),
            const SizedBox(
              width: 16.0,
            ),
            SizedBox(
              width: context.width - 110,
              child: Text(
                message,
                style: const TextStyle(color: Color(0xFFFFFFFF)),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showToast(
    {required String message,
    required bool isSuccess,
    required BuildContext context}) {
  showToastWidget(
      ToastMessage(
        message: message,
        isSuccess: isSuccess,
      ),
      animation: StyledToastAnimation.slideToTopFade,
      reverseAnimation: StyledToastAnimation.slideToTopFade,
      isHideKeyboard: true,
      context: context);
}
