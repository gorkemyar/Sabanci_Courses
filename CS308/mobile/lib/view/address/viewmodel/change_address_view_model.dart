import 'package:flutter/material.dart';
import 'package:mobile/core/base/model/base_view_model.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/address/model/adress_model.dart';
import 'package:mobile/view/address/repository/address_repository.dart';
import 'package:mobile/view/address/viewmodel/address_view_model.dart';
import 'package:mobx/mobx.dart';
part 'change_address_view_model.g.dart';

class ChangeAddressViewModel = _ChangeAddressViewModelBase
    with _$ChangeAddressViewModel;

abstract class _ChangeAddressViewModelBase with Store, BaseViewModel {
  late AddressRepository _repository;

  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    _repository = locator<AddressRepository>();
  }

  void dispose() {}

  @action
  void _listener() {}

  @observable
  TextEditingController nameController = TextEditingController();

  @observable
  TextEditingController phoneController = TextEditingController();

  @observable
  TextEditingController provinceController = TextEditingController();

  @observable
  TextEditingController cityController = TextEditingController();

  @observable
  TextEditingController postalCodeController = TextEditingController();

  @observable
  TextEditingController countryController = TextEditingController();

  @observable
  TextEditingController adressController = TextEditingController();

  @observable
  TextEditingController adressNameController = TextEditingController();

  @action
  submit() async {
    if (nameController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid name",
          isSuccess: false);
    } else if (phoneController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid phone",
          isSuccess: false);
    } else if (provinceController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid province",
          isSuccess: false);
    } else if (cityController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid city",
          isSuccess: false);
    } else if (postalCodeController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid postal code",
          isSuccess: false);
    } else if (countryController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid country",
          isSuccess: false);
    } else if (adressController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid adress",
          isSuccess: false);
    } else if (adressNameController.text.isEmpty) {
      showToast(
          context: context!,
          message: "Please enter a valid adress name",
          isSuccess: false);
    } else {
      await addAddress();
    }
  }

  Future<void> addAddress() async {
    AddressModel _address = AddressModel(
      name: nameController.text,
      phoneNumber: phoneController.text,
      province: provinceController.text,
      city: cityController.text,
      postalCode: postalCodeController.text,
      country: countryController.text,
      fullAddress: adressController.text,
      personalName: adressNameController.text,
    );

    AddressResponseModel _addressResponse = await _repository.setAddress(
      address: _address,
      context: context,
    );

    if (_addressResponse.isSuccess ?? false) {
      showToast(
          context: context!,
          message: "Address has been added",
          isSuccess: true);
      locator<AddressViewModel>().addNewAddress(_address);
      Navigator.pop(context!);
    } else {
      showToast(
          context: context!,
          message: "Address has not been added",
          isSuccess: false);
    }
  }
}
