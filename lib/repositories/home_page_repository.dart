import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wall_par_flutter/const.dart';

class HomePageRepository {
  static final HomePageRepository _beerRepository = HomePageRepository._();
  static const int _perPage = 50;

  HomePageRepository._();

  factory HomePageRepository() {
    return _beerRepository;
  }

  Future<dynamic> getWallPaper({
    required int page,
  }) async {
    try {
      return await http.get(
          Uri.parse(editorChoiceEndPoint + 'page=$page&per_page=$_perPage'),
          headers: {"Accept": "application/json", "Authorization": "$apiKey"});
    } catch (e) {
      return e.toString();
    }
  }
}
