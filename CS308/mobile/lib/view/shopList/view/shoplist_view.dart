import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/core/base/state/base_state.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/extension/string_extension.dart';
import 'package:mobile/core/init/lang/locale_keys.g.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/shopList/viewmodel/shoplist_view_model.dart';
import 'package:mobile/core/widgets/productItems/shopping_cart_product.dart';

class ShopListView extends StatefulWidget {
  const ShopListView({Key? key}) : super(key: key);

  @override
  State<ShopListView> createState() => _ShopListViewState();
}

class _ShopListViewState extends BaseState<ShopListView> {
  late ShopListViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: locator<ShopListViewModel>(),
      onModelReady: (dynamic model) async {
        model.setContext(context);
        model.init();
        viewModel = model;
      },
      onPageBuilder: (context, value) {
        return FutureBuilder(
            future: viewModel.getShopList(),
            builder: ((context, snapshot) => snapshot.hasData
                ? Scaffold(
                    appBar: _appBar(),
                    body: _body(),
                  )
                : const Scaffold()));
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(LocaleKeys.shopList.locale),
      actions: [
        IconButton(
        onPressed: () => viewModel.navigateToPayment(context),
          icon: const Icon(Icons.payment),
        )
      ],
    );
  }

  Center _body() => Center(
          child: Observer(
        builder: (_) => Stack(
          children: <Widget>[
            viewModel.shopList.isNotEmpty
                ? RefreshIndicator(
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
                    child: ListView.builder(
                        itemCount: viewModel.shopList.length,
                        itemBuilder: (context, index) {
                          return Observer(builder: (_) {
                            return CartProduct(
                              shopItem: viewModel.shopList[index],
                              onIncrease: () => viewModel
                                  .increaseQuantity(viewModel.shopList[index]),
                              onDecrease: () => viewModel
                                  .decreaseQuantity(viewModel.shopList[index]),
                            );
                          });
                        }),
                  )
                : Container(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 90,
                decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            const TextSpan(
                                text: "Total: ",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                )),
                            TextSpan(
                                text: "${viewModel.totalPrice} TL",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ))
                          ])),
                          _completeShopping(context),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ));

  OutlinedButton _completeShopping(BuildContext context) => OutlinedButton(
        onPressed: () => viewModel.navigateToPayment(context),
        child: const Text(
          "Buy Now",
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.white,
            primary: AppColors.white,
            fixedSize: const Size(150, 50),
            side: const BorderSide(width: 1.0, color: AppColors.white)),
      );
}
