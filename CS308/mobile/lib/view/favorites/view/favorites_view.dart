import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/core/base/state/base_state.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/extension/string_extension.dart';
import 'package:mobile/core/init/lang/locale_keys.g.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/core/widgets/productItems/large_product.dart';
import 'package:mobile/core/widgets/search_button.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/favorites/view/favorites_shimmer_view.dart';
import 'package:mobile/view/favorites/viewmodel/favorites_view_model.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends BaseState<FavoritesView> {
  late FavoritesViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: locator<FavoritesViewModel>(),
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
                : const FavoritesShimmerView()));
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(LocaleKeys.favorites.locale),
    );
  }

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
          child: ListView(children: [
            Column(
              children: [
                const SearchButtonWidget(),
                GridView.count(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  shrinkWrap: true,
                  childAspectRatio: 24 / 37,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: viewModel.products
                      .map((product) => LargeProduct(product: product))
                      .toList(),
                ),
              ],
            ),
          ]),
        ),
      );

  Observer _gridView() => Observer(builder: (_) {
        return GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          childAspectRatio: 4 / 5,
          crossAxisSpacing: 28,
          mainAxisSpacing: 24,
        );
      });
}
