import 'package:flutter/material.dart';
import 'package:mobile/core/base/model/base_view_model.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/address/model/adress_model.dart';
import 'package:mobile/view/address/repository/address_repository.dart';
import 'package:mobx/mobx.dart';
part 'adress_view_model.g.dart';

class AddressViewModel = _AddressViewModelBase with _$AddressViewModel;

abstract class _AddressViewModelBase with Store, BaseViewModel {
  late AddressRepository _repository;
  late AddressResponseModel _addressResponseModel;
  late AddressesResponseModel _addressesResponseModel;

  @override
  void setContext(BuildContext context) => this.context = context;

  @override
  void init() {
    _repository = locator<AddressRepository>();
  }

  void dispose() {}

  @observable
  var addresses = ObservableList<AddressModel>();

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
  void deleteAddress({required int index, required int id}) async {
    _addressResponseModel = await _repository.deleteAddress(
      context: context,
      id: id,
    );
    if (_addressResponseModel.isSuccess ?? false) {
      addresses.removeAt(index);
      showToast(
          context: context!,
          message: "Address deleted successfully",
          isSuccess: false);
    } else {
      showToast(
          context: context!,
          message: _addressResponseModel.message ??
              ApplicationConstants.ERROR_MESSAGE,
          isSuccess: false);
    }
  }

  Future<bool> getData() async {
    _addressesResponseModel = await _repository.getAddresses(
      context: context,
    );
    setAddresses(_addressesResponseModel.data!);
    return _addressesResponseModel.isSuccess!;
  }
}
