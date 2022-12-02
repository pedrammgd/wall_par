import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wall_par_flutter/Bloc/categoryWallpaperBloc.dart';
import 'package:wall_par_flutter/Bloc/wallpaperEvent.dart';
import 'package:wall_par_flutter/Bloc/wallpaperState.dart';
import 'package:wall_par_flutter/Model/wallpaper.dart';
import 'package:wall_par_flutter/Screens/controllers/i_see_image_controller.dart';
import 'package:wall_par_flutter/Screens/details/details_page.dart';
import 'package:wall_par_flutter/repositories/category_page_repository.dart';

import 'details/Detail.dart';

class Category extends StatefulWidget {
  final String category;
  final Function(File? file) whenCompleteFunction;

  Category({required this.category, required this.whenCompleteFunction});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
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

  // void showAd(Wallpaper wallpaper) {
  //   print("inside");
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

  final List<Wallpaper> wallpaper = [];
  final ScrollController _scrollController = ScrollController();
  late CategoryWallpaperBloc categoryWallpaperBloc;

  @override
  Widget build(BuildContext context) {
    // categoryWallpaperBloc = BlocProvider.of<CategoryWallpaperBloc>(context);
    // categoryWallpaperBloc.add(CategoryWallpaper(category: widget.category));
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = (size.width / 2);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
          title: Text(
            widget.category,
            style: TextStyle(
              fontFamily: 'Raleway',
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            wallpaper.clear();
            context.read<CategoryWallpaperBloc>()
              ..isFetching = true
              ..add(CategoryWallpaper(category: widget.category));
          },
          child: Center(
            child: BlocConsumer<CategoryWallpaperBloc, WallpaperState>(
              listener: (context, state) {
                if (state is CategoryWallpaperIsLoading) {
                } else if (state is CategoryWallpaperIsLoaded &&
                    state.getCategoryWallpaper.isEmpty) {
                } else if (state is CategoryWallpaperIsNotLoaded) {
                  //     .showSnackBar(SnackBar(content: Text('Error')));
                  context.read<CategoryWallpaperBloc>().isFetching = false;
                }
                // // return;
              },
              builder: (BuildContext context, state) {
                if (state is WallpaperCategoryInitial ||
                    state is CategoryWallpaperIsLoading && wallpaper.isEmpty) {
                  return Center(
                    child: LoadingAnimationWidget.threeRotatingDots(
                        color: Colors.black, size: 20),
                  );
                } else if (state is CategoryWallpaperIsLoaded) {
                  wallpaper.addAll(state.getCategoryWallpaper);
                  context.read<CategoryWallpaperBloc>().isFetching = false;
                  // Scaffold.of(context).hideCurrentSnackBar();
                } else if (state is CategoryWallpaperIsNotLoaded &&
                    wallpaper.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<CategoryWallpaperBloc>()
                            ..isFetching = true
                            ..add(CategoryWallpaper(category: widget.category));
                        },
                        icon: Icon(Icons.refresh),
                      ),
                      const SizedBox(height: 15),
                      Text('Retry', textAlign: TextAlign.center),
                    ],
                  );
                }
                return ChangeNotifierProvider(
                  create: (BuildContext context) =>
                      ISeeImageController(wallpaper),
                  child: Consumer<ISeeImageController>(
                    builder: (context, provider, child) {
                      return SingleChildScrollView(
                        controller: _scrollController
                          ..addListener(() {
                            if (_scrollController.offset ==
                                    _scrollController
                                        .position.maxScrollExtent &&
                                !context
                                    .read<CategoryWallpaperBloc>()
                                    .isFetching) {
                              context.read<CategoryWallpaperBloc>()
                                ..isFetching = true
                                ..add(CategoryWallpaper(
                                    category: widget.category));
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
                                repeatPattern:
                                    QuiltedGridRepeatPattern.inverted,
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
                                          color:
                                              Color(0xff4AA96C).withOpacity(.7),
                                          semanticContainer: true,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                            if (context
                                .read<CategoryWallpaperBloc>()
                                .isFetching)
                              Center(
                                  child:
                                      LoadingAnimationWidget.threeRotatingDots(
                                          color: Colors.black, size: 20)),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        )
        // BlocBuilder<CategoryWallpaperBloc, WallpaperState>(
        //   builder: (BuildContext context, state) {
        //     if (state is CategoryWallpaperIsLoading) {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     } else if (state is CategoryWallpaperIsLoaded) {
        //       return GridView.builder(
        //         padding: EdgeInsets.all(5),
        //         itemCount: state.getCategoryWallpaper.length,
        //         scrollDirection: Axis.vertical,
        //         gridDelegate: SliverQuiltedGridDelegate(
        //           crossAxisCount: 4,
        //           mainAxisSpacing: 4,
        //           crossAxisSpacing: 4,
        //           repeatPattern: QuiltedGridRepeatPattern.inverted,
        //           pattern: [
        //             QuiltedGridTile(2, 2),
        //             QuiltedGridTile(1, 2),
        //             QuiltedGridTile(1, 1),
        //             QuiltedGridTile(1, 1),
        //           ],
        //         ),
        //         itemBuilder: (BuildContext context, int index) {
        //           return Container(
        //             child: GestureDetector(
        //               onTap: () {
        //                 counter == 2
        //                     ? showAd(state.getCategoryWallpaper[index])
        //                     : openPage(state.getCategoryWallpaper[index]);
        //               },
        //               child: Card(
        //                 semanticContainer: true,
        //                 clipBehavior: Clip.antiAliasWithSaveLayer,
        //                 shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(10),
        //                 ),
        //                 child: Hero(
        //                   tag: state.getCategoryWallpaper[index].portrait??'',
        //                   child: FadeInImage.assetNetwork(
        //                     image: state.getCategoryWallpaper[index].portrait??'',
        //                     fit: BoxFit.cover,
        //                     placeholder: "assets/image/abstract.jpg",
        //                     imageScale: 1,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           );
        //         },
        //       );
        //     } else if (state is CategoryWallpaperIsNotLoaded) {
        //       return Center(
        //         child: Text("Error Loading Wallpapers."),
        //       );
        //     } else {
        //       return Text("WentWorng.");
        //     }
        //   },
        // ),
        );
  }
}
