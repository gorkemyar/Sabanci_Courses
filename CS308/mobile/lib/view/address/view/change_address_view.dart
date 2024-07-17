import 'package:flutter/material.dart';
import 'package:mobile/core/base/state/base_state.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/address/viewmodel/change_address_view_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ChangeAddressView extends StatefulWidget {
  const ChangeAddressView({Key? key}) : super(key: key);

  @override
  State<ChangeAddressView> createState() => _ChangeAddressViewState();
}

class _ChangeAddressViewState extends BaseState<ChangeAddressView> {
  late ChangeAddressViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: locator<ChangeAddressViewModel>(),
      onModelReady: (dynamic model) async {
        model.setContext(context);
        model.init();
        viewModel = model;
      },
      onPageBuilder: (context, value) {
        return Scaffold(
          appBar: _appBar(),
          body: _body(),
        );
      },
    );
  }

  AppBar _appBar() => AppBar(
        title: const Text("Add new address"),
      );

  SizedBox _body() => SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(),
                _personalTitle(),
                _nameContainer(),
                _phoneContainer(),
                _addressTitle(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Address",
                    style: TextStyle(
                      color: AppColors.textColorGray,
                      fontSize: 16,
                    ),
                  ),
                ),
                _infoForm(
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    controller: viewModel.adressController,
                    label: ""),
                _infoForm(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    controller: viewModel.cityController,
                    label: "City"),
                _infoForm(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    controller: viewModel.provinceController,
                    label: "State/Province/Region"),
                _infoForm(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    controller: viewModel.postalCodeController,
                    label: "Zip/Postal Code"),
                _infoForm(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    controller: viewModel.countryController,
                    label: "Country"),
                _addressNameContainer(),
                const SizedBox(height: 36),
                _buttons(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );

  Text _title() => const Text(
        "New Address",
        style: TextStyle(
          color: AppColors.textColorGray,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
      );

  Padding _personalTitle() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 32, 0, 12),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "01 Personal Information",
                style: TextStyle(
                    color: Colors.indigoAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                height: 0.5,
                width: 160,
                color: AppColors.darkGray,
              ),
            ]),
      );

  Column _nameContainer() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Information of the Receiver",
              style: TextStyle(
                color: AppColors.textColorGray,
                fontSize: 16,
              ),
            ),
          ),
          TextFormField(
            cursorColor: Colors.indigoAccent,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            autocorrect: false,
            controller: viewModel.nameController,
            decoration: const InputDecoration(
              hintText: "Name",
              filled: true,
              fillColor: AppColors.white,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          )
        ],
      );

  Padding _phoneContainer() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Receiver Phone Number",
                  style: TextStyle(
                    color: AppColors.textColorGray,
                    fontSize: 16,
                  ),
                ),
              ),
              Observer(builder: (_) {
                return TextFormField(
                  cursorColor: Colors.indigoAccent,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  autocorrect: false,
                  controller: viewModel.phoneController,
                  decoration: const InputDecoration(
                    hintText: "Phone Number",
                    filled: true,
                    fillColor: AppColors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide.none),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                );
              })
            ]),
      );

  Padding _addressTitle() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 32, 0, 12),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "02 Address Information",
                style: TextStyle(
                    color: Colors.indigoAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                height: 0.5,
                width: 160,
                color: AppColors.darkGray,
              ),
            ]),
      );

  Padding _infoForm(
          {required String label,
          required TextEditingController controller,
          required TextInputType keyboardType,
          required int maxLines}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: TextFormField(
          cursorColor: Colors.indigoAccent,
          maxLines: maxLines,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: AppColors.white,
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide.none),
            disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide.none),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      );

  Column _addressNameContainer() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Give this address a name",
              style: TextStyle(
                color: AppColors.textColorGray,
                fontSize: 16,
              ),
            ),
          ),
          TextFormField(
            cursorColor: Colors.indigoAccent,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            autocorrect: false,
            controller: viewModel.adressNameController,
            decoration: const InputDecoration(
              hintText: "Example: My Home, My Work etc.",
              filled: true,
              fillColor: AppColors.white,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          )
        ],
      );

  Row _buttons(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(160, 48),
                padding: EdgeInsets.zero,
                maximumSize: const Size(160, 48),
                primary: AppColors.primary,
                shadowColor: AppColors.transparent,
                elevation: 0,
              ),
              onPressed: () async{
                await viewModel.submit();
              },
              child: const Text(
                "Save Adress",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )),
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
        ],
      );
}
