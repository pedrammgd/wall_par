import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wall_par_flutter/const.dart';

class CategoryPageRepository {
  static final CategoryPageRepository _beerRepository =
      CategoryPageRepository._();
  static const int _perPage = 20;

  CategoryPageRepository._();

  factory CategoryPageRepository() {
    return _beerRepository;
  }

  Future<dynamic> getWallPaper({
    required int page,
    required String categoryName,
  }) async {
    try {
      return await http.get(
          Uri.parse(
              searchEndPoint + categoryName + '&page=$page&per_page=$_perPage'),
          headers: {"Accept": "application/json", "Authorization": "$apiKey"});
    } catch (e) {
      return e.toString();
    }
  }
}
