import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wall_par_flutter/Bloc/download_background/download_background_bloc.dart';
import 'package:wall_par_flutter/Bloc/wallpaperBloc.dart';
import 'package:wall_par_flutter/Bloc/wallpaperEvent.dart';
import 'package:wall_par_flutter/Bloc/wallpaperState.dart';
import 'package:wall_par_flutter/Model/wallpaper.dart';
import 'package:wall_par_flutter/Screens/Detail.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class EditorChoice extends StatefulWidget {
  @override
  State<EditorChoice> createState() => _EditorChoiceState();
}

class _EditorChoiceState extends State<EditorChoice>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final List<Wallpaper> wallpaper = [];
  bool downloadImage = false;

  double downPer = 0;

  int counter = 0;

  void openPage(int index) async {
    counter++;

    // Navigation
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Detail(
                whenComplete: _showModal,
                wallpaper: wallpaper[index],
              )),
    );
    if (result == true) {
      // wallpaper[index].isDownloading = result;
    }
  }

  // Future<void> showAd(Wallpaper wallpaper) async {
  //   counter = 0;
  //   Navigator.push(
  //     context,
  //     CupertinoPageRoute(
  //       builder: (context) => Detail(
  //         wallpaper: wallpaper,
  //       ),
  //     ),
  //   );
  // }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = (size.width / 2);
    return RefreshIndicator(
      onRefresh: () async {
        wallpaper.clear();
        context.read<WallpaperBloc>()
          ..isFetching = true
          ..add(GetAllWallpaper());
      },
      child: Center(
        child: BlocConsumer<WallpaperBloc, WallpaperState>(
          listener: (context, state) {
            if (state is WallpaperIsLoading) {
              // Scaffold.of(context)
              //     .showSnackBar(SnackBar(content: Text('Loading')));
            } else if (state is WallpaperIsLoaded &&
                state.getWallpaper.isEmpty) {
              // Scaffold.of(context)
              //     .showSnackBar(SnackBar(content: Text('No more beers')));
            } else if (state is WallpaperIsNotLoaded) {
              // Scaffold.of(context)
              //     .showSnackBar(SnackBar(content: Text('Error')));
              context.read<WallpaperBloc>().isFetching = false;
            }
            // // return;
          },
          builder: (BuildContext context, state) {
            if (state is WallpaperInitial ||
                state is WallpaperIsLoading && wallpaper.isEmpty) {
              return Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.black, size: 20),
              );
            } else if (state is WallpaperIsLoaded) {
              wallpaper.addAll(state.getWallpaper);
              context.read<WallpaperBloc>().isFetching = false;
              // Scaffold.of(context).hideCurrentSnackBar();
            } else if (state is WallpaperIsNotLoaded && wallpaper.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      context.bloc<WallpaperBloc>()
                        ..isFetching = true
                        ..add(GetAllWallpaper());
                    },
                    icon: Icon(Icons.refresh),
                  ),
                  const SizedBox(height: 15),
                  Text('Error', textAlign: TextAlign.center),
                ],
              );
            }
            return SingleChildScrollView(
              controller: _scrollController
                ..addListener(() {
                  if (_scrollController.offset ==
                          _scrollController.position.maxScrollExtent &&
                      !context.read<WallpaperBloc>().isFetching) {
                    context.read<WallpaperBloc>()
                      ..isFetching = true
                      ..add(GetAllWallpaper());
                  }
                }),
              child: Column(
                children: [
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: wallpaper.length,
                    gridDelegate: SliverQuiltedGridDelegate(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      repeatPattern: QuiltedGridRepeatPattern.inverted,
                      pattern: [
                        QuiltedGridTile(2, 2),
                        QuiltedGridTile(1, 2),
                        QuiltedGridTile(1, 1),
                        QuiltedGridTile(1, 1),
                      ],
                    ),
                    itemBuilder: (context, index) => Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              // counter == 2
                              //     ? showAd(wallpaper[index])
                              //     :
                              openPage(index);
                            },
                            child: Card(
                              color: Color(0xff4AA96C).withOpacity(.7),
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Hero(
                                  tag: wallpaper[index].portrait ?? '1',
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        wallpaper[index].isDownloading ?? false
                                            ? Colors.grey
                                            : Colors.transparent,
                                        BlendMode.color),
                                    child: CachedNetworkImage(
                                      imageUrl: wallpaper[index].portrait ?? '',
                                      fit: BoxFit.cover,
                                      // memCacheHeight: 500,
                                      // memCacheWidth: 500,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                              'assets/image/wall_par_logo.png'),
                                    ),
                                  )
                                  //   child: ColorFiltered(
                                  //   colorFilter: ColorFilter.mode(
                                  //       wallpaper[index].isDownloading ?? false
                                  //           ? Colors.grey
                                  //           : Colors.transparent,
                                  //       BlendMode.color),
                                  //   child: FadeInImage.assetNetwork(
                                  //     image: wallpaper[index].portrait ?? '',
                                  //     fit: BoxFit.cover,
                                  //     placeholder:
                                  //         "assets/image/wall_par_logo.png",
                                  //     imageScale: 1,
                                  //     imageCacheHeight: 200,
                                  //     imageCacheWidth: 200,
                                  //   ),
                                  // ),
                                  ),
                            ),
                          ),
                        ),
                        if (wallpaper[index].isDownloading ?? false)
                          Image.asset('assets/image/download.gif'),
                      ],
                    ),
                    // if (wallpaper[index].downloadValue != null)
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (context.read<WallpaperBloc>().isFetching)
                    Center(
                        child: LoadingAnimationWidget.threeRotatingDots(
                            color: Colors.black, size: 20)),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            );
            return GridView.builder(
              controller: _scrollController
                ..addListener(() {
                  if (_scrollController.offset ==
                          _scrollController.position.maxScrollExtent &&
                      !context.read<WallpaperBloc>().isFetching) {
                    context.read<WallpaperBloc>()
                      ..isFetching = true
                      ..add(GetAllWallpaper());
                  }
                }),
              padding: EdgeInsets.all(5),
              itemCount: wallpaper.length,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: (itemWidth / itemHeight)),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      // counter == 2
                      // ? showAd(wallpaper[index])
                      // : openPage(wallpaper[index]);
                    },
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Hero(
                        tag: wallpaper[index].portrait ?? '',
                        child: FadeInImage.assetNetwork(
                          image: wallpaper[index].portrait ?? '',
                          fit: BoxFit.cover,
                          placeholder: "assets/image/abstract.jpg",
                          imageScale: 1,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> _showModal(Directory? dir) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
        // isDismissible: false,
        context: context,
        builder: (_) {
          return Container(
            margin: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // mainAxisSize: MainAxisSize.min,
              children: [
                GFButton(
                  icon: Icon(
                    Icons.add_to_home_screen,
                    color: Colors.white,
                  ),
                  color: Color(0xff4AA96C),
                  onPressed: () {
                    initPlatformState("${dir?.path}/wallpar.png",
                        WallpaperManager.HOME_SCREEN);
                    Navigator.pop(context);
                  },
                  text: "HomeScreen",
                ),
                GFButton(
                  icon: Icon(Icons.lock_open, color: Colors.white),
                  color: Color(0xff4AA96C),
                  onPressed: () {
                    initPlatformState("${dir?.path}/wallpar.png",
                        WallpaperManager.LOCK_SCREEN);
                    Navigator.pop(context);
                  },
                  text: "LockScreen",
                ),
                GFButton(
                  type: GFButtonType.outline,
                  icon: Icon(Icons.phonelink_lock_sharp,
                      color: Color(0xff4AA96C)),
                  color: Color(0xff4AA96C),
                  onPressed: () {
                    initPlatformState("${dir?.path}/wallpar.png",
                        WallpaperManager.BOTH_SCREENS);
                    Navigator.pop(context);
                  },
                  text: "Both",
                ),
              ],
            ),
          );
        });
  }

  Future<void> initPlatformState(String path, int location) async {
    try {
      await WallpaperManager.setWallpaperFromFile(path, location);
      Fluttertoast.showToast(
          msg: 'Wallpaper Applied.', toastLength: Toast.LENGTH_SHORT);
    } on PlatformException {
      Fluttertoast.showToast(
          msg: 'Please Try Again Later.', toastLength: Toast.LENGTH_SHORT);
      print("Platform exception");
    }
    if (!mounted) return;
  }

  @override
  bool get wantKeepAlive => true;
}
