import 'package:flutter/widgets.dart';

abstract class ListenableWidget<T extends ChangeNotifier>
    extends StatefulWidget {
  const ListenableWidget({super.key});

  /// Creates and returns the [T] instance.
  /// This method is called once during the widget's initialization.
  T create(BuildContext context);

  /// Builds the widget tree using the provided [viewModel].
  /// This method is called whenever the [viewModel] notifies its listeners.
  Widget build(BuildContext context, T viewModel);

  /// Called when the widget is updated with a new configuration.
  /// This can be used to update the [viewModel] or perform any necessary actions.
  ///
  /// The [oldWidget] parameter contains the previous widget configuration.
  void onWidgetChanged(
    BuildContext context,
    ListenableWidget<T> oldWidget,
    T viewModel,
  ) {}

  /// Called when the widget's dependencies change.
  /// This can be used to refresh the [viewModel] or perform any necessary updates.
  void onDependenciesChanged(BuildContext context, T viewModel) {}

  /// Whether the widget should automatically dispose of the [viewModel].
  ///
  /// If `true` (the default), the [viewModel] will be disposed when the widget
  /// is removed from the widget tree. Set to `false` if you manage the
  /// [viewModel]'s lifecycle externally.
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
    widget.onWidgetChanged(context, oldWidget, viewModel);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onDependenciesChanged(context, viewModel);
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
