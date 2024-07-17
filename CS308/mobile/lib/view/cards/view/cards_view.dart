import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/core/base/state/base_state.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/core/widgets/productItems/cards_widget.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/cards/viewmodel/cards_view_model.dart';

class CardsView extends StatefulWidget {
  const CardsView({Key? key}) : super(key: key);

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends BaseState<CardsView> {
  late int count = 1;
  late CardsViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: locator<CardsViewModel>(),
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
        title: const Text("Cards Method"),
      );

  SizedBox _body() => SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_title(), _cards()],
          ),
        ),
      );

  Padding _title() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 0, 24),
        child: Observer(builder: (_) {
          return Text(
            "My Saved Cards (${viewModel.payments.length})",
            style: const TextStyle(
              color: AppColors.darkGray,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          );
        }),
      );

  Padding _cards() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          height: 150,
          width: double.infinity,
          child: Observer(builder: (_) {
            return ListView.separated(
              primary: true,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.payments.length,
              itemBuilder: (context, index) => viewModel.payments
                  .map((e) => CardsWidget(
                        payment: e,
                        onTap: () => viewModel.deletePayment(
                            id: e.id!.toInt(), index: index),
                      ))
                  .toList()[index],
              separatorBuilder: (context, index) => const SizedBox(width: 16),
            );
          }),
        ),
      );
}
