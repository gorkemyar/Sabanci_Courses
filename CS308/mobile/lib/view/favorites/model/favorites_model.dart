class FavoritesResponseModel {
  String? message;
  bool? isSuccess;
  List<FavoritesModel>? data;

  FavoritesResponseModel({this.message, this.isSuccess, this.data});

  FavoritesResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isSuccess = json['isSuccess'];
    if (json['data'] != null) {
      data = <FavoritesModel>[];
      json['data'].forEach((v) {
        data!.add(FavoritesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['isSuccess'] = isSuccess;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FavoritesModel {
  int? productId;
  int? id;
  int? userId;

  FavoritesModel({this.productId, this.id, this.userId});

  FavoritesModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    id = json['id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['id'] = id;
    data['user_id'] = userId;
    return data;
  }
}

class FavoriteItemResponseModel {
  String? message;
  bool? isSuccess;

  FavoriteItemResponseModel({this.message, this.isSuccess});

  FavoriteItemResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isSuccess = json['isSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['isSuccess'] = isSuccess;
    return data;
  }
}
