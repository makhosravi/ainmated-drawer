import 'package:flutter/foundation.dart';

class DrawerState extends ChangeNotifier {
  bool _flip = false;

  bool get flip => _flip;

  set flip(bool newValue) {
    if (newValue != _flip) {
      _flip = newValue;
    }
    notifyListeners();
  }
}
