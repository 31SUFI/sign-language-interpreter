import 'package:flutter/material.dart';

class InterpretationResult extends StatelessWidget {
  final String interpretation;
  final bool isProcessing;

  const InterpretationResult({
    super.key,
    required this.interpretation,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Interpretation',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: isProcessing
                  ? const Center(child: CircularProgressIndicator())
                  : Text(
                      interpretation.isEmpty
                          ? 'No interpretation yet'
                          : interpretation,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
