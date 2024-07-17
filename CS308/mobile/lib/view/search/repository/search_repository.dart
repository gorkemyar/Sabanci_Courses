import 'package:flutter/material.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/search/model/search_model.dart';
import 'package:mobile/view/search/service/search_service.dart';
import 'package:mobile/view/search/service/search_service_base.dart';

class SearchRepository extends SearchServiceBase {
  final _service = locator<SearchService>();

  @override
  Future<SearchResponseModel> search({
    BuildContext? context,
    String? query,
    int? skip,
    int? limit,
  }) async {
    SearchResponseModel _responseModel = await _service.search(
      context: context,
      query: query,
      skip: skip,
      limit: limit,
    );
    return _responseModel;
  }
}
