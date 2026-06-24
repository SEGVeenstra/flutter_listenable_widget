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

## `ViewModel.context` and shared instances (`assignContext`)

`ListenableWidget` assigns its `BuildContext` to `ViewModel.context` on init. For
a **shared** singleton resolved by several widgets, that would mean each widget
overwrites the context the others set. To avoid this, `assignContext` defaults to
`autoDispose`: a widget-owned factory instance gets its context assigned, a shared
singleton (`autoDispose: false`) does not. Override it explicitly if you need the
other behaviour:

```dart
// Single widget owns the instance but disposes it elsewhere — keep context:
super(autoDispose: false, assignContext: true);
```

Because of this, `ViewModel.context` is nullable — always null-check it before
use (`if (context case final ctx?) ...`).
