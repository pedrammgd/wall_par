import 'dart:io';

import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:progress_value_button/progress_value_button.dart';
import 'package:wall_par_flutter/Bloc/download_background/download_background_bloc.dart';
import 'package:wall_par_flutter/Bloc/download_background/download_background_event.dart';
import 'package:wall_par_flutter/Bloc/download_background/download_background_state.dart';
import 'package:wall_par_flutter/Model/wallpaper.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class Detail extends StatefulWidget {
  final Wallpaper wallpaper;
  final Function(Directory?)? whenComplete;

  // bool downloadImage;

  // final double downPer;

  Detail({
    Key? key,
    required this.wallpaper,
    this.whenComplete,
  }) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool permission = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // bool downloadImage = false;
  // double downPer = 0;
  final String nAvail = "Not Available";

  _permissionRequest() async {
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Wallpar',
      enableLocationMessage: 'required Allow access to media',
    );
    var result = await permissionValidator.storage();
    if (result) {
      if (mounted)
        setState(() {
          permission = true;

          // if (widget.setWallpaper != null) {
          //   widget.setWallpaper!();
          // }
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    // downloadBackgroundBloc
    //     .add(DownloadStarted(url: widget.wallpaper.original ?? ''));
    return Scaffold(
      body: BlocConsumer<DownloadBackgroundBloc, DownloadBackgroundState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Stack(children: <Widget>[
            Hero(
              tag: widget.wallpaper.portrait ?? '',
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: CachedNetworkImage(
                    imageUrl: widget.wallpaper.portrait ?? '',
                    fit: BoxFit.cover,
                    // placeholder: "assets/image/wall_par_logo.png",
                    // placeholderFit: BoxFit.none,
                    // imageErrorBuilder: (context, error, stackTrace) =>
                    //     Image.asset("assets/image/wall_par_logo.png"),
                    // imageScale: 1,
                  )),
            ),
            Positioned(
              child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: Container(
                    margin: const EdgeInsetsDirectional.only(top: 8, start: 8),
                    decoration: BoxDecoration(
                        color: Colors.white30,
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(9)),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(9),
                      child: Center(
                          child: Icon(
                        Icons.arrow_back_ios_sharp,
                        size: 22,
                        color: Colors.black,
                      )),
                    ),
                  )),
            ),
            _buttonDownload(state: state),
          ]);
        },
      ),
    );
  }

  Widget _buttonDownload({required DownloadBackgroundState state}) {
    if (state is DownloadLoadInProgress) {
      //   print('state.url${state.url}');
      //   if (state.url == null)
      //     return Container(
      //       width: 300,
      //       height: 300,
      //       color: Colors.red,
      //     );
      //   else
      //     return Padding(
      //       padding: const EdgeInsets.all(40.0),
      //       child: SizedBox(
      //           height: 200,
      //           width: 200,
      //           child: CachedNetworkImage(
      //             imageUrl: widget.wallpaper.portrait ?? '',
      //             memCacheWidth: 100,
      //             memCacheHeight: 100,
      //             fit: BoxFit.cover,
      //             errorWidget: (context, url, error) => new Icon(Icons.error),
      //           )),
      //     );
      return _buttonWidget(
        title: 'Downloading.. ${state.downPer.toStringAsFixed(0)} %',
        value: state.downPer,
        onPressed: (p0) async {},
      );
    }
    if (state is DownloadSuccess) {
      return _buttonWidget(
        title: "Apply",
        onPressed: (p0) async {
          context.bloc<DownloadBackgroundBloc>().add(DownloadStarted(
              url: widget.wallpaper.original ?? '',
              whenComplete: widget.whenComplete!));
        },
      );
    }
    return _buttonWidget(
      title: "Apply",
      onPressed: (p0) async {
        context.bloc<DownloadBackgroundBloc>().add(
              DownloadStarted(
                  url: widget.wallpaper.original ?? '',
                  whenComplete: widget.whenComplete!),
            );
      },
    );
  }

  Widget _buttonWidget(
      {required Function(double) onPressed,
      String title = 'title',
      double value = 0}) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ProgressValueButton(
            borderRadius: 8,
            progressColor: Color(0xff4AA96C),
            backgroundColor: Colors.white.withOpacity(.9),
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 19),
                ),
                if (value == 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      AkarIcons.sparkles,
                      size: 20,
                    ),
                  )
              ],
            ),
            value: value,
            onPressed: onPressed),
      ),
    );
  }

// void setWallpaper() async {
//   final dir = await getExternalStorageDirectory();
//   print(dir);
//   Dio dio = new Dio();
//   dio.download(
//     widget.wallpaper.original ?? '',
//     "${dir?.path}/wallpar.png",
//     onReceiveProgress: (received, total) {
//       if (total != -1) {
//         double downloadingPer = (received / total * 100);
//         setState(() {
//           downPer = downloadingPer;
//         });
//       }
//       setState(() {
//         downloadImage = true;
//       });
//     },
//   ).whenComplete(() {
//     setState(() {
//       downloadImage = false;
//       downPer = 0;
//     });
//     _showModal(dir);
//   });
// }

// Future<dynamic> _showModal(Directory? dir) {
//   return showModalBottomSheet(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(10),
//           topLeft: Radius.circular(10),
//         ),
//       ),
//       // isDismissible: false,
//       context: context,
//       builder: (_) {
//         return Container(
//           margin: EdgeInsets.all(20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             // mainAxisSize: MainAxisSize.min,
//             children: [
//               GFButton(
//                 icon: Icon(
//                   Icons.add_to_home_screen,
//                   color: Colors.white,
//                 ),
//                 color: Color(0xff4AA96C),
//                 onPressed: () {
//                   initPlatformState("${dir?.path}/wallpar.png",
//                       WallpaperManager.HOME_SCREEN);
//                   Navigator.pop(context);
//                 },
//                 text: "HomeScreen",
//               ),
//               GFButton(
//                 icon: Icon(Icons.lock_open, color: Colors.white),
//                 color: Color(0xff4AA96C),
//                 onPressed: () {
//                   initPlatformState("${dir?.path}/wallpar.png",
//                       WallpaperManager.LOCK_SCREEN);
//                   Navigator.pop(context);
//                 },
//                 text: "LockScreen",
//               ),
//               GFButton(
//                 type: GFButtonType.outline,
//                 icon: Icon(Icons.phonelink_lock_sharp,
//                     color: Color(0xff4AA96C)),
//                 color: Color(0xff4AA96C),
//                 onPressed: () {
//                   initPlatformState("${dir?.path}/wallpar.png",
//                       WallpaperManager.BOTH_SCREENS);
//                   Navigator.pop(context);
//                 },
//                 text: "Both",
//               ),
//             ],
//           ),
//         );
//       });
// }

// Future<void> initPlatformState(String path, int location) async {
//   try {
//     await WallpaperManager.setWallpaperFromFile(path, location);
//     Fluttertoast.showToast(
//         msg: 'Wallpaper Applied.', toastLength: Toast.LENGTH_SHORT);
//   } on PlatformException {
//     Fluttertoast.showToast(
//         msg: 'Please Try Again Later.', toastLength: Toast.LENGTH_SHORT);
//     print("Platform exception");
//   }
//   if (!mounted) return;
// }
}
