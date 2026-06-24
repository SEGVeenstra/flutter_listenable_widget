## 0.1.0

- Initial release.
- `GetItListenableWidget<VM, P1, P2>` — a `ListenableWidget` that resolves its
  ViewModel from GetIt, forwarding `param1` / `param2` / `instanceName` and
  supporting a custom `GetIt` instance.
- `GetItListenableWidgetBuilder<VM, P1, P2>` — inline builder variant.
- `autoDispose` defaults to `true` (widget owns the ViewModel); pass `false`
  for shared singletons.
- `assignContext` controls whether the widget assigns its `BuildContext` to
  `ViewModel.context`. Defaults to `autoDispose`, so shared singletons do not
  have their context overwritten; pass it explicitly to override.
