class ProductModel {
  String? title;
  String? description;
  String? distributor;
  num? stock;
  num? price;
  String? model;
  String? number;
  int? id;
  String? categoryTitle;
  String? subcategoryTitle;
  List<Photo>? photos;
  int? commentCount;
  num? discount;
  num? rateCount;
  num? rate;

  ProductModel(
      {this.title,
      this.description,
      this.distributor,
      this.stock,
      this.price,
      this.model,
      this.number,
      this.id,
      this.categoryTitle,
      this.subcategoryTitle,
      this.photos,
      this.commentCount,
      this.discount,
      this.rateCount,
      this.rate});

  ProductModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    distributor = json['distributor'];
    stock = json['stock'];
    price = json['price'];
    model = json['model'];
    number = json['number'];
    id = json['id'];
    categoryTitle = json['category_title'];
    subcategoryTitle = json['subcategory_title'];
    rate = json['rate'];
    if (json['photos'] != null) {
      photos = <Photo>[];
      json['photos'].forEach((v) {
        photos!.add(Photo.fromJson(v));
      });
    }
    commentCount = json['comment_count'];
    rateCount = json['rate_count'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['distributor'] = distributor;
    data['stock'] = stock;
    data['price'] = price;
    data['model'] = model;
    data['number'] = number;
    data['id'] = id;
    data['category_title'] = categoryTitle;
    data['subcategory_title'] = subcategoryTitle;
    if (photos != null) {
      data['photos'] = photos!.map((v) => v.toJson()).toList();
    }
    data['comment_count'] = commentCount;
    data['rate'] = rate;
    data['rate_count'] = rateCount;
    data['discount'] = discount;
    return data;
  }
}

class Photo {
  num? id;
  String? photoUrl;
  bool? isActive;

  Photo({this.id, this.photoUrl, this.isActive});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photoUrl = json['photo_url'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['photo_url'] = photoUrl;
    data['is_active'] = isActive;
    return data;
  }
}

class ProductResponseModel {
  String? message;
  bool? isSuccess;
  ProductModel? data;

  ProductResponseModel({this.message, this.isSuccess, this.data});

  ProductResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isSuccess = json['isSuccess'];
    data = json['data'] != null ? ProductModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['isSuccess'] = isSuccess;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
