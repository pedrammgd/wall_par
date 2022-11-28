import 'dart:convert';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:wall_par_flutter/Bloc/wallpaperEvent.dart';
import 'package:wall_par_flutter/Bloc/wallpaperState.dart';
import 'package:wall_par_flutter/Model/wallpaper.dart';
import 'package:wall_par_flutter/repositories/home_page_repository.dart';

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  // @override
  // get initialState => WallpaperIsLoading();
  var random = Random();

  final HomePageRepository homePageRepository;
  int page = 1;
  bool isFetching = false;

  WallpaperBloc({
    required this.homePageRepository,
  }) : super(WallpaperInitial()) {
    page = random.nextInt(160);
  }

  @override
  Stream<WallpaperState> mapEventToState(WallpaperEvent event) async* {
    if (event is GetAllWallpaper) {
      yield WallpaperIsLoading();
      final response = await homePageRepository.getWallPaper(page: page);
      if (response is http.Response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body)["photos"] as List;
          // final beers = jsonDecode(response.body)["photos"] as List;

          // wallpaper = <Wallpaper>[];
          // for (var i = 0; i < data.length; i++) {
          //   wallpaper.add(Wallpaper.fromMap(data[i]));
          // }
          if (data.isEmpty) page = 0;
          print(data);
          yield WallpaperIsLoaded(data
              .map((beer) => Wallpaper.fromMap(beer as Map<String, dynamic>))
              .toList());

          if (page >= 160)
            page = 0;
          else
            page++;
        } else {
          yield WallpaperIsNotLoaded();
        }
      } else if (response is String) {
        yield WallpaperIsNotLoaded();
      }

      // try {
      //   var response = await http
      //       .get(Uri.encodeFull(editorChoiceEndPoint + perPageLimit), headers: {
      //     "Accept": "application/json",
      //     "Authorization": "$apiKey"
      //   });
      //   var data = jsonDecode(response.body)["photos"];
      //   print(data);
      //   _wallpaper = <Wallpaper>[];
      //   for (var i = 0; i < data.length; i++) {
      //     _wallpaper.add(Wallpaper.fromMap(data[i]));
      //   }
      //   yield WallpaperIsLoaded(_wallpaper);
      // } catch (_) {
      //   yield WallpaperIsNotLoaded();
      // }
    }
  }
}
