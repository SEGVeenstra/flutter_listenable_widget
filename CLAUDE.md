# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Analyze (lint)
flutter analyze

# Run the example app
cd example && flutter run
```

## Architecture

This is a minimal Flutter package (`listenable_widget`) that implements an MVVM pattern on top of Flutter's built-in `ChangeNotifier` and `ListenableBuilder`.

### How it works

`ListenableWidget<T>` is an abstract `StatefulWidget`. Consumers extend it and override two required methods:

- **`create(context)`** — called once at init to produce the `ChangeNotifier` (the ViewModel). Can return a new instance or one retrieved externally (e.g. via Provider).
- **`build(context, viewModel)`** — called on every `notifyListeners()` to rebuild the UI.

Two optional hooks mirror the `State` lifecycle:

- **`onWidgetChanged(context, oldWidget, viewModel)`** — maps to `didUpdateWidget`; use this to sync widget fields into the ViewModel when the parent rebuilds with new values.
- **`onDependenciesChanged(context, viewModel)`** — maps to `didChangeDependencies`; use to react to `InheritedWidget` changes.

The `autoDispose` getter (default `true`) controls whether the ViewModel is disposed when the widget leaves the tree. Set to `false` when the ViewModel is owned externally.

Internally, `_ListenableWidgetState` wraps `widget.build` in a `ListenableBuilder`, so only the widget's subtree re-renders on `notifyListeners()` — no `setState` needed.

### File layout

- `lib/src/listenable_widget.dart` — the entire implementation (~77 lines)
- `lib/listenable_widget.dart` — the public barrel export
- `example/lib/counter/` — reference implementation showing `CounterPage` (View) + `CounterPageViewModel` (ChangeNotifier)

### Package constraints

- Dart SDK `^3.8.1`, Flutter `>=3.27.0`
- No runtime dependencies beyond `flutter` itself; `flutter_lints` for dev
- Linting via `flutter_lints/flutter.yaml` (no custom rules)
