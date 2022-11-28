import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wall_par_flutter/Bloc/searchWallpaperBloc.dart';
import 'package:wall_par_flutter/Bloc/wallpaperEvent.dart';
import 'package:wall_par_flutter/Bloc/wallpaperState.dart';
import 'package:wall_par_flutter/Model/wallpaper.dart';
import 'package:wall_par_flutter/Screens/Detail.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final List<Wallpaper> wallpaper = [];
  final ScrollController _scrollController = ScrollController();

  int counter = 0;
  late SearchWallpaperBloc _wallpaperBloc;
  TextEditingController searchController = TextEditingController();

  // final FocusNode _focusNode = FocusNode();
  Icon actionIcon = Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    _wallpaperBloc = BlocProvider.of<SearchWallpaperBloc>(context);
    _wallpaperBloc.add(SearchWallpaper(search: 'wallpaper'));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: AnimSearchBar(
          autoFocus: true,
          color: Color(0xff4AA96C),
          closeSearchOnSuffixTap: true,
          width: MediaQuery.of(context).size.width - 32,
          textController: searchController,
          suffixIcon: Icon(Icons.search),
          onSuffixTap: () {
            wallpaper.clear();
            context.read<SearchWallpaperBloc>()
              ..isFetching = true
              ..add(SearchWallpaper(search: searchController.text));
          },
        ),
        // title: TextField(
        //   autofocus: true,
        //   // focusNode: _focusNode,
        //   controller: searchController,
        //   decoration: InputDecoration(hintText: "Search.."),
        //   keyboardType: TextInputType.text,
        //   textInputAction: TextInputAction.search,
        //   // onChanged: (value) {
        //   //   _wallpaperBloc.add(SearchWallpaper(string: value));
        //   // },
        //   onEditingComplete: () {
        //     // FocusScope.of(context).requestFocus(FocusNode());
        //     _wallpaperBloc.add(SearchWallpaper(string: searchController.text));
        //   },
        // ),
        // actions: <Widget>[
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: IconButton(
        //       alignment: Alignment.centerRight,
        //       onPressed: () {
        //         FocusScope.of(context).requestFocus(FocusNode());
        //         _wallpaperBloc
        //             .add(SearchWallpaper(string: searchController.text));
        //       },
        //       icon: Icon(Icons.search),
        //     ),
        //   ),
        // ],
      ),
      body: _data(context),
    );
  }

  void openPage(Wallpaper wallpaper) {
    counter++;
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => Detail(
          wallpaper: wallpaper,
        ),
      ),
    );
  }

  void showAd(Wallpaper wallpaper) {
    //TODO add Ad
    counter = 0;
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => Detail(
          wallpaper: wallpaper,
        ),
      ),
    );
  }

  Widget _data(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = (size.width / 2);
    return RefreshIndicator(
      onRefresh: () async {
        wallpaper.clear();
        context.read<SearchWallpaperBloc>()
          ..isFetching = true
          ..add(SearchWallpaper(search: 'wallpaper'));
      },
      child: Center(
        child: BlocConsumer<SearchWallpaperBloc, WallpaperState>(
          listener: (context, state) {
            if (state is SearchWallpaperIsLoading) {
              // Scaffold.of(context)
              //     .showSnackBar(SnackBar(content: Text('Loading')));
            } else if (state is SearchWallpaperIsLoaded &&
                state.getSearchWallpaper.isEmpty) {
              // Scaffold.of(context)
              //     .showSnackBar(SnackBar(content: Text('No more beers')));
            } else if (state is SearchWallpaperIsNotLoaded) {
              // Scaffold.of(context)
              //     .showSnackBar(SnackBar(content: Text('Error')));
              context.read<SearchWallpaperBloc>().isFetching = false;
            }
            // // return;
          },
          builder: (BuildContext context, state) {
            if (state is SearchWallpaperInitial ||
                state is SearchWallpaperIsLoading && wallpaper.isEmpty) {
              return Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.black, size: 20),
              );
            } else if (state is SearchWallpaperIsLoaded) {
              wallpaper.addAll(state.getSearchWallpaper);
              context.read<SearchWallpaperBloc>().isFetching = false;
              // Scaffold.of(context).hideCurrentSnackBar();
            } else if (state is SearchWallpaperIsNotLoaded &&
                wallpaper.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      context.bloc<SearchWallpaperBloc>()
                        ..isFetching = true
                        ..add(SearchWallpaper(search: 'wallpaper'));
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
                      !context.read<SearchWallpaperBloc>().isFetching) {
                    context.read<SearchWallpaperBloc>()
                      ..isFetching = true
                      ..add(SearchWallpaper(search: 'feather'));
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
                              openPage(wallpaper[index]);
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
                  if (context.read<SearchWallpaperBloc>().isFetching)
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
      ),
    );
  }
}
