import 'package:flutter/material.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/core/widgets/productItems/track_product_big.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/categories/view/categories_shimmer_view.dart';
import 'package:mobile/view/orders/viewmodel/orders_view_model.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> with TickerProviderStateMixin {
  late OrdersViewModel viewModel;
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    controller.addListener(_setActiveTabIndex);
    super.initState();
  }

  void _setActiveTabIndex() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: locator<OrdersViewModel>(),
      onModelReady: (dynamic model) async {
        model.setContext(context);
        model.init();
        viewModel = model;
      },
      onPageBuilder: (context, value) {
        return FutureBuilder(
            future: viewModel.getOrders(context: context),
            builder: ((context, snapshot) => snapshot.hasData
                ? Scaffold(
                    appBar: _appBar(),
                    body: _body(),
                  )
                : const CategoriesShimmerView()));
      },
    );
  }

  AppBar _appBar() => AppBar(
        title: const Text("Order Tracking"),
      );

  Center _body({BuildContext? context}) => Center(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () {
            return Future.delayed(
              const Duration(seconds: 1),
              () {
                setState(() {
                  viewModel.init();
                  viewModel.getOrders(context: context);
                });
              },
            );
          },
          child: ListView(
            children: [
              ListView.builder(
                itemCount: viewModel.orders.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return TrackProductBig(
                    order: viewModel.orders[index],
                  );
                },
              ),
            ],
          ),
        ),
      );
}
