import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall_par_flutter/Bloc/categoryWallpaperBloc.dart';
import 'package:wall_par_flutter/Bloc/wallpaperEvent.dart';
import 'package:wall_par_flutter/repositories/category_page_repository.dart';
import 'package:wall_par_flutter/Screens/Category.dart' as category;

class CategoryPage extends StatelessWidget {
  const CategoryPage(
      {Key? key, required this.title, required this.whenCompleteFunction})
      : super(key: key);

  final String title;
  final Function(File? file) whenCompleteFunction;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryWallpaperBloc(CategoryPageRepository())
        ..add(CategoryWallpaper(category: title)),
      child: category.Category(
          category: title, whenCompleteFunction: whenCompleteFunction),
    );
  }
}
