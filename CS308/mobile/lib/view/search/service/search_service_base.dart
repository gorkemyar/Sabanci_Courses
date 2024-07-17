import 'package:flutter/material.dart';
import 'package:mobile/view/search/model/search_model.dart';

abstract class SearchServiceBase {
  Future<SearchResponseModel> search({
    BuildContext context,
    String query,
    int skip,
    int limit,
  });
}
