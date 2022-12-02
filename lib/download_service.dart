import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final Dio _dio;

  DownloadService({Dio? dio}) : _dio = dio ?? Dio();

  Future<void> downloadFile(
      {required String url,
      Future<void> Function(int, int)? onReceiveProgress,
      required Function(File? file) whenComplete}) async {
    File file = await DefaultCacheManager().getSingleFile(url);

    // final downloadDir = await getApplicationDocumentsDirectory();
    // var saveFilePath = '${downloadDir.path}/wallpar.png';
    // var saveFilePath = '${file.path}/wallpar.png';
    // file.readAsString().then((String contents) {
    //   print(contents);
    // });
    var saveFilePath = '${file.path}/wallpar.png';
    await _dio
        .download(url, saveFilePath, onReceiveProgress: onReceiveProgress)
        .whenComplete(() => whenComplete(file));
  }
}

// void setWallpaper(String wallpaperUrl) async {
//   final dir = await getExternalStorageDirectory();
//   print(dir);
//   Dio dio = new Dio();
//   dio.download(
//     wallpaperUrl,
//     "${dir?.path}/wallpar.png",
//     onReceiveProgress: (received, total) {
//       if (total != -1) {
//         double downloadingPer = (received / total * 100);
//         setState(() {
//           downPer = downloadingPer;
//           print(downPer);
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
//     // _showModal(dir);
//   });
// }
