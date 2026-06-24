import 'package:example/counter/counter_card_ui.dart';
import 'package:example/counter/simple_counter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:listenable_widget/listenable_widget.dart';

/// Variant 2 — viewModelFactory: the widget stays data-layer-agnostic.
/// The caller injects a factory via the constructor so the widget never
/// needs to import repos, services, or any other data-layer code.
class FactoryCounterCard extends ListenableWidget<SimpleCounterViewModel> {
  const FactoryCounterCard({required super.viewModelFactory, super.key});

  @override
  Widget build(BuildContext context, SimpleCounterViewModel vm) {
    return CounterCardUi(
      title: 'Variant 2 – viewModelFactory',
      description:
          'No create() override. The factory is injected via the constructor, '
          'keeping this widget completely data-layer-agnostic.',
      count: vm.count,
      onIncrement: vm.increment,
    );
  }
}
