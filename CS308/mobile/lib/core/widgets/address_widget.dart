import 'package:flutter/material.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/view/address/model/adress_model.dart';

class AddressWidget extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onTap;
  const AddressWidget({
    Key? key,
    required this.address,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.gray,
            width: 0.5,
          )),
      child: _items(),
    );
  }

  Column _items() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _title(),
          const SizedBox(height: 16),
          _name(),
          _address(),
          _phone(),
          _buttons(),
        ],
      );

  Text _title() => Text(
        address.name!,
        style: const TextStyle(
            color: AppColors.textColorGray,
            fontWeight: FontWeight.w700,
            fontSize: 13.5),
      );

  Text _name() => Text(
        address.personalName!,
        style: const TextStyle(
            color: AppColors.darkGray,
            fontWeight: FontWeight.w700,
            fontSize: 15),
      );

  Padding _address() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          "${address.fullAddress}\n"
          "${address.city} / ${address.province}\n"
          "${address.country} / ${address.postalCode}",
          style: const TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w400,
              fontSize: 15),
        ),
      );

  Text _phone() => Text("${address.phoneNumber}",
      style: const TextStyle(
        color: AppColors.textColorGray,
        fontWeight: FontWeight.w700,
        fontSize: 15,
      ));

  Container _buttons() => Container(
        margin: const EdgeInsets.only(top: 16),
        width: double.infinity,
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _deleteButton(),
            //_editButton(),
          ],
        ),
      );

  // TextButton _editButton() => TextButton(
  //       child: const Text(
  //         "Edit",
  //         style: TextStyle(
  //           fontSize: 16,
  //           color: AppColors.darkGray,
  //         ),
  //       ),
  //       onPressed: () {
  //         debugPrint("Delete Button Clicked");
  //       },
  //     );

  ElevatedButton _deleteButton() => ElevatedButton(
        child: const Text(
          "Delete",
          style: TextStyle(fontSize: 16),
        ),
        onPressed: onTap,
      );
}
