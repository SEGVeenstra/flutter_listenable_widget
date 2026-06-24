# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository layout

This is a **Melos 8 monorepo** built on Dart pub workspaces. It publishes two
packages independently to pub.dev:

- `packages/listenable_widget` — the core MVVM widget. No runtime deps beyond
  `flutter`.
- `packages/get_it_listenable_widget` — a companion that resolves the ViewModel
  from GetIt. Depends on `listenable_widget` + `get_it`.

Each package has its own `example/` (also workspace members, `publish_to: none`).
The root `pubspec.yaml` holds the `workspace:` list and the `melos:` config; it
declares SDK `^3.9.0` (Melos 8's floor — dev-only, not published). The published
packages keep `^3.8.1`.

## Commands

```bash
# Resolve the whole workspace (single root pubspec.lock)
flutter pub get

# Analyze / test everything (from repo root)
flutter analyze
dart run melos run analyze        # per-package analyze
dart run melos run test           # per-package flutter test (where test/ exists)

# Test a single package
cd packages/get_it_listenable_widget && flutter test

# Run an example
cd packages/listenable_widget/example && flutter run
cd packages/get_it_listenable_widget/example && flutter run

# Release (independent versioning, conventional commits)
dart run melos version            # bump versions + changelogs from commits
dart run melos publish --dry-run  # validate; drop --dry-run to publish
```

> **Release ordering:** `get_it_listenable_widget` depends on `listenable_widget`
> via a hosted constraint (`^0.x`), not a path/workspace ref in the published
> output. So when both change in one release, **publish `listenable_widget` first**
> — otherwise `get_it_listenable_widget` can't resolve the new version from pub.dev.
> Locally the workspace still links the two; this only matters at publish time.

## Architecture

`listenable_widget` implements MVVM on top of Flutter's built-in `ChangeNotifier`
and `ListenableBuilder`.

### How it works

`ListenableWidget<T>` is an abstract `StatefulWidget`. The ViewModel is provided
one of three ways: override **`create(context)`**, pass a **`viewModelFactory`**
constructor callback, or pass a pre-built **`viewModel`** instance. **`build(context, viewModel)`**
is called on every `notifyListeners()` to rebuild the subtree.

Two optional hooks mirror the `State` lifecycle:

- **`onWidgetChanged(context, oldWidget, viewModel)`** — maps to `didUpdateWidget`.
- **`onDependenciesChanged(context, viewModel)`** — maps to `didChangeDependencies`.

The `autoDispose` getter controls whether the ViewModel is disposed when the
widget leaves the tree. The `assignContext` getter controls whether the widget
assigns its `BuildContext` to the (nullable) `ViewModel.context`. Both default to
`true`, except `false` when a pre-built `viewModel` is supplied — a shared
ViewModel is neither disposed nor has its context overwritten by each user.

`ListenableWidgetBuilder<T>` is an inline (no-subclass) variant.

### get_it_listenable_widget

`GetItListenableWidget<VM, P1, P2>` extends `ListenableWidget<VM>` and overrides
`create()` to resolve from GetIt: `getIt.get<VM>(param1:, param2:, instanceName:)`.
The three type params mirror GetIt's factory shape. `autoDispose` defaults to
`true` (the widget owns a factory instance); pass `autoDispose: false` for shared
singletons. `GetItListenableWidgetBuilder<VM, P1, P2>` is the inline variant. The
barrel re-exports `listenable_widget` so a single import exposes `ViewModel`.

### File layout

- `packages/listenable_widget/lib/src/` — `listenable_widget.dart`,
  `listenable_widget_builder.dart`, `view_model.dart`
- `packages/get_it_listenable_widget/lib/src/` — `get_it_listenable_widget.dart`,
  `get_it_listenable_widget_builder.dart`

### Constraints

- Published packages: Dart SDK `^3.8.1`, Flutter `>=3.27.0`
- Linting via `flutter_lints/flutter.yaml` (no custom rules)
