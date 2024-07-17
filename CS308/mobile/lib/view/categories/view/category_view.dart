import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/core/base/state/base_state.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/extension/string_extension.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/core/widgets/productItems/large_product.dart';
import 'package:mobile/core/widgets/search_button.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/categories/model/category_model.dart';
import 'package:mobile/view/categories/view/categories_shimmer_view.dart';
import 'package:mobile/view/categories/viewmodel/category_view_model.dart';

class CategoryView extends StatefulWidget {
  final CategoryModel category;
  const CategoryView({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends BaseState<CategoryView> {
  late CategoryViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: locator<CategoryViewModel>(),
      onModelReady: (dynamic model) async {
        model.setContext(context);
        model.init();
        viewModel = model;
        viewModel.category = widget.category;
      },
      onPageBuilder: (context, value) {
        return FutureBuilder(
            future: viewModel.getData(),
            builder: ((context, snapshot) => snapshot.hasData
                ? Scaffold(
                    appBar: _appBar(),
                    body: _body(),
                  )
                : const CategoriesShimmerView()));
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(viewModel.category.title!.titleCase()),
      actions: [_filter()],
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
          child: SingleChildScrollView(
            child: Observer(builder: (_) {
              bool isEmpty = viewModel.products.isEmpty;
              return Column(
                children: [
                  const SearchButtonWidget(),
                  !isEmpty ? _gridView() : _notFound(),
                ],
              );
            }),
          ),
        ),
      );

  Center _notFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.search,
            size: 48,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 20, 12, 0),
            child: Text(
              "There are currently no products in this category.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.tertiary, fontSize: 22),
            ),
          )
        ],
      ),
    );
  }

  Observer _gridView() => Observer(builder: (_) {
        return GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 24 / 37,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          children: viewModel.products
              .map((product) => LargeProduct(product: product))
              .toList(),
        );
      });

  IconButton _filter() => IconButton(
        icon: const Icon(Icons.filter_list),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            builder: (context) => FractionallySizedBox(
              heightFactor: 0.625,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: Container(
                  color: Colors.white,
                  child: _filterBuilder(),
                ),
              ),
            ),
          );
        },
      );

  Container _indicator() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      width: 96,
      height: 8,
      decoration: BoxDecoration(
        color: const Color(0xFFECEDF5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  SingleChildScrollView _filterBuilder() => SingleChildScrollView(
        child: Column(
          children: [
            _indicator(),
            ExpansionPanelList.radio(
              //elevation: 0,
              children: [_sortBy()],
              dividerColor: AppColors.darkGray,
            ),
          ],
        ),
      );

  ExpansionPanelRadio _sortBy() {
    return ExpansionPanelRadio(
        value: "sort",
        canTapOnHeader: true,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return const ListTile(
            title: Text("Sort By"),
          );
        },
        body: Column(
          children: viewModel.sortItems.map((e) => _sortItem(e)).toList(),
        ));
  }

  Observer _sortItem(data) {
    return Observer(builder: (_) {
      return RadioListTile(
        groupValue: false,
        value: data["value"] != viewModel.sortBy,
        contentPadding: EdgeInsets.zero,
        onChanged: (sortBy) {
          viewModel.setSortBy(data["value"]);
          viewModel.sortProducts();
        },
        activeColor: AppColors.primary,
        title: Text(data["name"]),
      );
    });
  }
}
