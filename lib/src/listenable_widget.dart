import 'package:flutter/widgets.dart';

import 'view_model.dart';

/// A widget that binds to a [ViewModel] and rebuilds whenever the ViewModel
/// calls [ChangeNotifier.notifyListeners].
///
/// Extend this class and implement at least [build]. The ViewModel is either
/// created via the [viewModelFactory] constructor parameter or by overriding
/// [create].
///
/// ## Usage patterns
///
/// ### 1 — Classic: override `create`
/// The widget creates its own ViewModel. Best when the widget and ViewModel
/// are tightly coupled and live in the same package.
///
/// ```dart
/// class CounterPage extends ListenableWidget<CounterViewModel> {
///   @override
///   CounterViewModel create(BuildContext context) => CounterViewModel();
///
///   @override
///   Widget build(BuildContext context, CounterViewModel vm) =>
///       Text('${vm.count}');
/// }
/// ```
///
/// ### 2 — UI kit: pass `viewModelFactory`
/// The widget does not know how to create the ViewModel; the caller supplies
/// a factory. Ideal for UI-kit widgets that must stay data-layer-agnostic.
///
/// ```dart
/// // In the UI kit — no data-layer knowledge:
/// class CounterPage extends ListenableWidget<CounterViewModel> {
///   const CounterPage({required super.viewModelFactory, super.key});
///
///   @override
///   Widget build(BuildContext context, CounterViewModel vm) =>
///       Text('${vm.count}');
/// }
///
/// // In the app — knows the data layer:
/// CounterPage(
///   viewModelFactory: (ctx) => CounterViewModel(repo: ctx.read<CounterRepo>()),
/// )
/// ```
///
/// ### 3 — Abstract ViewModel (interface + implementation)
/// The UI kit defines an abstract ViewModel; the app provides the concrete
/// implementation; tests use a mock. All three work through the same factory
/// parameter.
///
/// ```dart
/// // UI kit: interface
/// abstract class CounterViewModel extends ViewModel {
///   int get count;
///   void increment();
/// }
///
/// // UI kit: widget
/// class CounterPage extends ListenableWidget<CounterViewModel> {
///   const CounterPage({required super.viewModelFactory, super.key});
///
///   @override
///   Widget build(BuildContext context, CounterViewModel vm) =>
///       Text('${vm.count}');
/// }
///
/// // App:
/// CounterPage(viewModelFactory: (ctx) => CounterViewModelImpl(ctx.read()))
///
/// // Test:
/// CounterPage(viewModelFactory: (_) => MockCounterViewModel())
/// ```
///
/// ### 4 — Inline: `ListenableWidgetBuilder`
/// No subclassing needed. Use [ListenableWidgetBuilder] for one-off cases.
///
/// ```dart
/// ListenableWidgetBuilder<CounterViewModel>(
///   viewModelFactory: (_) => CounterViewModel(),
///   builder: (ctx, vm) => Text('${vm.count}'),
/// )
/// ```
abstract class ListenableWidget<T extends ViewModel> extends StatefulWidget {
  /// Optional factory that creates the ViewModel. When provided, [create] uses
  /// this factory and subclasses do not need to override [create].
  final T Function(BuildContext)? viewModelFactory;

  const ListenableWidget({this.viewModelFactory, super.key});

  /// Creates and returns the [T] instance. Called once during initialization.
  ///
  /// Override this method **or** supply [viewModelFactory] to the constructor.
  /// Throws [UnimplementedError] if neither is provided.
  T create(BuildContext context) {
    if (viewModelFactory != null) return viewModelFactory!(context);
    throw UnimplementedError(
      '$runtimeType must either override create() or provide viewModelFactory.',
    );
  }

  /// Builds the widget tree using the provided [viewModel].
  /// Called whenever the [viewModel] notifies its listeners.
  Widget build(BuildContext context, T viewModel);

  /// Called when the widget is updated with a new configuration.
  /// Use this to sync widget fields into the ViewModel when the parent rebuilds.
  ///
  /// The [oldWidget] parameter contains the previous widget configuration.
  void onWidgetChanged(
    BuildContext context,
    ListenableWidget<T> oldWidget,
    T viewModel,
  ) {}

  /// Called when the widget's dependencies change (e.g. an [InheritedWidget]).
  /// Use this to update the ViewModel in response to dependency changes.
  void onDependenciesChanged(BuildContext context, T viewModel) {}

  /// Whether the widget should automatically dispose of the [viewModel].
  ///
  /// Defaults to `true`. Set to `false` when the ViewModel's lifecycle is
  /// managed externally (e.g. via a dependency injection framework).
  bool get autoDispose => true;

  @override
  State<ListenableWidget> createState() => _ListenableWidgetState<T>();
}

class _ListenableWidgetState<T extends ViewModel>
    extends State<ListenableWidget<T>> {
  late final T viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.create(context);
    viewModel.context = context;
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
