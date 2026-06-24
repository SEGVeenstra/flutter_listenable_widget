import 'package:flutter/material.dart';
import 'package:listenable_widget/listenable_widget.dart';

class CounterPageViewModel extends ViewModel {
  CounterPageViewModel({int incrementValue = 1})
    : _incrementValue = incrementValue;

  int _incrementValue;
  int get incrementValue => _incrementValue;
  int _count = 0;

  int get count => _count;

  void incrementCounter() {
    _count += _incrementValue;
    notifyListeners();
    if (_count % 10 == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You reached $_count!')),
      );
    }
  }

  void setIncrementValue(int value) {
    _incrementValue = value;
    notifyListeners();
  }
}
