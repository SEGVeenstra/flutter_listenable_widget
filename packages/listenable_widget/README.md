# ListenableWidget

A conveniënt widget that helps you separate UI from Logic, using [ChangeNotifiers](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html).

## Goal

The aim for this package is provide a simple way of separating UI from Logic while maintaining the simplicity of `StatefulWidget`.

In general, a `StatefulWidget` is structured with both the `Widget` and the `State` in the same file. The function that builds the UI is located inside the `State`.

`ListenableWidget` 'fixes' this by having you to override a `build` method which passes the `ViewModel`.

## Usage

This package is designed to fullfill the VVM of MVVM, where the `ListenableWidget` is the View and the `ChangeNotifier` serves as the `ViewModel`.

A typical implementation will exist of two parts:

### ViewModel

We start with creating our `ViewModel` which must extend `ViewModel` (which itself extends `ChangeNotifier`). Whenever we call `notifyListeners()` on our `ViewModel`, the `ListenableWidget` will rebuild.

```dart
class CounterViewModel extends ViewModel {
    // While it's not required, using the private + public getter combo
    // prevents consumers from accidentally circumventing any notifyListeners.
    int _count = 0;
    int get count => _count;

    void increment() {
        _count++;
        notifyListeners();
    }
}
```

### View

Next we can create our View. We do this by extending `ListenableWidget` and overriding at least the `build` method. There are four ways to do this, described in the [usage patterns](#usage-patterns) section below.

## Usage patterns

### 1 — Classic: override `create`

The widget creates its own ViewModel. Best when the widget and ViewModel live in the same package and the widget is responsible for the full lifecycle.

```dart
class CounterPage extends ListenableWidget<CounterViewModel> {

    @override
    CounterViewModel create(BuildContext context) {
        return CounterViewModel();
    }

    @override
    Widget build(BuildContext context, CounterViewModel viewModel) {
        return Scaffold(
            // imagine beautiful UI here
            body: Text('${viewModel.count}'),
            floatingActionButton: FloatingActionButton(
                onPressed: viewModel.increment,
            ),
        );
    }
}
```

### 2 — UI kit: pass `viewModelFactory`

The widget does not know how to create the ViewModel; the caller supplies a factory. This is the recommended pattern for **UI kit widgets** that must stay data-layer-agnostic: the widget defines the UI, the calling code provides the ViewModel.

```dart
// In the UI kit — no data-layer knowledge:
class CounterPage extends ListenableWidget<CounterViewModel> {
    const CounterPage({required super.viewModelFactory, super.key});

    @override
    Widget build(BuildContext context, CounterViewModel vm) {
        return Scaffold(
            body: Text('${vm.count}'),
            floatingActionButton: FloatingActionButton(
                onPressed: vm.increment,
            ),
        );
    }
}

// In the app — knows the data layer:
CounterPage(
    viewModelFactory: (ctx) => CounterViewModel(repo: ctx.read<CounterRepo>()),
)
```

### 3 — Abstract ViewModel (interface + implementation)

Define the ViewModel as an abstract class (interface) in the UI kit. The app provides a concrete implementation; tests use a mock. All three work through the same `viewModelFactory` parameter, giving you full test isolation without any mocking framework.

```dart
// UI kit: interface
abstract class CounterViewModel extends ViewModel {
    int get count;
    void increment();
}

// UI kit: widget
class CounterPage extends ListenableWidget<CounterViewModel> {
    const CounterPage({required super.viewModelFactory, super.key});

    @override
    Widget build(BuildContext context, CounterViewModel vm) {
        return Text('${vm.count}');
    }
}

// App: concrete implementation
class CounterViewModelImpl extends CounterViewModel {
    final CounterRepo _repo;
    CounterViewModelImpl(this._repo);

    @override
    int get count => _repo.count;

    @override
    void increment() {
        _repo.increment();
        notifyListeners();
    }
}

CounterPage(viewModelFactory: (ctx) => CounterViewModelImpl(ctx.read()))

// Test: plain mock, no extra library needed
class MockCounterViewModel extends CounterViewModel {
    @override int count = 42;
    @override void increment() {}
}

CounterPage(viewModelFactory: (_) => MockCounterViewModel())
```

### 4 — Inline: `ListenableWidgetBuilder`

When you don't want to create a dedicated subclass, use `ListenableWidgetBuilder`. It accepts all behaviour via constructor callbacks, similar to how Flutter's own `ListenableBuilder` works.

```dart
ListenableWidgetBuilder<CounterViewModel>(
    viewModelFactory: (_) => CounterViewModel(),
    builder: (ctx, vm) => Text('${vm.count}'),
)
```

## Methods overview

The `ListenableWidget` has four methods of which only `build` is required.

### build (required)

The `build` method should return your UI. It works similar to the `build` method you're used to from `StatelessWidget` and `StatefulWidget`, but has one extra argument which is the `ViewModel`.

The `build` method will be called every time `notifyListeners()` is called on the `ViewModel`.

```dart
@override
Widget build(BuildContext context, MyViewModel viewModel) {
    return MyWidget(
        onTap: viewModel.doSomething,
        value: viewModel.currentValue,
    );
}
```

### create (optional)

Override `create` to instantiate the ViewModel inside the widget. Alternatively, pass a `viewModelFactory` to the constructor — both have the same effect. If neither is provided, a runtime error is thrown.

```dart
// Option A: override create
@override
MyViewModel create(BuildContext context) {
    return MyViewModel(initialValue);
}

// Option B: constructor parameter (no override needed)
MyWidget(viewModelFactory: (ctx) => MyViewModel(initialValue))

// Getting an existing ViewModel from a DI framework also works:
@override
MyViewModel create(BuildContext context) {
    return context.read<MyViewModel>();
}
```

### onWidgetChanged (optional)

Called whenever the widget is updated with a new configuration. Because the ViewModel is only created once, use `onWidgetChanged` to sync widget fields into the ViewModel when the parent rebuilds with new values.

```dart
class CounterWidget extends ListenableWidget<CounterViewModel> {
    CounterWidget({required this.counterMode, super.key});

    final CounterMode counterMode;

    @override
    CounterViewModel create(BuildContext context) {
        return CounterViewModel(initialCounterMode: counterMode);
    }

    @override
    void onWidgetChanged(BuildContext context, CounterWidget oldWidget, CounterViewModel viewModel) {
        if (oldWidget.counterMode != counterMode) {
            viewModel.updateCounterMode(counterMode);
        }
    }

    @override
    Widget build(BuildContext context, CounterViewModel viewModel) {
        // UI
    }
}
```

### onDependenciesChanged (optional)

Called whenever the widget's dependencies change (such as InheritedWidgets). Use this to update the ViewModel or perform any necessary actions when the dependencies change.

```dart
@override
void onDependenciesChanged(BuildContext context, MyViewModel viewModel) {
    final theme = Theme.of(context);
    viewModel.updateTheme(theme);
}
```

## Disposing

By default, `ListenableWidget` will call `dispose` on the `ViewModel` when the widget is disposed so you can clean up. This should be fine in most cases.

If your widget does __not__ create the ViewModel itself but gets it from somewhere else (e.g. a DI framework), you likely want to manage the ViewModel's lifecycle externally. In that case, override `autoDispose` to return `false`.

```dart
@override
bool get autoDispose => false;
```

## Additional information

This package aims for simplicity and that's why you don't find certain things you might find in other state management libraries.

If you wish to optimize rebuilds, it's up to you to do so by calling `notifyListeners()` strategically.

In general, you'd want `ListenableWidget` to instantiate its own `ViewModel`. For more complex scenarios where you wish to share `ViewModels` you will have to manage that yourself, for example by using [Provider](https://pub.dev/packages/provider).

This package has ironically been born from the desire to __not__ use a package for state management. So if you don't want to rely on a package either, you can also just copy [listenable_widget.dart](https://github.com/SEGVeenstra/flutter_listenable_widget/blob/master/lib/src/listenable_widget.dart) into your project.
