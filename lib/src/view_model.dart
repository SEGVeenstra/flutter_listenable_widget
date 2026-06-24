import 'package:flutter/widgets.dart';

abstract class ViewModel extends ChangeNotifier {
  /// The [BuildContext] associated with the widget that created this ViewModel.
  /// Set automatically by [ListenableWidget] during initialization.
  /// Only valid while the widget is mounted; check [isDisposed] before use.
  late BuildContext context;

  bool _isDisposed = false;

  /// Whether [dispose] has been called on this ViewModel.
  bool get isDisposed => _isDisposed;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
