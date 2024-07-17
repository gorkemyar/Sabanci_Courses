import 'package:flutter/material.dart';
import 'package:mobile/view/categories/model/category_model.dart';

abstract class CategoryServiceBase {
  Future<CategoriesResponseModel> getCategories({
    BuildContext context,
    int skip,
    int limit,
  });

  Future<CategoryResponseModel> getCategory({
    BuildContext context,
    int id,
  });
}
