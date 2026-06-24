import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_listenable_widget/get_it_listenable_widget.dart';

class CounterViewModel extends ViewModel {
  CounterViewModel({this.initial = 0, this.label = ''}) : count = initial;

  final int initial;
  final String label;
  int count;

  void increment() {
    count++;
    notifyListeners();
  }
}

/// Subclass used to verify factory params and default disposal.
class CounterPage extends GetItListenableWidget<CounterViewModel, int, String> {
  const CounterPage({
    super.param1,
    super.param2,
    super.instanceName,
    super.getIt,
    super.autoDispose,
    super.assignContext,
    super.key,
  });

  @override
  Widget build(BuildContext context, CounterViewModel vm) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: vm.increment,
        child: Text('${vm.label}:${vm.count}'),
      ),
    );
  }
}

Widget wrap(Widget child) =>
    Directionality(textDirection: TextDirection.ltr, child: child);

void main() {
  late GetIt getIt;

  setUp(() => getIt = GetIt.asNewInstance());
  tearDown(() => getIt.reset());

  testWidgets('forwards param1/param2 via a custom GetIt instance', (
    tester,
  ) async {
    getIt.registerFactoryParam<CounterViewModel, int, String>(
      (initial, label) => CounterViewModel(initial: initial, label: label),
    );

    await tester.pumpWidget(
      CounterPage(param1: 5, param2: 'hits', getIt: getIt),
    );

    expect(find.text('hits:5'), findsOneWidget);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();
    expect(find.text('hits:6'), findsOneWidget);
  });

  testWidgets('disposes a factory VM on unmount by default', (tester) async {
    late CounterViewModel created;
    getIt.registerFactoryParam<CounterViewModel, int, String>((initial, label) {
      created = CounterViewModel(initial: initial, label: label);
      return created;
    });

    await tester.pumpWidget(CounterPage(param1: 1, param2: 'x', getIt: getIt));
    expect(created.isDisposed, isFalse);

    await tester.pumpWidget(wrap(const SizedBox.shrink()));
    expect(created.isDisposed, isTrue);
  });

  testWidgets('does not dispose a singleton when autoDispose is false', (
    tester,
  ) async {
    final singleton = CounterViewModel(initial: 3, label: 'shared');
    getIt.registerSingleton<CounterViewModel>(singleton);

    await tester.pumpWidget(
      CounterPage(getIt: getIt, autoDispose: false),
    );
    expect(find.text('shared:3'), findsOneWidget);

    await tester.pumpWidget(wrap(const SizedBox.shrink()));
    expect(singleton.isDisposed, isFalse);
  });

  testWidgets('assigns context for an owned factory VM by default', (
    tester,
  ) async {
    late CounterViewModel created;
    getIt.registerFactoryParam<CounterViewModel, int, String>((initial, label) {
      created = CounterViewModel(initial: initial, label: label);
      return created;
    });

    await tester.pumpWidget(CounterPage(param1: 1, param2: 'x', getIt: getIt));

    expect(created.context, isNotNull);
  });

  testWidgets('does not assign context to a shared singleton by default', (
    tester,
  ) async {
    final singleton = CounterViewModel(initial: 3, label: 'shared');
    getIt.registerSingleton<CounterViewModel>(singleton);

    // autoDispose: false => assignContext defaults to false too.
    await tester.pumpWidget(CounterPage(getIt: getIt, autoDispose: false));

    expect(singleton.context, isNull);
  });

  testWidgets('assignContext overrides the autoDispose-derived default', (
    tester,
  ) async {
    final singleton = CounterViewModel(initial: 3, label: 'shared');
    getIt.registerSingleton<CounterViewModel>(singleton);

    await tester.pumpWidget(
      CounterPage(getIt: getIt, autoDispose: false, assignContext: true),
    );

    expect(singleton.context, isNotNull);
  });

  testWidgets('honors instanceName', (tester) async {
    getIt.registerSingleton<CounterViewModel>(
      CounterViewModel(initial: 1, label: 'a'),
      instanceName: 'a',
    );
    getIt.registerSingleton<CounterViewModel>(
      CounterViewModel(initial: 2, label: 'b'),
      instanceName: 'b',
    );

    await tester.pumpWidget(
      CounterPage(getIt: getIt, instanceName: 'b', autoDispose: false),
    );

    expect(find.text('b:2'), findsOneWidget);
  });

  testWidgets('GetItListenableWidgetBuilder rebuilds on notifyListeners', (
    tester,
  ) async {
    getIt.registerFactoryParam<CounterViewModel, int, String>(
      (initial, label) => CounterViewModel(initial: initial, label: label),
    );

    await tester.pumpWidget(
      wrap(
        GetItListenableWidgetBuilder<CounterViewModel, int, String>(
          param1: 0,
          param2: 'n',
          getIt: getIt,
          builder: (context, vm) => GestureDetector(
            onTap: vm.increment,
            child: Text('${vm.label}:${vm.count}'),
          ),
        ),
      ),
    );

    expect(find.text('n:0'), findsOneWidget);
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();
    expect(find.text('n:1'), findsOneWidget);
  });
}
