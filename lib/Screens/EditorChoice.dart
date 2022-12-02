import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wall_par_flutter/Bloc/wallpaperBloc.dart';
import 'package:wall_par_flutter/Bloc/wallpaperEvent.dart';
import 'package:wall_par_flutter/Bloc/wallpaperState.dart';
import 'package:wall_par_flutter/Model/wallpaper.dart';
import 'package:wall_par_flutter/Screens/controllers/i_see_image_controller.dart';
import 'package:wall_par_flutter/Screens/details/details_page.dart';

class EditorChoice extends StatefulWidget {
  final Function(File? file) whenCompleteFunction;

  const EditorChoice({super.key, required this.whenCompleteFunction});

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

  void openPage(int index, ISeeImageController provider) async {
    // Navigation
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailsPage(
                whenComplete: widget.whenCompleteFunction,
                wallpaper: wallpaper[index],
              )),
    );
    if (result == true) {
      provider.changeISee(index);
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
                      context.read<WallpaperBloc>()
                        ..isFetching = true
                        ..add(GetAllWallpaper());
                    },
                    icon: Icon(Icons.refresh),
                  ),
                  const SizedBox(height: 15),
                  Text('Retry', textAlign: TextAlign.center),
                ],
              );
            }
            return ChangeNotifierProvider(
              create: (BuildContext context) => ISeeImageController(wallpaper),
              child: Consumer<ISeeImageController>(
                builder: (context, provider, child) {
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
                                    openPage(index, provider);
                                  },
                                  child: Card(
                                      color: Color(0xff4AA96C).withOpacity(.7),
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            wallpaper[index].portrait ?? '',
                                        fit: BoxFit.cover,
                                        // memCacheHeight: 500,
                                        // memCacheWidth: 500,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                                'assets/image/wall_par_logo.png'),
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
                              if (provider.wallpaper[index].iSee ?? false)
                                Positioned(
                                    top: 5,
                                    right: 10,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.black,
                                      highlightColor: Colors.grey[300]!,
                                      child: Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: Colors.white,
                                      ),
                                    )),
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
                },
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

  @override
  bool get wantKeepAlive => true;
}
