import 'package:flutter/widgets.dart';

abstract class ViewModel extends ChangeNotifier {
  /// The [BuildContext] of the widget that created this ViewModel, or `null`
  /// when no widget assigned one.
  ///
  /// Assigned automatically by [ListenableWidget] during initialization, unless
  /// the widget opts out via `assignContext` — which it does by default for a
  /// shared ViewModel, so each widget using it does not clobber the context set
  /// by another. Only valid while the assigning widget is mounted; check
  /// [isDisposed] before use.
  BuildContext? context;

  bool _isDisposed = false;

  /// Whether [dispose] has been called on this ViewModel.
  bool get isDisposed => _isDisposed;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
