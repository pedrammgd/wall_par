import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wall_par_flutter/Bloc/searchWallpaperBloc.dart';
import 'package:wall_par_flutter/Bloc/wallpaperBloc.dart';
import 'package:wall_par_flutter/Bloc/wallpaperEvent.dart';
import 'package:wall_par_flutter/Screens/splash_page.dart';
import 'package:wall_par_flutter/repositories/search_page_repository.dart';

import 'repositories/home_page_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
            create: (context) => SearchWallpaperBloc(SearchPageRepository())
              ..add(SearchWallpaper(search: 'wallpaper'))),
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
            textTheme: GoogleFonts.sansitaTextTheme(),
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

        home: SplashPage(),
      ),
    );
  }
}
