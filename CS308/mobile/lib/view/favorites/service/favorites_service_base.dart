import 'package:flutter/material.dart';
import 'package:mobile/view/favorites/model/favorites_model.dart';

abstract class FavoritesServiceBase {
  Future<FavoritesResponseModel> getFavorites({
    BuildContext context,
    int skip,
    int limit,
  });

  Future<FavoriteItemResponseModel> setFavorite({
    BuildContext context,
    int productId,
    String token,
  });

  Future<FavoriteItemResponseModel> deleteFavorite({
    BuildContext context,
    int productId,
    String token,
  });
}
