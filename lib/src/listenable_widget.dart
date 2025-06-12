import 'dart:async';

import 'package:flutter/widgets.dart';

abstract class ListenableWidget<T extends ChangeNotifier>
    extends StatefulWidget {
  const ListenableWidget({super.key});

  /// Used to create the [ViewModel] instance.
  T create(BuildContext context);

  /// Builds the widget tree using the provided [viewModel].
  Widget build(BuildContext context, T viewModel);

  /// Called when the widget is updated. This can be used to refresh the
  /// [viewModel] or perform any necessary updates.
  FutureOr<void> update(
    BuildContext context,
    ListenableWidget<T> oldWidget,
    T viewModel,
  ) async {}

  /// Whether the widget should automatically dispose of the [viewModel].
  /// If true, the [viewModel] will be disposed when the widget is removed
  /// from the widget tree.
  bool get autoDispose => true;

  @override
  State<ListenableWidget> createState() => _ListenableWidgetState<T>();
}

class _ListenableWidgetState<T extends ChangeNotifier>
    extends State<ListenableWidget<T>> {
  late final T viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.create(context);
  }

  @override
  void didUpdateWidget(covariant ListenableWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.update(context, oldWidget, viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return widget.build(context, viewModel);
      },
    );
  }

  @override
  void dispose() {
    if (widget.autoDispose) viewModel.dispose();
    super.dispose();
  }
}
