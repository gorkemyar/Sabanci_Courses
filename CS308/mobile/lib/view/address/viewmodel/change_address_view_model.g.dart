// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_address_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChangeAddressViewModel on _ChangeAddressViewModelBase, Store {
  final _$nameControllerAtom =
      Atom(name: '_ChangeAddressViewModelBase.nameController');

  @override
  TextEditingController get nameController {
    _$nameControllerAtom.reportRead();
    return super.nameController;
  }

  @override
  set nameController(TextEditingController value) {
    _$nameControllerAtom.reportWrite(value, super.nameController, () {
      super.nameController = value;
    });
  }

  final _$phoneControllerAtom =
      Atom(name: '_ChangeAddressViewModelBase.phoneController');

  @override
  TextEditingController get phoneController {
    _$phoneControllerAtom.reportRead();
    return super.phoneController;
  }

  @override
  set phoneController(TextEditingController value) {
    _$phoneControllerAtom.reportWrite(value, super.phoneController, () {
      super.phoneController = value;
    });
  }

  final _$provinceControllerAtom =
      Atom(name: '_ChangeAddressViewModelBase.provinceController');

  @override
  TextEditingController get provinceController {
    _$provinceControllerAtom.reportRead();
    return super.provinceController;
  }

  @override
  set provinceController(TextEditingController value) {
    _$provinceControllerAtom.reportWrite(value, super.provinceController, () {
      super.provinceController = value;
    });
  }

  final _$cityControllerAtom =
      Atom(name: '_ChangeAddressViewModelBase.cityController');

  @override
  TextEditingController get cityController {
    _$cityControllerAtom.reportRead();
    return super.cityController;
  }

  @override
  set cityController(TextEditingController value) {
    _$cityControllerAtom.reportWrite(value, super.cityController, () {
      super.cityController = value;
    });
  }

  final _$postalCodeControllerAtom =
      Atom(name: '_ChangeAddressViewModelBase.postalCodeController');

  @override
  TextEditingController get postalCodeController {
    _$postalCodeControllerAtom.reportRead();
    return super.postalCodeController;
  }

  @override
  set postalCodeController(TextEditingController value) {
    _$postalCodeControllerAtom.reportWrite(value, super.postalCodeController,
        () {
      super.postalCodeController = value;
    });
  }

  final _$countryControllerAtom =
      Atom(name: '_ChangeAddressViewModelBase.countryController');

  @override
  TextEditingController get countryController {
    _$countryControllerAtom.reportRead();
    return super.countryController;
  }

  @override
  set countryController(TextEditingController value) {
    _$countryControllerAtom.reportWrite(value, super.countryController, () {
      super.countryController = value;
    });
  }

  final _$adressControllerAtom =
      Atom(name: '_ChangeAddressViewModelBase.adressController');

  @override
  TextEditingController get adressController {
    _$adressControllerAtom.reportRead();
    return super.adressController;
  }

  @override
  set adressController(TextEditingController value) {
    _$adressControllerAtom.reportWrite(value, super.adressController, () {
      super.adressController = value;
    });
  }

  final _$adressNameControllerAtom =
      Atom(name: '_ChangeAddressViewModelBase.adressNameController');

  @override
  TextEditingController get adressNameController {
    _$adressNameControllerAtom.reportRead();
    return super.adressNameController;
  }

  @override
  set adressNameController(TextEditingController value) {
    _$adressNameControllerAtom.reportWrite(value, super.adressNameController,
        () {
      super.adressNameController = value;
    });
  }

  final _$submitAsyncAction = AsyncAction('_ChangeAddressViewModelBase.submit');

  @override
  Future submit() {
    return _$submitAsyncAction.run(() => super.submit());
  }

  final _$_ChangeAddressViewModelBaseActionController =
      ActionController(name: '_ChangeAddressViewModelBase');

  @override
  void _listener() {
    final _$actionInfo = _$_ChangeAddressViewModelBaseActionController
        .startAction(name: '_ChangeAddressViewModelBase._listener');
    try {
      return super._listener();
    } finally {
      _$_ChangeAddressViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
nameController: ${nameController},
phoneController: ${phoneController},
provinceController: ${provinceController},
cityController: ${cityController},
postalCodeController: ${postalCodeController},
countryController: ${countryController},
adressController: ${adressController},
adressNameController: ${adressNameController}
    ''';
  }
}
