import 'package:listenable_widget/listenable_widget.dart';

class SimpleCounterViewModel extends ViewModel {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}
