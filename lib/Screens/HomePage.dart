import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wall_par_flutter/Bloc/wallpaperBloc.dart';
import 'package:wall_par_flutter/Model/wallpaper.dart';
import 'package:wall_par_flutter/Screens/CategoryList.dart' as categoryScreen;
import 'package:wall_par_flutter/Screens/EditorChoice.dart';
import 'package:wall_par_flutter/Screens/Search.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage(
    this.title,
  );

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WallpaperBloc _wallpaperBloc;
  int _selectedIndex = 0;
  PageController controller = PageController();
  List<GButton> tabs = [];

  @override
  void initState() {
    super.initState();
    var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
    double gap = 10;

    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Color(0xff4AA96C),
      iconColor: Colors.black,
      textColor: Color(0xff4AA96C),
      backgroundColor: Color(0xff4AA96C).withOpacity(.2),
      iconSize: 24,
      padding: padding,
      icon: AkarIcons.home,
      text: "Home",
    ));

    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Color(0xff4AA96C),
      iconColor: Colors.black,
      textColor: Color(0xff4AA96C),
      backgroundColor: Color(0xff4AA96C).withOpacity(.2),
      iconSize: 24,
      padding: padding,
      icon: AkarIcons.grid,
      text: 'Category',
    ));
    // tabs.add(GButton(
    //   gap: gap,
    //   iconActiveColor: Color(0xff4AA96C),
    //   iconColor: Colors.black,
    //   textColor: Color(0xff4AA96C),
    //   backgroundColor: Color(0xff4AA96C).withOpacity(.2),
    //   iconSize: 24,
    //   padding: padding,
    //   icon: AkarIcons.heart,
    //   text: 'Favorite',
    // ));
    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Color(0xff4AA96C),
      iconColor: Colors.black,
      textColor: Color(0xff4AA96C),
      backgroundColor: Color(0xff4AA96C).withOpacity(.2),
      iconSize: 24,
      padding: padding,
      icon: AkarIcons.search,
      text: 'Search',
    ));
  }

  @override
  Widget build(BuildContext context) {
    // _wallpaperBloc = BlocProvider.of<WallpaperBloc>(context);
    // _wallpaperBloc.add(GetAllWallpaper());
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/wall_par_logo.png',
              height: 50,
              width: 25,
              fit: BoxFit.cover,
            ),
            Text(
              widget.title,
              style: TextStyle(
                fontFamily: 'Raleway',
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.info_outline,
        //       color: Colors.black,
        //     ),
        //     onPressed: () {
        //       Navigator.push(
        //           context, CupertinoPageRoute(builder: (context) => Setting()));
        //     },
        //   )
        // ],
      ),
      body: PageView.builder(
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        controller: controller,
        itemBuilder: (BuildContext context, int index) {
          return getScreen(index);
        },
        itemCount: tabs.length,
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: -10,
                        blurRadius: 60,
                        color: Colors.black.withOpacity(.20),
                        offset: Offset(0, 15))
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                child: GNav(
                    tabBorderRadius: 10,
                    tabs: tabs,
                    selectedIndex: _selectedIndex,
                    onTabChange: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                      controller.jumpToPage(index);
                    }),
              ),
            ),
            // Spacer(),
            // Padding(
            //   padding: EdgeInsets.only(right: 20, top: 20, bottom: 20),
            //   child: FloatingActionButton(
            //     backgroundColor: Colors.white,
            //     child: Icon(
            //       Icons.search,
            //       color: Colors.black,
            //     ),
            //     onPressed: () {
            //       Navigator.push(context,
            //           CupertinoPageRoute(builder: (context) => Search()));
            //     },
            //     elevation: 3.0,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

getScreen(int selectedIndex) {
  if (selectedIndex == 0) {
    return EditorChoice();
  } else if (selectedIndex == 1) {
    return categoryScreen.CategoryList();
  } else {
    return Search();
  }
}
