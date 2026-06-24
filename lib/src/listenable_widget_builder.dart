import 'package:flutter/widgets.dart';

import 'listenable_widget.dart';
import 'view_model.dart';

/// A fully concrete [ListenableWidget] that accepts all behaviour via
/// constructor callbacks. Use this for inline, one-off cases where creating a
/// dedicated subclass is not worth it — similar to how Flutter's own
/// [ListenableBuilder] avoids subclassing [StatefulWidget].
///
/// ```dart
/// ListenableWidgetBuilder<CounterViewModel>(
///   viewModelFactory: (_) => CounterViewModel(),
///   builder: (ctx, vm) => Text('${vm.count}'),
/// )
/// ```
class ListenableWidgetBuilder<T extends ViewModel> extends ListenableWidget<T> {
  final Widget Function(BuildContext, T) builder;
  final void Function(BuildContext, ListenableWidget<T>, T)?
      onWidgetChangedCallback;
  final void Function(BuildContext, T)? onDependenciesChangedCallback;
  final bool _autoDispose;

  const ListenableWidgetBuilder({
    required T Function(BuildContext) viewModelFactory,
    required this.builder,
    this.onWidgetChangedCallback,
    this.onDependenciesChangedCallback,
    bool autoDispose = true,
    super.key,
  })  : _autoDispose = autoDispose,
        super(viewModelFactory: viewModelFactory);

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

  @override
  bool get autoDispose => _autoDispose;
}
