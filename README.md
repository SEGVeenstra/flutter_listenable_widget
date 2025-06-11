A conviniënt widget that helps you separate UI from Logic, using ChangeNotifiers.

## Goal

The aim for this package is provide a simple way of separating UI from Logic while maintaining the simplicity of StatefulWidget.

In general, a StatefulWidget is structured with both the Widget and the State in the same file. The function that builds the UI is located inside the State.

ListenableWidget 'fixes' this by having you to override a buildView method which passes the ViewModel.

## Usage

This package is designed to fullfill the VVM of MVVM, where the ListenableWidget is the View and the ChangeNotifier serves as the ViewModel.

A typical implementation will exist of two parts:

### ViewModel

We start with creating our ViewModel which must be a ChangeNotifier. Whenever we call notifyListeners(), the ListenableWidget will rebuild.

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

Next we can create our View. We do this by extending ListenableWidget and override at least the two required methods, create and buildView:

```dart
class CounterView extends ListenableWidget<CounterViewModel> {

    CounterViewModel create(context) {
        return CounterViewModel();
    }

    void buildView(context, viewModel) {
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

The ListenableWidget has three methods of which two are required.

### create (required)

Whenever you extend ListenableWidget, you must override `create` to provide the `Widget` with a `ViewModel`. This will only be called once, when the `Widget` is created.

Often you will use this to create a new instance of the `ViewModel` but it's also possible to provide an already existing `ViewModel`, like when you want to share state between pages.

```dart
// Example of creating a new instance
MyViewModel create(BuildContext context) {
    return MyViewModel(initialValue);
}

// Example of getting an existing ViewModel using Provider
MyViewModel create(BuildContext context) {
    return context.read<MyViewModel>();
}
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
