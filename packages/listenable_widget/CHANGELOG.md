## 0.3.0

* **BREAKING** `ViewModel.context` is now nullable (`BuildContext?`) and is no
  longer a `late` field. It is `null` until a widget assigns one.
* feat - `ListenableWidget.assignContext` controls whether the widget assigns its
  `BuildContext` to `ViewModel.context`. Defaults to `true`, but `false` when a
  pre-built `viewModel` is supplied, so a shared ViewModel's context is not
  overwritten by every widget that uses it. Also exposed on
  `ListenableWidgetBuilder`.

## 0.2.0

* refactor - update -> onWidgetChanged
* feat - onDependencyChanged
* refactor - Example
* docs - Document new changes

## 0.1.0

* Initial release
