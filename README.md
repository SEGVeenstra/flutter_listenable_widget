# ListenableWidget

A conviniënt widget that helps you separate UI from Logic, using [ChangeNotifiers](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html).

## Goal

The aim for this package is provide a simple way of separating UI from Logic while maintaining the simplicity of `StatefulWidget`.

In general, a `StatefulWidget` is structured with both the `Widget` and the `State` in the same file. The function that builds the UI is located inside the `State`.

`ListenableWidget` 'fixes' this by having you to override a `build` method which passes the `ViewModel`.

## Usage

This package is designed to fullfill the VVM of MVVM, where the `ListenableWidget` is the View and the `ChangeNotifier` serves as the `ViewModel`.

A typical implementation will exist of two parts:

### ViewModel

We start with creating our `ViewModel` which must be a `ChangeNotifier`. Whenever we call `notifyListeners()` on our `ViewModel`, the `ListenableWidget` will rebuild.

```dart
class CounterViewModel with ChangeNotifier {
    // While it's not required, using the private + public getter combo
    // prevents consumers from accidently circumventing any notifyListeners.
    int _count = 0;
    int get count => _count;

    void increment() {
        _count++;
        notifyListeners();
    }
}
```

### View

Next we can create our View. We do this by extending `ListenableWidget` and override at least the two required methods, `create` and `build`:

```dart
class CounterView extends ListenableWidget<CounterViewModel> {

    @override
    CounterViewModel create(context) {
        return CounterViewModel();
    }

    @override
    void build(context, viewModel) {
        return Scaffold(
            // imagine beautiful UI here
            Text(viewModel.count)
            // imagine beautiful UI here
            IncrementButton( onPressed: viewModel.increment),
            // imagine beautiful UI here
        );
    }
}
```

## Methods overview

The `ListenableWidget` has three methods of which two are required.

### create (required)

Whenever you extend `ListenableWidget`, you must override `create` to provide a `ViewModel`. This will only be called once, when the `Widget` is created.

Often you will use this to create a new instance of the `ViewModel` but it's also possible to provide an already existing `ViewModel`, like when you want to share state between pages.

```dart
// Example of creating a new instance
@override
MyViewModel create(BuildContext context) {
    return MyViewModel(initialValue);
}

// Example of getting an existing ViewModel using Provider
@override
MyViewModel create(BuildContext context) {
    return context.read<MyViewModel>();
}
```

### build (required)

The other required method to override is `build`. The `build` method should return your UI. It works similar to the `build` method you're used to from `StatelessWidget` and `StatefulWidget`, but has one extra argument which is the `ViewModel`.

The `build` method will be called every time `notifyListeners()` is called on the `ViewModel`.

```dart
@override
Widget build(context, viewModel) {
    return MyWidget(
        onTap: viewModel.doSomething,
        value: viewModel.currentValue,
    );
}
```

### update (optional)

The `update` method is called whenever the `Widget` is updated. Because the `ViewModel` only gets created once, you can use `update` to update the `ViewModel`. This is useful when your `Widget` has fields that can be update by its parent and which should be reflected in the `ViewModel`.

```dart
class CounterWidget extends ListenableWidget<CounterViewModel> {
    // The parent passes a counterMode
    CounterWidget(this.counterMode);

    final CounterMode counterMode; 

    @override
    CounterViewModel create(context) {
        // When the Widget is first created, it will use
        // the counterMode during creation.
        return CounterViewModel(initialCounterMode: counterMode);
    }

    @override
    void update(context, oldWidget, viewModel) {
        // When the widget is updated by the parent, this is called.
        // We then check if the counterMode has changed, if so,
        // we update it on the ViewModel.
        if(oldWidget.counterMode != counterMode) {
            viewModel.updateCounterMode(counterMode);
        }
    }

    @override
    Widget build(context, viewModel) {
        // UI
    }
}
```

## Disposing

By default, `ListenableWidget` will call `dispose` on the `ViewModel` when the `Widget` is disposed so you can clean-up. This should be fine in most cases.

If you have a `Widget` that does __not__ create an instance of the `ViewModel`, but get's it from somewhere else, this most likely means that you __don't__ want your `Widget` to dispose the `ViewModel` either.

In this case you can simply override the `autoDispose` property on your widget to return false.

```dart
@override
final autoDispose = false;
```

## Additional information

This package is aimes for simplicity and that's why you don't find certain things you might find in other state management libraries.

If you wish to optimize rebuilds, it's up to you to do so by calling `notifyListeners()` strategically.

In general, you'd want `ListenableWidget` to instantiate it's own `ViewModel`. For more complex scenarios where you wish to share `ViewModels` you will have to manage that yourself, for example by using [Provider](https://pub.dev/packages/provider).

This package has ironically been born from the desire to __not__ use a package for state management. So if you don't want to rely on a package either, you can also just copy [listenable_widget.dart](https://github.com/SEGVeenstra/flutter_listenable_widget/blob/master/lib/src/listenable_widget.dart) into your project.
