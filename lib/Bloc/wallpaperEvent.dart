import 'package:flutter/cupertino.dart';

abstract class WallpaperEvent {}

class GetAllWallpaper extends WallpaperEvent {
  GetAllWallpaper();
}

class SearchWallpaper extends WallpaperEvent {
  final String search;
  SearchWallpaper({required this.search});
}

class CategoryWallpaper extends WallpaperEvent {
  final String category;
  CategoryWallpaper({required this.category});
}
