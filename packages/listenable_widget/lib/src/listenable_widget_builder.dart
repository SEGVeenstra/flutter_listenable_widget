import 'package:flutter/widgets.dart';

import 'listenable_widget.dart';
import 'view_model.dart';

/// A fully concrete [ListenableWidget] that accepts all behaviour via
/// constructor callbacks. Use this for inline, one-off cases where creating a
/// dedicated subclass is not worth it — similar to how Flutter's own
/// [ListenableBuilder] avoids subclassing [StatefulWidget].
///
/// Provide the ViewModel via [viewModelFactory] (creates a new instance) or
/// [viewModel] (reuses an existing instance, [autoDispose] defaults to `false`).
///
/// ```dart
/// // Factory — widget owns the lifecycle:
/// ListenableWidgetBuilder<CounterViewModel>(
///   viewModelFactory: (_) => CounterViewModel(),
///   builder: (ctx, vm) => Text('${vm.count}'),
/// )
///
/// // Pre-built instance — caller owns the lifecycle:
/// ListenableWidgetBuilder<CounterViewModel>(
///   viewModel: sharedVm,
///   builder: (ctx, vm) => Text('${vm.count}'),
/// )
/// ```
class ListenableWidgetBuilder<T extends ViewModel> extends ListenableWidget<T> {
  final Widget Function(BuildContext, T) builder;
  final void Function(BuildContext, ListenableWidget<T>, T)?
      onWidgetChangedCallback;
  final void Function(BuildContext, T)? onDependenciesChangedCallback;
  final bool? _autoDispose;
  final bool? _assignContext;

  const ListenableWidgetBuilder({
    super.viewModelFactory,
    super.viewModel,
    required this.builder,
    this.onWidgetChangedCallback,
    this.onDependenciesChangedCallback,
    bool? autoDispose,
    bool? assignContext,
    super.key,
  })  : assert(
          viewModelFactory != null || viewModel != null,
          'ListenableWidgetBuilder requires viewModelFactory or viewModel.',
        ),
        _autoDispose = autoDispose,
        _assignContext = assignContext;

  @override
  Widget build(BuildContext context, T viewModel) => builder(context, viewModel);

  @override
  void onWidgetChanged(
    BuildContext context,
    ListenableWidget<T> oldWidget,
    T viewModel,
  ) =>
      onWidgetChangedCallback?.call(context, oldWidget, viewModel);

  @override
  void onDependenciesChanged(BuildContext context, T viewModel) =>
      onDependenciesChangedCallback?.call(context, viewModel);

  /// Falls back to [ListenableWidget.autoDispose] when not explicitly set.
  /// That default is `false` when [viewModel] is provided, `true` otherwise.
  @override
  bool get autoDispose => _autoDispose ?? super.autoDispose;

  /// Falls back to [ListenableWidget.assignContext] when not explicitly set.
  /// That default is `false` when [viewModel] is provided, `true` otherwise.
  @override
  bool get assignContext => _assignContext ?? super.assignContext;
}
