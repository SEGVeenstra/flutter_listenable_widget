import 'package:listenable_widget/listenable_widget.dart';

/// Abstract ViewModel used in variant 3. The widget only knows this interface,
/// not the concrete implementation. Swap [ConcreteCounterViewModel] for a mock
/// in tests without any mocking framework.
abstract class AbstractCounterViewModel extends ViewModel {
  int get count;
  void increment();
}

class ConcreteCounterViewModel extends AbstractCounterViewModel {
  int _count = 0;

  @override
  int get count => _count;

  @override
  void increment() {
    _count++;
    notifyListeners();
  }
}
