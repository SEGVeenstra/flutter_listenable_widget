import 'package:flutter/cupertino.dart';

class CounterPageViewModel with ChangeNotifier {
  CounterPageViewModel({int incrementValue = 1})
    : _incrementValue = incrementValue;

  int _incrementValue;
  int get incrementValue => _incrementValue;
  int _count = 0;

  int get count => _count;

  void incrementCounter() {
    // Here we update the ViewModel and notify its listeners.
    // This will trigger the ListenableWidget to call the buildView method again.
    _count += _incrementValue;
    notifyListeners();
  }

  void setIncrementValue(int value) {
    _incrementValue = value;
    notifyListeners();
  }

  @override
  void dispose() {
    // Here we can clean up any resources if needed.
    // ListenableWidget will automatically call this method when the widget is disposed.
    super.dispose();
  }
}
