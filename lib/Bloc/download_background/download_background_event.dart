import 'dart:io';

abstract class DownloadBackgroundEvent {}

class DownloadStarted extends DownloadBackgroundEvent {
  final String url;
  final Function(File? file) whenComplete;
  DownloadStarted({
    required this.url,
    required this.whenComplete,
  });
}

class DownloadWallpaperChanged extends DownloadBackgroundEvent {
  final String url;
  final double downPer;

  // double get downPer => _downPer;
  //
  // bool get downloadImage => _downloadImage;
  // String get url => _url;

  DownloadWallpaperChanged(
    this.downPer,
    this.url,
  );
}

class DownloadError extends DownloadBackgroundEvent {}
