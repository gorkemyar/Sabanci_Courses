import 'package:flutter/material.dart';
import 'package:mobile/core/base/model/base_view_model.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/constants/navigation/navigation_constants.dart';
import 'package:mobile/core/init/navigation/navigation_service.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/address/model/adress_model.dart';
import 'package:mobile/view/address/repository/address_repository.dart';
import 'package:mobile/view/payment/model/payment_model.dart';
import 'package:mobile/view/payment/repository/payment_repository.dart';
import 'package:mobile/view/shopList/viewmodel/shoplist_view_model.dart';
import 'package:mobx/mobx.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
part 'payment_view_model.g.dart';

class PaymentViewModel = _PaymentViewModelBase with _$PaymentViewModel;

abstract class _PaymentViewModelBase with Store, BaseViewModel {
  late PaymentRepository _repository;
  late PaymentResponseModel _paymentResponseModel;
  late PaymentsResponseModel _paymentsResponseModel;
  late AddressRepository _addressRepository;
  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    _repository = locator<PaymentRepository>();
    _addressRepository = locator<AddressRepository>();
  }

  void dispose() {}

  @observable
  var payments = ObservableList<PaymentModel>();
  var addresses = ObservableList<AddressModel>();

  void setPayments(List<PaymentModel> payments) {
    this.payments.clear();
    for (var payment in payments) {
      addNewPayment(payment);
    }
  }

  void setAddresses(List<AddressModel> addresses) {
    this.addresses.clear();
    for (var address in addresses) {
      addNewAddress(address);
    }
  }

  @action
  void addNewAddress(AddressModel address) {
    addresses.add(address);
  }

  @action
  void insertFirstPayment(PaymentModel payment) {
    payments.insert(0, payment);
  }

  @action
  void insertFirstAddress(AddressModel address) {
    addresses.insert(0, address);
  }

  @action
  void addNewPayment(PaymentModel payment) {
    payments.add(payment);
  }

  @action
  Future<void> deletePayment({required int index, required int id}) async {
    _paymentResponseModel = await _repository.deletePayment(
      context: context,
      id: id,
    );
    if (_paymentResponseModel.isSuccess ?? false) {
      payments.removeAt(index);
      showToast(
          context: context!,
          message: "Payment deleted successfully",
          isSuccess: false);
    } else {
      showToast(
          context: context!,
          message: _paymentResponseModel.message ??
              ApplicationConstants.ERROR_MESSAGE,
          isSuccess: false);
    }
  }

  Future<bool> getData() async {
    _paymentsResponseModel = await _repository.getPayments(
      context: context,
    );
    setPayments(_paymentsResponseModel.data!);
    AddressesResponseModel addressResponse =
        await _addressRepository.getAddresses(context: context);
    setAddresses(addressResponse.data!);
    print(addresses.length);
    return _paymentsResponseModel.isSuccess!;
  }

  @observable
  TextEditingController cardMethodController = TextEditingController();

  @observable
  TextEditingController cardNumberController = TextEditingController();
  @observable
  TextEditingController cardHolderController = TextEditingController();
  @observable
  TextEditingController cardSecurtiyController = TextEditingController();
  @observable
  TextEditingController cardDateController = TextEditingController();

  void navigateToAddAddress() => NavigationService.instance
      .navigateToPage(path: NavigationConstants.CHANGE_ADRESS);

  @observable
  int selectedAddress = 0;

  @observable
  int selectedCard = 0;

  @observable
  int cardButtonIndex = 0;

  @action
  submit() async {
    if (cardMethodController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid method",
          isSuccess: false);
    } else if (cardNumberController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid Card Number",
          isSuccess: false);
    } else if (cardHolderController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid Name on Card",
          isSuccess: false);
    } else if (cardSecurtiyController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid CVV/CVC",
          isSuccess: false);
    } else if (cardDateController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid postal card expiry date",
          isSuccess: false);
    } else {
      await addCards();
    }
  }

  Future<void> addCards() async {
    PaymentModel _payment = PaymentModel(
      paymentMethod: cardMethodController.text,
      cardNumber: cardNumberController.text,
      cardName: cardHolderController.text,
      cW: cardSecurtiyController.text,
      expiryDate: cardDateController.text,
    );

    PaymentResponseModel _paymentResponse = await _repository.setPayment(
      context: context,
      payment: _payment,
    );

    if (_paymentResponse.isSuccess ?? false) {
      showToast(
          message: "Card has been added", isSuccess: true, context: context!);
      insertFirstPayment(_payment);
      setSelectedCard(0);
      setCardButtonIndex(0);
    } else {
      showToast(
          message: "Card has not been added",
          isSuccess: false,
          context: context!);
    }
  }

  Future<void> order() async {
    PaymentResponseModel _paymentResponse = await _repository.order(
      context: context,
      addressId: addresses[selectedAddress].id,
      cardId: payments[selectedCard].id,
    );

    if (_paymentResponse.isSuccess ?? false) {
      locator<ShopListViewModel>().getShopList();
      Navigator.pop(context!);
    }
    showToast(
      message: "${_paymentResponse.message}",
      isSuccess: _paymentResponse.isSuccess ?? false,
      context: context!,
    );
  }

  @action
  void setSelectedCard(int index) => selectedCard = index;

  @action
  void setSelectedAddress(int index) => selectedAddress = index;

  @action
  void setCardButtonIndex(int index) => cardButtonIndex = index;
}
