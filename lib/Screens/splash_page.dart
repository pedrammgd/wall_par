import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:wall_par_flutter/Screens/HomePage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  'WallPar',
                )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: Image.asset(
              'assets/image/wall_par_logo.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              fit: BoxFit.contain,
            )),
            Shimmer.fromColors(
                baseColor: Colors.black,
                highlightColor: Colors.grey[300]!,
                child: const Text(
                  'WallPar',
                  style: TextStyle(fontSize: 17),
                )),
            SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}
