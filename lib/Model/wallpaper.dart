class Wallpaper {
  String? original;
  String? portrait;
  bool? isDownloading;

  Wallpaper({this.original, this.portrait, this.isDownloading});

  Wallpaper.fromMap(Map<String, dynamic> map) {
    this.original = map["src"]["original"];
    this.portrait = map["src"]["portrait"];
    this.isDownloading = map["src"]["isDownloading"];
  }

  toJson() {
    return {
      "original": this.original,
      "portrait": this.portrait,
    };
  }
}
