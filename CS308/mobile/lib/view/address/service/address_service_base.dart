import 'package:flutter/material.dart';
import 'package:mobile/view/address/model/adress_model.dart';

abstract class AddressServiceBase {
  Future<AddressesResponseModel> getAddresses({
    BuildContext context,
    String token,
    int skip,
    int limit,
  });

  Future<AddressResponseModel> setAddress({
    BuildContext context,
    String token,
    AddressModel address,
  });

  Future<AddressResponseModel> deleteAddress({
    BuildContext context,
    String token,
    int id,
  });
}
