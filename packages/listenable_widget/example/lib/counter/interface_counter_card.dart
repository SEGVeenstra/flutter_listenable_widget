import 'package:example/counter/abstract_counter_view_model.dart';
import 'package:example/counter/counter_card_ui.dart';
import 'package:flutter/material.dart';
import 'package:listenable_widget/listenable_widget.dart';

/// Variant 3 — Abstract ViewModel: the widget depends only on the abstract
/// [AbstractCounterViewModel] interface. Swap [ConcreteCounterViewModel] for
/// a hand-written mock in tests — no mocking framework needed.
class InterfaceCounterCard extends ListenableWidget<AbstractCounterViewModel> {
  const InterfaceCounterCard({required super.viewModelFactory, super.key});

  @override
  Widget build(BuildContext context, AbstractCounterViewModel vm) {
    return CounterCardUi(
      title: 'Variant 3 – Abstract ViewModel',
      description:
          'Widget depends only on the abstract interface. The app provides '
          'ConcreteCounterViewModel; tests can pass a hand-written mock.',
      count: vm.count,
      onIncrement: vm.increment,
    );
  }
}
