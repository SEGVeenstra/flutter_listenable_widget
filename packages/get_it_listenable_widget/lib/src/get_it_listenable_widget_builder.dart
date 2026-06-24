import 'package:flutter/widgets.dart';
import 'package:listenable_widget/listenable_widget.dart';

import 'get_it_listenable_widget.dart';

/// An inline [GetItListenableWidget] that takes its [builder] via the
/// constructor, so no subclass is needed for one-off cases — the GetIt
/// counterpart of `ListenableWidgetBuilder`.
///
/// ```dart
/// GetItListenableWidgetBuilder<CounterViewModel, int, void>(
///   param1: 10,
///   builder: (ctx, vm) => Text('${vm.count}'),
/// )
/// ```
///
/// See [GetItListenableWidget] for the type-parameter and [autoDispose]
/// semantics (defaults to `true`; pass `autoDispose: false` for singletons).
class GetItListenableWidgetBuilder<VM extends ViewModel, P1, P2>
    extends GetItListenableWidget<VM, P1, P2> {
  final Widget Function(BuildContext context, VM viewModel) builder;

  const GetItListenableWidgetBuilder({
    required this.builder,
    super.param1,
    super.param2,
    super.instanceName,
    super.getIt,
    super.autoDispose,
    super.assignContext,
    super.key,
  });

  @override
  Widget build(BuildContext context, VM viewModel) => builder(context, viewModel);
}
