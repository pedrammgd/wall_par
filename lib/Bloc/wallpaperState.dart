import 'package:wall_par_flutter/Model/wallpaper.dart';

abstract class WallpaperState {}

class WallpaperInitial extends WallpaperState {
  WallpaperInitial();
}

class WallpaperIsLoading extends WallpaperState {}

class WallpaperIsLoaded extends WallpaperState {
  final List<Wallpaper> _wallpaper;
  WallpaperIsLoaded(this._wallpaper);
  List<Wallpaper> get getWallpaper => _wallpaper;
}

class WallpaperIsNotLoaded extends WallpaperState {}

class SearchWallpaperNotSearched extends WallpaperState {}

class SearchWallpaperInitial extends WallpaperState {}

class SearchWallpaperIsLoading extends WallpaperState {}

class SearchWallpaperIsNotLoaded extends WallpaperState {}

class SearchWallpaperIsLoaded extends WallpaperState {
  final List<Wallpaper> _wallpaper;
  SearchWallpaperIsLoaded(this._wallpaper);
  List<Wallpaper> get getSearchWallpaper => _wallpaper;
}

class CategoryWallpaperNotSearched extends WallpaperState {}

class WallpaperCategoryInitial extends WallpaperState {}

class CategoryWallpaperIsLoading extends WallpaperState {}

class CategoryWallpaperIsLoaded extends WallpaperState {
  final List<Wallpaper> _wallpaper;
  CategoryWallpaperIsLoaded(this._wallpaper);
  List<Wallpaper> get getCategoryWallpaper => _wallpaper;
}

class CategoryWallpaperIsNotLoaded extends WallpaperState {}
