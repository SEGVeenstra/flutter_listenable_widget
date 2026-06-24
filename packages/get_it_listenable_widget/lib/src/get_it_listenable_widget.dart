import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:listenable_widget/listenable_widget.dart';

/// A [ListenableWidget] whose [ViewModel] is resolved from GetIt instead of
/// being created by an overridden `create` or passed via `viewModelFactory`.
///
/// The three type parameters mirror GetIt's factory shape:
/// - [VM] — the ViewModel type to resolve (`getIt.get<VM>()`).
/// - [P1] / [P2] — the optional `param1` / `param2` factory parameters. Use
///   `void` for unused slots, e.g. `GetItListenableWidget<MyVm, void, void>`.
///
/// Extend this class and implement [build]. The ViewModel is resolved once
/// during initialization via `getIt.get<VM>(param1:, param2:, instanceName:)`.
///
/// ```dart
/// // Registered with: getIt.registerFactoryParam<CounterViewModel, int, void>(
/// //   (initial, _) => CounterViewModel(initial),
/// // );
/// class CounterPage extends GetItListenableWidget<CounterViewModel, int, void> {
///   const CounterPage({required int initial, super.key})
///       : super(param1: initial);
///
///   @override
///   Widget build(BuildContext context, CounterViewModel vm) =>
///       Text('${vm.count}');
/// }
/// ```
///
/// ## Lifecycle
///
/// [autoDispose] defaults to `true`: the widget disposes the ViewModel when it
/// leaves the tree. This is correct for `registerFactoryParam` /
/// `registerFactory`, where each lookup yields a fresh instance the widget owns.
///
/// When resolving a **shared** instance (`registerSingleton` /
/// `registerLazySingleton`), pass `autoDispose: false` so the widget never
/// disposes an instance owned by GetIt.
abstract class GetItListenableWidget<VM extends ViewModel, P1, P2>
    extends ListenableWidget<VM> {
  /// Passed as `param1` to `getIt.get<VM>()`.
  final P1? param1;

  /// Passed as `param2` to `getIt.get<VM>()`.
  final P2? param2;

  /// The named registration to resolve, when multiple instances of [VM] are
  /// registered. Passed as `instanceName` to `getIt.get<VM>()`.
  final String? instanceName;

  /// The GetIt instance to resolve from. Defaults to [GetIt.instance].
  final GetIt? getIt;

  final bool _autoDispose;

  final bool? _assignContext;

  const GetItListenableWidget({
    this.param1,
    this.param2,
    this.instanceName,
    this.getIt,
    bool autoDispose = true,
    bool? assignContext,
    super.key,
  })  : _autoDispose = autoDispose,
        _assignContext = assignContext;

  @override
  VM create(BuildContext context) => (getIt ?? GetIt.instance).get<VM>(
        param1: param1,
        param2: param2,
        instanceName: instanceName,
      );

  /// Whether the widget disposes the resolved ViewModel when it leaves the tree.
  ///
  /// Defaults to `true` (the widget owns the instance — correct for factory
  /// registrations). Pass `autoDispose: false` for shared singletons.
  @override
  bool get autoDispose => _autoDispose;

  /// Whether the widget assigns its [BuildContext] to [ViewModel.context].
  ///
  /// Because GetIt resolves the ViewModel inside [create] (not via the base
  /// `viewModel` parameter), the default tracks [autoDispose]: a widget-owned
  /// factory instance gets its context assigned, while a shared singleton
  /// (`autoDispose: false`) does not — avoiding clobbering the context of
  /// another widget using the same instance. Pass `assignContext` to override.
  @override
  bool get assignContext => _assignContext ?? _autoDispose;
}
