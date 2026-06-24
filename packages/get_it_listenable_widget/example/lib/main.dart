import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_listenable_widget/get_it_listenable_widget.dart';

final getIt = GetIt.instance;

/// A ViewModel that takes an initial value as a factory param.
class CounterViewModel extends ViewModel {
  CounterViewModel(this.count);

  int count;

  void increment() {
    count++;
    notifyListeners();
  }
}

void main() {
  // P1 = int (initial value), P2 = void (unused).
  getIt.registerFactoryParam<CounterViewModel, int, void>(
    (initial, _) => CounterViewModel(initial),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'get_it_listenable_widget',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('GetIt + ListenableWidget')),
        body: const Center(child: CounterPage(initial: 10)),
      ),
    );
  }
}

/// Resolves [CounterViewModel] from GetIt, passing [initial] as `param1`.
/// `autoDispose` defaults to `true`, which is correct here because the VM is a
/// fresh factory instance owned by this widget.
class CounterPage extends GetItListenableWidget<CounterViewModel, int, void> {
  const CounterPage({required int initial, super.key}) : super(param1: initial);

  @override
  Widget build(BuildContext context, CounterViewModel vm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${vm.count}', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 16),
        FilledButton(onPressed: vm.increment, child: const Text('Increment')),
      ],
    );
  }
}
