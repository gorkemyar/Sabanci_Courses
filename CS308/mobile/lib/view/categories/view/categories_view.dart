import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/core/base/state/base_state.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/constants/image/image_constants.dart';
import 'package:mobile/core/extension/string_extension.dart';
import 'package:mobile/core/init/lang/locale_keys.g.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/core/widgets/search_button.dart';
import 'package:mobile/view/categories/model/category_model.dart';
import 'package:mobile/view/categories/view/categories_shimmer_view.dart';
import 'package:mobile/view/categories/viewmodel/categories_view_model.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends BaseState<CategoriesView> {
  late CategoriesViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: CategoriesViewModel(),
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
                : const CategoriesShimmerView()));
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(LocaleKeys.categories.locale),
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
            child: Column(
              children: [
                const SearchButtonWidget(),
                _gridView(),
              ],
            ),
          ),
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
            children: viewModel.categories
                .map((e) => _categoryContainer(e))
                .toList());
      });

  InkWell _categoryContainer(CategoryModel category) => InkWell(
        onTap: () => viewModel.navigateToCategory(category),
        child: Container(
          //padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0x19575B7D),
                spreadRadius: 0,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                      imageUrl: category.imageUrl!,
                      fit: BoxFit.fitHeight,
                      placeholder: (BuildContext context, String string) =>
                          Image(
                              image: AssetImage(ImageConstants.instance.logo))),
                ),
              ),
              Text(
                category.title!.titleCase(),
                style: const TextStyle(
                    height: 2,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.tertiary),
              )
            ],
          ),
        ),
      );
}
