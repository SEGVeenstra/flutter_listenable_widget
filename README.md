# listenable_widget monorepo

A small MVVM construction set for Flutter, built on the framework's own
`ChangeNotifier` and `ListenableBuilder` — no codegen, no new state-management
runtime. This repository is a [Melos](https://melos.invertase.dev) / Dart
pub-workspace monorepo containing two independently published packages.

## Packages

| Package | pub.dev | Description |
| --- | --- | --- |
| [`listenable_widget`](packages/listenable_widget) | [![pub](https://img.shields.io/pub/v/listenable_widget.svg)](https://pub.dev/packages/listenable_widget) | The core `ListenableWidget` / `ViewModel` MVVM widgets. No runtime deps beyond `flutter`. |
| [`get_it_listenable_widget`](packages/get_it_listenable_widget) | [![pub](https://img.shields.io/pub/v/get_it_listenable_widget.svg)](https://pub.dev/packages/get_it_listenable_widget) | A `ListenableWidget` that resolves its ViewModel from [GetIt](https://pub.dev/packages/get_it). Depends on `listenable_widget` + `get_it`. |

Use `listenable_widget` on its own; reach for `get_it_listenable_widget` when you
already wire your ViewModels through GetIt/Injectable and want them resolved for
you. See each package's README for full usage.

## Quick taste

```dart
class CounterPage extends ListenableWidget<CounterViewModel> {
  @override
  CounterViewModel create(BuildContext context) => CounterViewModel();

  @override
  Widget build(BuildContext context, CounterViewModel vm) =>
      TextButton(onPressed: vm.increment, child: Text('${vm.count}'));
}
```

## Development

This repo uses Dart pub workspaces; one `flutter pub get` at the root links every
package and example.

```bash
flutter pub get                    # resolve the whole workspace
flutter analyze                    # analyze everything
dart run melos run test            # per-package tests (where test/ exists)

# Run an example
cd packages/listenable_widget/example && flutter run
cd packages/get_it_listenable_widget/example && flutter run

# Release (independent versioning, conventional commits)
dart run melos version
dart run melos publish --dry-run   # drop --dry-run to publish
```

> **Release ordering:** `get_it_listenable_widget` depends on `listenable_widget`
> via a hosted constraint, so when both change in one release, publish
> `listenable_widget` first.

See [`CLAUDE.md`](CLAUDE.md) for the full architecture and contributor notes.

## License

See [LICENSE](LICENSE).
