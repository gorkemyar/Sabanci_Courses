import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/core/base/state/base_state.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/constants/navigation/navigation_constants.dart';
import 'package:mobile/core/init/navigation/navigation_service.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/core/widgets/address_widget.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/address/viewmodel/address_view_model.dart';

class AddressView extends StatefulWidget {
  const AddressView({Key? key}) : super(key: key);

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends BaseState<AddressView> {
  late AddressViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: locator<AddressViewModel>(),
      onModelReady: (dynamic model) async {
        model.setContext(context);
        model.init();
        viewModel = model;
      },
      onPageBuilder: (context, value) {
        return FutureBuilder(
            future: viewModel.getData(),
            builder: ((context, snapshot) => snapshot.hasData
                ? Scaffold(
                    appBar: _appBar(),
                    body: _body(),
                  )
                : const Scaffold()));
      },
    );
  }

  AppBar _appBar() => AppBar(
        title: const Text("Shipping Address"),
      );

  SizedBox _body() => SizedBox(
        width: double.infinity,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () {
            return Future.delayed(
              const Duration(seconds: 1),
              () {
                setState(() {
                  viewModel.init();
                });
              },
            );
          },
          child: SingleChildScrollView(
            child: Column(
              children: [_title(), _newAdress(), _adresses()],
            ),
          ),
        ),
      );

  Padding _title() => Padding(
        padding: const EdgeInsets.all(15),
        child: Observer(builder: (_) {
          return Text(
            "You have ${viewModel.addresses.length} delivery "
            "addresses. From this page, you can create a new address, edit or "
            "delete your existing addresses.\nAddress changes "
            "you make on this page will not affect your previous orders.",
            style: const TextStyle(
              color: AppColors.textColorGray,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          );
        }),
      );

  Container _newAdress() => Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.gray,
              width: 0.5,
            )),
        child: InkWell(
          onTap: () {
            NavigationService.instance
                .navigateToPage(path: NavigationConstants.CHANGE_ADRESS);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: const [
              Icon(
                Icons.add_location_alt_outlined,
                size: 36,
                color: AppColors.darkGray,
              ),
              Text(
                "Add new shipping address",
                style: TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      );

  Observer _adresses() => Observer(builder: (_) {
        return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            primary: true,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => viewModel.addresses
                .map((e) => AddressWidget(
                      address: e,
                      onTap: () => viewModel.deleteAddress(
                          id: e.id!.toInt(), index: index),
                    ))
                .toList()[index],
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: viewModel.addresses.length);
      });
}
