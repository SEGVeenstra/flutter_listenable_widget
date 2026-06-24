import 'package:example/counter/abstract_counter_view_model.dart';
import 'package:example/counter/classic_counter_card.dart';
import 'package:example/counter/counter_card_ui.dart';
import 'package:example/counter/factory_counter_card.dart';
import 'package:example/counter/interface_counter_card.dart';
import 'package:example/counter/simple_counter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:listenable_widget/listenable_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // A single ViewModel instance shared between two widgets (variant C).
  // Lifecycle is managed here, so autoDispose is false on both widgets.
  late final SimpleCounterViewModel _sharedViewModel;

  @override
  void initState() {
    super.initState();
    _sharedViewModel = SimpleCounterViewModel();
  }

  @override
  void dispose() {
    _sharedViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ListenableWidget – All variants'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Variant 1 — Classic: widget overrides create()
          const ClassicCounterCard(),

          // Variant 2 — viewModelFactory injected via constructor
          FactoryCounterCard(
            viewModelFactory: (_) => SimpleCounterViewModel(),
          ),

          // Variant 3 — Abstract ViewModel interface + concrete implementation
          InterfaceCounterCard(
            viewModelFactory: (_) => ConcreteCounterViewModel(),
          ),

          // Variant 4 — ListenableWidgetBuilder: no subclassing at all
          ListenableWidgetBuilder<SimpleCounterViewModel>(
            viewModelFactory: (_) => SimpleCounterViewModel(),
            builder: (ctx, vm) => CounterCardUi(
              title: 'Variant 4 – ListenableWidgetBuilder',
              description:
                  'No subclass needed. All behaviour is passed as constructor '
                  'callbacks, similar to Flutter\'s own ListenableBuilder.',
              count: vm.count,
              onIncrement: vm.increment,
            ),
          ),

          const _SectionDivider('Variant C – Pre-built instance (shared lifecycle)'),

          // Variant C — two widgets share the same ViewModel instance.
          // Incrementing either card updates both because they listen to the
          // same ChangeNotifier. autoDispose is false automatically.
          ListenableWidgetBuilder<SimpleCounterViewModel>(
            viewModel: _sharedViewModel,
            builder: (ctx, vm) => CounterCardUi(
              title: 'Shared counter – widget A',
              description:
                  'Pre-built ViewModel passed via viewModel. autoDispose is '
                  'false automatically; the parent owns the lifecycle.',
              count: vm.count,
              onIncrement: vm.increment,
            ),
          ),

          ListenableWidgetBuilder<SimpleCounterViewModel>(
            viewModel: _sharedViewModel,
            builder: (ctx, vm) => CounterCardUi(
              title: 'Shared counter – widget B',
              description:
                  'Same ViewModel instance as widget A. Increment either card '
                  'and both update in sync.',
              count: vm.count,
              onIncrement: vm.increment,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final String label;

  const _SectionDivider(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
