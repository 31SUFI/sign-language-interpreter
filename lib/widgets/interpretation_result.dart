import 'package:flutter/material.dart';

class InterpretationResult extends StatelessWidget {
  final List<String> interpretationHistory;
  final bool isProcessing;

  const InterpretationResult({
    super.key,
    required this.interpretationHistory,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interpretation History',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: isProcessing
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    reverse: true,
                    itemCount: interpretationHistory.isEmpty
                        ? 1
                        : interpretationHistory.length,
                    itemBuilder: (context, index) {
                      if (interpretationHistory.isEmpty) {
                        return const Text(
                          'No interpretations yet',
                          textAlign: TextAlign.center,
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              interpretationHistory[index],
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
