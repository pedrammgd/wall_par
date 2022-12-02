class Wallpaper {
  String? original;
  String? portrait;
  bool? iSee;

  Wallpaper({this.original, this.portrait, this.iSee = false});

  Wallpaper.fromMap(Map<String, dynamic> map) {
    this.original = map["src"]["original"];
    this.portrait = map["src"]["portrait"];
    this.iSee = map["src"]["iSee"];
  }

  toJson() {
    return {
      "original": this.original,
      "portrait": this.portrait,
    };
  }
}
