import 'package:example/counter/abstract_counter_view_model.dart';
import 'package:example/counter/classic_counter_card.dart';
import 'package:example/counter/counter_card_ui.dart';
import 'package:example/counter/factory_counter_card.dart';
import 'package:example/counter/interface_counter_card.dart';
import 'package:example/counter/simple_counter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:listenable_widget/listenable_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        ],
      ),
    );
  }
}
