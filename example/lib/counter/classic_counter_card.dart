import 'package:example/counter/counter_card_ui.dart';
import 'package:example/counter/counter_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:listenable_widget/listenable_widget.dart';

/// Variant 1 — Classic: the widget overrides [create] and manages the full
/// ViewModel lifecycle itself. The widget and ViewModel are tightly coupled
/// and live in the same package.
class ClassicCounterCard extends ListenableWidget<CounterPageViewModel> {
  const ClassicCounterCard({super.key});

  @override
  CounterPageViewModel create(BuildContext context) =>
      CounterPageViewModel(incrementValue: 1);

  @override
  Widget build(BuildContext context, CounterPageViewModel vm) {
    return CounterCardUi(
      title: 'Variant 1 – Classic',
      description:
          'Widget overrides create(). Self-contained: the widget owns '
          'the full ViewModel lifecycle. Reach ±10 to see the ViewModel '
          'use its BuildContext via a SnackBar.',
      count: vm.count,
      onIncrement: vm.incrementCounter,
    );
  }
}
