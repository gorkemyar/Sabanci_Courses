import 'package:flutter/material.dart';
import 'package:mobile/core/constants/enums/locale_keys_enum.dart';
import 'package:mobile/core/init/cache/locale_manager.dart';
import 'package:mobile/core/widgets/login_requreid_widget.dart';
import 'package:mobile/view/account/view/account_view.dart';
import 'package:mobile/view/categories/view/categories_view.dart';
import 'package:mobile/view/favorites/view/favorites_view.dart';
import 'package:mobile/view/shopList/view/shoplist_view.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BottomBarView extends StatelessWidget {
  const BottomBarView({Key? key}) : super(key: key);

  List<Widget> _buildScreens() {
    return [
      //const HomeView(),
      const CategoriesView(),
      const ShopListView(),
      const FavoritesView(),
      (LocaleManager.instance.getBoolValue(PreferencesKeys.IS_LOGINED) ?? false) ||
      (LocaleManager.instance.getBoolValue(PreferencesKeys.IS_REGISTERED) ?? false)
          ? const AccountView()
          : const LoginRequired(message: "Please login to access profile features"),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      // PersistentBottomNavBarItem(
      //     icon: const Icon(Icons.home),
      //     inactiveIcon: const Icon(Icons.home_outlined),
      //     iconSize: 28,
      //     activeColorPrimary: const Color(0xFFFF6600),
      //     inactiveColorPrimary: const Color(0xFFD8D8D8)),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.grid_view_rounded),
          inactiveIcon: const Icon(Icons.grid_view_outlined),
          iconSize: 28,
          activeColorPrimary: const Color(0xFFFF6600),
          inactiveColorPrimary: const Color(0xFFD8D8D8)),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_cart),
          inactiveIcon: const Icon(Icons.shopping_cart_outlined),
          iconSize: 28,
          activeColorPrimary: const Color(0xFFFF6600),
          inactiveColorPrimary: const Color(0xFFD8D8D8)),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.favorite_rounded),
          inactiveIcon: const Icon(Icons.favorite_outline_rounded),
          iconSize: 28,
          activeColorPrimary: const Color(0xFFFF6600),
          inactiveColorPrimary: const Color(0xFFD8D8D8)),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.person_rounded),
          inactiveIcon: const Icon(Icons.person_outline_rounded),
          iconSize: 28,
          activeColorPrimary: const Color(0xFFFF6600),
          inactiveColorPrimary: const Color(0xFFD8D8D8))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _buildScreens(),
      items: _navBarItems(),
      handleAndroidBackButtonPress: true,
      navBarStyle: NavBarStyle.style14,
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
    );
  }
}
