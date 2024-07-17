import 'package:flutter/material.dart';
import 'package:mobile/core/base/state/base_state.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/extension/string_extension.dart';
import 'package:mobile/core/init/lang/locale_keys.g.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/core/widgets/customScrollPhysics.dart';
import 'package:mobile/core/widgets/productItems/advert_product.dart';
import 'package:mobile/core/widgets/productItems/highlight_product.dart';
import 'package:mobile/core/widgets/productItems/medium_product.dart';
import 'package:mobile/core/widgets/search_button.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/home/view/home_shimmer_view.dart';
import 'package:mobile/view/home/viewmodel/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends BaseState<HomeView> with TickerProviderStateMixin {
  late HomeViewModel viewModel;
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
      viewModel: locator<HomeViewModel>(),
      onModelReady: (dynamic model) async {
        model.setContext(context);
        model.init();
        viewModel = model;
      },
      onPageBuilder: (context, value) {
        return FutureBuilder(
            future: viewModel.load(),
            builder: ((context, snapshot) => snapshot.hasData
                ? Scaffold(
                    appBar: _appBar(),
                    body: _body(),
                  )
                : const HomeShimmerView()));      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(LocaleKeys.explore.locale),
    );
  }

  SizedBox _body() => SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SearchButtonWidget(),
              _advertisements(),
              _highlights(),
              _categories(),
              _categories(),
              const SizedBox(height: 12)
            ],
          ),
        ),
      );

  SizedBox _advertisements() => SizedBox(
        width: double.infinity,
        height: 240,
        child: TabBarView(
          controller: controller,
          children: const [
            AdvertProduct(),
            AdvertProduct(),
            AdvertProduct(),
          ],
        ),
      );

  SizedBox _highlights() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 340,
      child: ListView.builder(
        primary: true,
        scrollDirection: Axis.horizontal,
        physics: const CustomScrollPhysics(itemDimension: 296),
        itemCount: 5,
        itemBuilder: (context, index) => const HighlightProduct(),
      ),
    );
  }

  Container _categories() => Container(
        margin: const EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [_infos(), _productMediumContainer()],
        ),
      );

  SizedBox _productMediumContainer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 185,
      child: ListView.separated(
        primary: true,
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        padding: const EdgeInsets.only(left: 16, right: 16),
        itemBuilder: (context, index) => const MediumProduct(),
        separatorBuilder: (context, index) => const SizedBox(width: 16),
      ),
    );
  }

  Container _infos() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Popular Item",
            style: TextStyle(
              color: AppColors.tertiary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            onTap: (() {
              debugPrint("See All Button Clicked");
            }),
            child: const Text(
              "See All",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }
}
