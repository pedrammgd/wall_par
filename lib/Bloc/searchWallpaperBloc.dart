import 'dart:convert';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:wall_par_flutter/Bloc/wallpaperEvent.dart';
import 'package:wall_par_flutter/Bloc/wallpaperState.dart';
import 'package:wall_par_flutter/Model/wallpaper.dart';
import 'package:wall_par_flutter/repositories/search_page_repository.dart';

class SearchWallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  final SearchPageRepository searchPageRepository;
  int page = 1;
  bool isFetching = false;

  SearchWallpaperBloc(this.searchPageRepository)
      : super(SearchWallpaperInitial());

  @override
  Stream<WallpaperState> mapEventToState(WallpaperEvent event) async* {
    if (event is SearchWallpaper) {
      yield SearchWallpaperIsLoading();
      final response = await searchPageRepository.getWallPaper(
          page: page, categoryName: event.search);

      if (response is http.Response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body)["photos"] as List;
          if (data.isEmpty) page = 0;
          print(data);
          yield SearchWallpaperIsLoaded(data
              .map((beer) => Wallpaper.fromMap(beer as Map<String, dynamic>))
              .toList());

          if (page >= 160)
            page = 0;
          else
            page++;
        } else {
          yield SearchWallpaperIsNotLoaded();
        }
      } else if (response is String) {
        yield SearchWallpaperIsNotLoaded();
      }

      // try {
      //   var response = await http.get(
      //       Uri.parse(searchEndPoint + event.string + perPageLimit),
      //       headers: {
      //         "Accept": "application/json",
      //         "Authorization": "$apiKey"
      //       });
      //   var data = jsonDecode(response.body)["photos"];
      //   _searchWallpaper = <Wallpaper>[];
      //   for (var i = 0; i < data.length; i++) {
      //     _searchWallpaper.add(Wallpaper.fromMap(data[i]));
      //   }
      //   yield SearchWallpaperIsLoaded(_searchWallpaper);
      // } catch (_) {
      //   yield SearchWallpaperIsNotLoaded();
      // }
    }
  }
}
