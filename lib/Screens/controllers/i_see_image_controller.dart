import 'package:flutter/foundation.dart';
import 'package:wall_par_flutter/Model/wallpaper.dart';

class ISeeImageController extends ChangeNotifier {
  List<Wallpaper> _wallpaper;

  ISeeImageController(this._wallpaper);

  void changeISee(int index) {
    _wallpaper[index].iSee = true;
    notifyListeners();
  }

  List<Wallpaper> get wallpaper => _wallpaper;

  set wallpaper(List<Wallpaper> value) {
    _wallpaper = value;
    notifyListeners();
  }
}
