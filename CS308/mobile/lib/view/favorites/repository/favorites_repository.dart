import 'package:flutter/material.dart';
import 'package:mobile/core/constants/app/app_constants.dart';
import 'package:mobile/core/constants/enums/locale_keys_enum.dart';
import 'package:mobile/core/init/cache/locale_manager.dart';
import 'package:mobile/core/init/network/log_inceptor.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/favorites/model/favorites_model.dart';
import 'package:mobile/view/favorites/service/favorites_service.dart';
import 'package:mobile/view/favorites/service/favorites_service_base.dart';

class FavoritesRepository with FavoritesServiceBase {
  final _service = locator<FavoritesService>();

  @override
  Future<FavoritesResponseModel> getFavorites({
    BuildContext? context,
    int? skip,
    int? limit,
  }) async {
    await getUserToken();
    var token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)!;

    FavoritesResponseModel _responseModel = await _service.getFavorites(
      context: context,
      skip: skip ?? ApplicationConstants.FAVORITES_SKIP,
      limit: limit ?? ApplicationConstants.FAVORITES_LIMIT,
      token: token,
    );
    return _responseModel;
  }

  @override
  Future<FavoriteItemResponseModel> deleteFavorite({
    BuildContext? context,
    int? productId,
    String? token,
  }) async {
    await getUserToken();
    var token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)!;
    
    FavoriteItemResponseModel _responseModel = await _service.deleteFavorite(
      context: context,
      productId: productId,
      token: token,
    );
    return _responseModel;
  }

  @override
  Future<FavoriteItemResponseModel> setFavorite({
    BuildContext? context,
    int? productId,
    String? token,
  }) async {
    await getUserToken();
    var token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN)!;

    FavoriteItemResponseModel _responseModel = await _service.setFavorite(
      context: context,
      productId: productId,
      token: token,
    );
    return _responseModel;
  }
}
