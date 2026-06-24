import 'package:flutter/material.dart';

/// Shared card layout used by all counter variant widgets.
class CounterCardUi extends StatelessWidget {
  final String title;
  final String description;
  final int count;
  final VoidCallback onIncrement;

  const CounterCardUi({
    required this.title,
    required this.description,
    required this.count,
    required this.onIncrement,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Count: $count',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                FilledButton.icon(
                  onPressed: onIncrement,
                  icon: const Icon(Icons.add),
                  label: const Text('Increment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
