# get_it_listenable_widget

A [`ListenableWidget`](https://pub.dev/packages/listenable_widget) that resolves
its ViewModel from [GetIt](https://pub.dev/packages/get_it), so you don't have to
wire `viewModelFactory` by hand in every screen.

It removes this boilerplate:

```dart
class CounterPage extends ListenableWidget<CounterViewModel> {
  const CounterPage({super.key})
      : super(viewModelFactory: _resolve);

  static CounterViewModel _resolve(BuildContext _) =>
      GetIt.instance.get<CounterViewModel>();
  // ...
}
```

## Install

```yaml
dependencies:
  get_it_listenable_widget: ^0.1.0
```

Importing this package re-exports `listenable_widget`, so `ViewModel` and friends
come along for free:

```dart
import 'package:get_it_listenable_widget/get_it_listenable_widget.dart';
```

## Usage

The three type parameters mirror GetIt's factory shape: `<VM, P1, P2>` where `P1`
/ `P2` are the optional `param1` / `param2`. Use `void` for unused slots.

### No params

```dart
class CounterPage extends GetItListenableWidget<CounterViewModel, void, void> {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, CounterViewModel vm) =>
      Text('${vm.count}');
}
```

### With factory params

```dart
// Registration:
getIt.registerFactoryParam<CounterViewModel, int, void>(
  (initial, _) => CounterViewModel(initial),
);

// Widget:
class CounterPage extends GetItListenableWidget<CounterViewModel, int, void> {
  const CounterPage({required int initial, super.key})
      : super(param1: initial);

  @override
  Widget build(BuildContext context, CounterViewModel vm) =>
      Text('${vm.count}');
}
```

### Inline, without a subclass

```dart
GetItListenableWidgetBuilder<CounterViewModel, int, void>(
  param1: 10,
  builder: (context, vm) => Text('${vm.count}'),
)
```

### Named instances / custom GetIt instance

```dart
GetItListenableWidgetBuilder<CounterViewModel, void, void>(
  instanceName: 'secondary',
  getIt: myScopedGetIt,
  builder: (context, vm) => Text('${vm.count}'),
)
```

## Lifecycle (`autoDispose`)

`autoDispose` defaults to **`true`** — the widget disposes the ViewModel when it
leaves the tree. That is correct for `registerFactoryParam` / `registerFactory`,
where each lookup returns a fresh instance the widget owns.

When you resolve a **shared** instance (`registerSingleton` /
`registerLazySingleton`), pass `autoDispose: false` so the widget never disposes
an instance owned by GetIt:

```dart
class HomePage extends GetItListenableWidget<HomeViewModel, void, void> {
  const HomePage({super.key}) : super(autoDispose: false); // shared singleton

  @override
  Widget build(BuildContext context, HomeViewModel vm) => /* ... */;
}
```
