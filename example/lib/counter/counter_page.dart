import 'dart:async';

import 'package:example/counter/counter_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:listenable_widget/listenable_widget.dart';

class CounterPage extends ListenableWidget<CounterPageViewModel> {
  const CounterPage({super.key, required this.incrementValue});

  final int incrementValue;

  @override
  CounterPageViewModel create(BuildContext context) {
    // Here we create the ViewModel for this Widget.
    // It will only be called once when the widget is created.
    return CounterPageViewModel(incrementValue: incrementValue);
  }

  @override
  FutureOr<void> update(_, _, CounterPageViewModel viewModel) {
    // This method is called whenever the widget is updated.
    // So when a field on the Widget is updated, you should use this method to update the ViewModel.
    viewModel.setIncrementValue(incrementValue);
  }

  @override
  // This can be set to false if you don't want the ViewModel to be disposed when the widget is disposed.
  // This could be useful if the ViewModel is create globally, or provided by a dependency injection framework.
  final autoDispose = true;

  @override
  Widget build(BuildContext context, CounterPageViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Counter Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              // Here we use the ViewModel to get the current count.
              '${viewModel.count}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Here we use the ViewModel to increment the counter.
        // We basically bind the button to the ViewModel's method.
        onPressed: viewModel.incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
