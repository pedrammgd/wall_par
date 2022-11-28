import 'dart:convert';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:wall_par_flutter/Bloc/wallpaperEvent.dart';
import 'package:wall_par_flutter/Bloc/wallpaperState.dart';
import 'package:wall_par_flutter/Model/wallpaper.dart';
import 'package:wall_par_flutter/const.dart';
import 'package:wall_par_flutter/repositories/category_page_repository.dart';

class CategoryWallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  final CategoryPageRepository categoryPageRepository;

  var random = Random();

  int page = 1;
  bool isFetching = false;

  @override
  CategoryWallpaperBloc(this.categoryPageRepository)
      : super(WallpaperCategoryInitial()) {
    page = random.nextInt(10);
  }

  @override
  Stream<WallpaperState> mapEventToState(WallpaperEvent event) async* {
    if (event is CategoryWallpaper) {
      yield CategoryWallpaperIsLoading();
      final response = await categoryPageRepository.getWallPaper(
          page: page, categoryName: event.category);

      if (response is http.Response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body)["photos"] as List;
          if (data.isEmpty) page = 0;
          print(data);
          yield CategoryWallpaperIsLoaded(data
              .map((beer) => Wallpaper.fromMap(beer as Map<String, dynamic>))
              .toList());

          if (page >= 160)
            page = 0;
          else
            page++;
        } else {
          yield CategoryWallpaperIsNotLoaded();
        }
      } else if (response is String) {
        yield CategoryWallpaperIsNotLoaded();
      }
    }
  }
}
