import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall_par_flutter/Bloc/categoryWallpaperBloc.dart';
import 'package:wall_par_flutter/Bloc/download_background/download_background_bloc.dart';
import 'package:wall_par_flutter/Bloc/searchWallpaperBloc.dart';
import 'package:wall_par_flutter/Bloc/wallpaperBloc.dart';
import 'package:wall_par_flutter/Bloc/wallpaperEvent.dart';
import 'package:wall_par_flutter/Model/wallpaper.dart';
import 'package:wall_par_flutter/Screens/HomePage.dart';
import 'package:wall_par_flutter/download_service.dart';
import 'package:wall_par_flutter/repositories/category_page_repository.dart';
import 'package:wall_par_flutter/repositories/search_page_repository.dart';

import 'repositories/home_page_repository.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
  //   statusBarColor: Colors.transparent,
  // ));
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WallpaperBloc(
            homePageRepository: HomePageRepository(),
          )..add(GetAllWallpaper()),
        ),
        BlocProvider(
            create: (context) => SearchWallpaperBloc(SearchPageRepository())),
        BlocProvider(
            create: (context) =>
                CategoryWallpaperBloc(CategoryPageRepository())),
        BlocProvider(
            create: (context) => DownloadBackgroundBloc(
                  DownloadService(),
                )),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wallbay',
        theme: ThemeData(
            brightness: Brightness.light,
            cardColor: Colors.white38,
            accentColor: Colors.black,
            cursorColor: Colors.black,
            dialogBackgroundColor: Colors.white,
            primaryColor: Colors.white),
        // theme: ThemeData(
        //     brightness: Brightness.light,
        //     cardColor: Colors.white38,
        //     accentColor: Colors.black,
        //     cursorColor: Colors.black,
        //     dialogBackgroundColor: Colors.white,
        //     primaryColor: Colors.white),
        // darkTheme: ThemeData(
        //     brightness: Brightness.dark,
        //     accentColor: Colors.white,
        //     cursorColor: Colors.white,
        //     primaryColor: Colors.black,
        //     dialogBackgroundColor: Colors.black,
        //     cardColor: Colors.white38),

        home: MyHomePage(
          'WallPar',
        ),
      ),
    );
  }
}
