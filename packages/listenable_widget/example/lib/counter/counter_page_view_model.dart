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
      // context is nullable and only valid while the assigning widget is
      // mounted, so null-check before use.
      final ctx = context;
      if (ctx != null && ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('You reached $_count!')),
        );
      }
    }
  }

  void setIncrementValue(int value) {
    _incrementValue = value;
    notifyListeners();
  }
}
