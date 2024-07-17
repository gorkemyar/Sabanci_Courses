import 'package:flutter/material.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/constants/enums/locale_keys_enum.dart';
import 'package:mobile/core/init/cache/locale_manager.dart';
import 'package:mobile/core/init/network/log_inceptor.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/address/model/adress_model.dart';
import 'package:mobile/view/address/service/address_service.dart';
import 'package:mobile/view/address/service/address_service_base.dart';

class AddressRepository extends AddressServiceBase {
  final _service = locator<AddressService>();

  @override
  Future<AddressesResponseModel> getAddresses({
    BuildContext? context,
    String? token,
    int? skip,
    int? limit,
  }) async {
    await getUserToken();
    var token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)!;
    
    AddressesResponseModel _responseModel = await _service.getAddresses(
      context: context,
      token: token,
      skip: skip ?? ApplicationConstants.ADDRESS_SKIP,
      limit: limit ?? ApplicationConstants.ADDRESS_LIMIT,
    );

    return _responseModel;
  }

  @override
  Future<AddressResponseModel> setAddress({
    BuildContext? context,
    String? token,
    AddressModel? address,
  }) async {
    await getUserToken();
    var token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)!;

    AddressResponseModel _responseModel = await _service.setAddress(
      context: context,
      token: token,
      address: address,
    );

    return _responseModel;
  }

  @override
  Future<AddressResponseModel> deleteAddress({
    BuildContext? context,
    String? token,
    int? id,
  }) async {
    await getUserToken();
    var token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)!;
    
    AddressResponseModel _responseModel = await _service.deleteAddress(
      context: context,
      token: token,
      id: id,
    );

    return _responseModel;
  }
}
