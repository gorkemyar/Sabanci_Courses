import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/core/base/state/base_state.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/extension/string_extension.dart';
import 'package:mobile/core/init/icon/entypo.dart';
import 'package:mobile/core/init/lang/locale_keys.g.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/account/viewmodel/account_view_model.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends BaseState<AccountView> {
  late AccountViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: locator<AccountViewModel>(),
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

  AppBar _appBar() {
    return AppBar(
      title: Text(LocaleKeys.account.locale),
      actions: [
        IconButton(
            onPressed: () => debugPrint("Setting clicked"),
            icon: const Icon(Icons.settings_outlined))
      ],
    );
  }

  Center _body() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _image(),
            _name(),
            const SizedBox(height: 20),
            ProfileButtons(
                icon: Icons.account_balance_wallet,
                titles: "My Purchases",
                action: () => viewModel.navigateToOrders(context)),
            ProfileButtons(
                icon: Icons.location_on_sharp,
                titles: "My Adress",
                action: () => viewModel.navigateToAdressView(context)),
            ProfileButtons(
                icon: Entypo.credit_card,
                titles: "Payment Method",
                action: () => viewModel.navigateToCardsView(context)),
            const SizedBox(height: 92),
            // ProfileButtons(
            //     icon: Icons.settings_outlined,
            //     titles: "Settings",
            //     action: () => debugPrint("Clicked Setting")),
            ProfileButtons(
                icon: Icons.logout,
                titles: "Logout",
                bgColor: AppColors.primary,
                iconBgColor: AppColors.white,
                textColor: AppColors.white,
                action: () => viewModel.logout()),
          ],
        ),
      );

  Container _image() => Container(
      margin: const EdgeInsets.fromLTRB(0, 20, 0, 16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      width: 112,
      height: 112,
      child: Container(
        margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(52),
          child: Image.network(ApplicationConstants.PROFILE_IMG),
        ),
      ));

  Observer _name() => Observer(builder: (_) {
        return Text(
          "${viewModel.user.fullName != "" ? viewModel.user.fullName : "User"}",
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.tertiary),
        );
      });
}

class ProfileButtons extends StatelessWidget {
  final String titles;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final Color iconBgColor;
  final VoidCallback action;

  const ProfileButtons(
      {Key? key,
      required this.icon,
      required this.titles,
      required this.action,
      this.bgColor = AppColors.white,
      this.iconBgColor = const Color(0xfffae0cd),
      this.textColor = AppColors.tertiary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              titles,
              style: TextStyle(
                color: textColor,
                fontSize: 16.5,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
