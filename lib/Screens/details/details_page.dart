import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wall_par_flutter/Bloc/download_background/download_background_bloc.dart';
import 'package:wall_par_flutter/Bloc/download_background/download_background_event.dart';
import 'package:wall_par_flutter/Model/wallpaper.dart';
import 'package:wall_par_flutter/Screens/details/Detail.dart';
import 'package:wall_par_flutter/download_service.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage(
      {Key? key, required this.wallpaper, required this.whenComplete})
      : super(key: key);
  final Wallpaper wallpaper;
  final Function(File? file) whenComplete;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: BlocProvider(
        create: (context) => DownloadBackgroundBloc(
          DownloadService(),
        ),
        child: DetailView(wallpaper: wallpaper, whenComplete: whenComplete),
      ),
    );
  }
}
