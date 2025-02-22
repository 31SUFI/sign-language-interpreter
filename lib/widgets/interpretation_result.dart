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
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Translation',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.translate,
                size: 20,
                color: Colors.blue[600],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: isProcessing
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue[600]!,
                      ),
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    itemCount: interpretationHistory.isEmpty
                        ? 1
                        : interpretationHistory.length,
                    itemBuilder: (context, index) {
                      if (interpretationHistory.isEmpty) {
                        return Center(
                          child: Text(
                            'No translations yet',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Card(
                          elevation: 0,
                          color: Colors.grey[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              interpretationHistory[index],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
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
