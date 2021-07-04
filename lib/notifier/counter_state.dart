import 'package:flutter/foundation.dart';

class CounterState extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  set counter(int newValue) {
    if (_counter != newValue) {
      _counter = newValue;
    }
    notifyListeners();
  }
}
