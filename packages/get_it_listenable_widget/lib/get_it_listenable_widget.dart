/// A [ListenableWidget] that resolves its ViewModel from GetIt.
///
/// Re-exports `listenable_widget` so a single import gives you `ViewModel`,
/// `ListenableWidget`, and the GetIt-aware widgets.
library;

export 'package:listenable_widget/listenable_widget.dart';

export 'src/get_it_listenable_widget.dart';
export 'src/get_it_listenable_widget_builder.dart';
