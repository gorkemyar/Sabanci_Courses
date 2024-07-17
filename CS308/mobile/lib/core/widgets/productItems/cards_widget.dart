import 'package:flutter/material.dart';
import 'package:mobile/core/constants/image/image_constants.dart';
import 'package:mobile/core/init/icon/entypo.dart';
import 'package:mobile/core/init/icon/font_awesome5.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/view/payment/model/payment_model.dart';

class CardsWidget extends StatelessWidget {
  final PaymentModel payment;
  final VoidCallback onTap;
  const CardsWidget({Key? key, required this.payment, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            color: AppColors.gray,
            width: 0.75,
          ),
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _deleteButton(context),
            _chipImage(),
            _cardNumber(),
            _cardName()
          ],
        ),
      ),
    );
  }

  ElevatedButton _deleteButton(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(32, 32),
          padding: EdgeInsets.zero,
          maximumSize: const Size(32, 32),
          primary: AppColors.white,
          shadowColor: AppColors.lightGray,
          elevation: 2,
        ),
        onPressed: () => showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            builder: (BuildContext context) => FractionallySizedBox(
                  heightFactor: 0.625,
                  child: ConfirmDeleteCard(onPressed: onTap),
                )),
        child: const Icon(
          Entypo.trash,
          color: Colors.red,
          size: 16,
        ),
      );

  Padding _chipImage() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
        child: Image.asset(
          ImageConstants.instance.cardChip,
          width: 30,
        ),
      );

  Container _cardNumber() => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 8, bottom: 3),
        child: Text(
          payment.cardNumber ?? "**** **** **** ****",
          style: const TextStyle(
            color: AppColors.textColorGray,
            fontSize: 15.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  Container _cardName() => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 8),
        child: Text(
          payment.cardName!,
          style: const TextStyle(
            color: AppColors.darkGray,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
}

class ConfirmDeleteCard extends StatelessWidget {
  final VoidCallback onPressed;
  const ConfirmDeleteCard({Key? key, required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_indicator(), _warningIcon(), _message(), _buttons(context)],
      ),
    );
  }

  Container _indicator() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 12, 0, 36),
      width: 96,
      height: 8,
      decoration: BoxDecoration(
        color: const Color(0xFFECEDF5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Icon _warningIcon() {
    return const Icon(
      FontAwesome5.exclamation_triangle,
      size: 48,
      color: AppColors.primaryLight,
    );
  }

  Padding _message() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Text(
          "Are you sure you want to delete your card?",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.darkGray,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Row _buttons(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: AppColors.gray, width: 1.5),
                minimumSize: const Size(160, 48),
                padding: EdgeInsets.zero,
                maximumSize: const Size(160, 48),
                primary: AppColors.white,
                shadowColor: AppColors.transparent,
                elevation: 0,
              ),
              onPressed: () {
                debugPrint("Cancel clicked");
                Navigator.pop(context);
                //Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: AppColors.textColorGray,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(160, 48),
                padding: EdgeInsets.zero,
                maximumSize: const Size(160, 48),
                primary: AppColors.primary,
                shadowColor: AppColors.transparent,
                elevation: 0,
              ),
              onPressed: () {
                onPressed();
                Navigator.pop(context);
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ))
        ],
      );
}
