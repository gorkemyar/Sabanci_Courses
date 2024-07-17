import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/base/state/base_state.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/constants/image/image_constants.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/address/model/adress_model.dart';
import 'package:mobile/view/payment/model/payment_model.dart';
import 'package:mobile/view/payment/viewmodel/payment_view_model.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/view/shopList/viewmodel/shoplist_view_model.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({Key? key}) : super(key: key);

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends BaseState<PaymentView> {
  late PaymentViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: locator<PaymentViewModel>(),
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
                  bottomNavigationBar: _bottomNavBar(),
                )
              : const Scaffold()),
        );
      },
    );
  }

  BottomAppBar _bottomNavBar() => BottomAppBar(
        child: SizedBox(
          height: 96,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "AMOUNT TO BE PAID",
                          style: TextStyle(
                            color: AppColors.darkGray,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Observer(builder: (_) {
                          return Text(
                            locator<ShopListViewModel>().totalPrice.toString() +
                                " TL",
                            style: const TextStyle(
                              color: AppColors.textColorGray,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        })
                      ],
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(180, 64),
                        ),
                        onPressed: () => viewModel.order(),
                        child: const Text(
                          "Confirm cart",
                          style: TextStyle(
                            color: AppColors.white,
                            //letterSpacing: 0.8,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  AppBar _appBar() => AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield, color: Colors.green[800]),
            const SizedBox(
              width: 4,
            ),
            Text(
              "Safety Shopping",
              style: TextStyle(color: Colors.green[800]),
            )
          ],
        ),
      );

  SizedBox _body() => SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _addressTitle(),
                _addNewAddress(),
                _addressList(),
                _paymentTitle(),
                _cardButtons(),
                _cardContainer()
              ],
            ),
          ),
        ),
      );

  Text _addressTitle() => const Text(
        "Delivery Address",
        style: TextStyle(
          color: AppColors.textColorGray,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      );

  TextButton _addNewAddress() => TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 24)),
      onPressed: () => viewModel.navigateToAddAddress(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(Icons.add_circle_outline),
          SizedBox(
            width: 8,
          ),
          Text("Add New Address")
        ],
      ));

  SizedBox _addressList() => SizedBox(
        height: 150,
        width: double.infinity,
        child: ListView.separated(
          primary: true,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => _addresContainer(context, index),
          separatorBuilder: (context, index) => const SizedBox(width: 16),
          itemCount: viewModel.addresses.length,
        ),
      );

  InkWell _addresContainer(BuildContext context, int index) => InkWell(
        onTap: (() => viewModel.setSelectedAddress(index)),
        child: Observer(builder: (_) {
          return Container(
            width: 200,
            decoration: viewModel.selectedAddress == index
                ? _selectedDecoration
                : _unselectedDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    viewModel.selectedAddress == index
                        ? _selectedAddressIcon
                        : const SizedBox(),
                    _addressEditButton()
                  ],
                ),
                _addressName(viewModel.addresses[index], index),
                _addressText(viewModel.addresses[index], index),
              ],
            ),
          );
        }),
      );

  BoxDecoration get _unselectedDecoration => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.gray,
          width: 0.75,
        ),
      );

  BoxDecoration get _selectedDecoration => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.indigo,
          width: 5,
        ),
      );

  Container get _selectedAddressIcon => Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(8)),
          color: Colors.indigo,
        ),
        child: const Icon(
          Icons.check,
          color: AppColors.white,
        ),
      );

  TextButton _addressEditButton() => TextButton(
        style: TextButton.styleFrom(
            alignment: Alignment.topCenter,
            minimumSize: const Size(40, 18),
            elevation: 0),
        onPressed: (() {
          debugPrint("Edit Button clicked");
        }),
        child: const Text(
          //"Edit",
          "",
          style: TextStyle(
            color: AppColors.textColorGray,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Padding _addressName(AddressModel address, int index) => Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          address.personalName!,
          style: const TextStyle(
            color: AppColors.textColorGray,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Padding _addressText(AddressModel address, int index) => Padding(
        padding: const EdgeInsets.only(left: 8, top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address.fullAddress!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.darkGray,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              address.city! + "/" + address.province!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.darkGray,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );

  Padding _paymentTitle() => const Padding(
        padding: EdgeInsets.only(top: 36),
        child: Text(
          "Payment Method",
          style: TextStyle(
            color: AppColors.textColorGray,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Padding _cardButtons() => Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Container(
            height: 40,
            width: double.infinity,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppColors.gray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                _cardButton(0, "Saved Cards"),
                _cardButton(1, "Add New Card"),
              ],
            )),
      );

  InkWell _cardButton(
    int index,
    String title,
  ) =>
      InkWell(
        onTap: (() => viewModel.cardButtonIndex = index),
        child: Observer(builder: (_) {
          return Container(
            height: 36,
            width: 165.5,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: viewModel.cardButtonIndex == index
                  ? AppColors.white
                  : AppColors.transparent,
              border: Border.all(color: AppColors.gray),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textColorGray,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }),
      );

  Observer _cardContainer() => Observer(
      builder: (_) => viewModel.cardButtonIndex == 0
          ? _savedCardsContainer()
          : _addNewCardContainer());

  Container _savedCardsContainer() => Container(
        height: 150,
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(8, 16, 8, 0),
        child: Observer(builder: (_) {
          return ListView.separated(
            primary: true,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) =>
                _savedCard(viewModel.payments[index], index),
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemCount: viewModel.payments.length,
          );
        }),
      );

  InkWell _savedCard(PaymentModel payment, int index) => InkWell(
        onTap: (() => viewModel.setSelectedCard(index)),
        child: Observer(builder: (_) {
          return Container(
            width: 200,
            decoration: viewModel.selectedCard == index
                ? _selectedDecoration
                : _unselectedDecoration,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    viewModel.selectedCard == index
                        ? _selectedAddressIcon
                        : const SizedBox(
                            height: 32,
                          ),
                  ],
                ),
                _chipImage(),
                _cardNumber(payment.cardNumber),
                _cardName(payment.cardName),
              ],
            ),
          );
        }),
      );

  Padding _chipImage() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
        child: Image.asset(
          ImageConstants.instance.cardChip,
          width: 30,
        ),
      );

  Container _cardNumber(String? text) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16, bottom: 3, top: 16),
        child: Text(
          text ?? "**** **** **** ****",
          style: const TextStyle(
            color: AppColors.textColorGray,
            fontSize: 15.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  Container _cardName(String? text) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 16),
        child: Text(
          text ?? "Charles Leclerc",
          style: const TextStyle(
            color: AppColors.darkGray,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

  Padding _addNewCardContainer() => Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardForm(
            title: "Card Name",
            hintText: "Payment Method Name",
            keyboardType: TextInputType.text,
            controller: viewModel.cardMethodController,
          ),
          _cardFormNumber(
            title: "Card Number",
            hintText: "**** **** **** ***",
            keyboardType: TextInputType.number,
            controller: viewModel.cardNumberController,
          ),
          _cardForm(
            title: "Name on the Card",
            hintText: "Card Holder's Name and Surname",
            keyboardType: TextInputType.text,
            controller: viewModel.cardHolderController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 165.5,
                child: _cardForm(
                  title: "Expiration date",
                  hintText: "Month / Year",
                  keyboardType: TextInputType.text,
                  controller: viewModel.cardDateController,
                ),
              ),
              SizedBox(
                width: 165.5,
                child: _cardForm(
                  title: "Security Code",
                  hintText: "CVC/CVV",
                  keyboardType: TextInputType.text,
                  controller: viewModel.cardSecurtiyController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(160, 48),
                padding: EdgeInsets.zero,
                maximumSize: const Size(160, 48),
                primary: AppColors.primary,
                shadowColor: AppColors.transparent,
                elevation: 0,
              ),
              onPressed: () async {
                await viewModel.submit();
              },
              child: const Text(
                "Save Card",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )),
        ],
      ));

  Column _cardForm({
    required String title,
    required String hintText,
    required TextInputType keyboardType,
    required TextEditingController controller,
  }) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textColorGray,
                fontSize: 16,
              ),
            ),
          ),
          TextFormField(
            cursorColor: Colors.indigoAccent,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: AppColors.white,
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none),
              disabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          )
        ],
      );

  Column _cardFormNumber({
    required String title,
    required String hintText,
    required TextInputType keyboardType,
    required TextEditingController controller,
  }) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textColorGray,
                fontSize: 16,
              ),
            ),
          ),
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CardNumberFormatter(),
            ],
            maxLength: 19,
            cursorColor: Colors.indigoAccent,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: AppColors.white,
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none),
              disabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          )
        ],
      );
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue previousValue,
    TextEditingValue nextValue,
  ) {
    var inputText = nextValue.text;

    if (nextValue.selection.baseOffset == 0) {
      return nextValue;
    }

    var bufferString = StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString();
    return nextValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}
