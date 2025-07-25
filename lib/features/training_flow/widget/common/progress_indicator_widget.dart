import 'package:flutter/material.dart';

class TrainingProgressIndicator extends StatelessWidget {
  final String currentStep;

  const TrainingProgressIndicator({
    super.key,
    required this.currentStep,
  });

  static const List<String> _steps = [
    'goals',
    'level', 
    'duration',
    'type',
    'frequency',
    'location',
    'equipment'
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = _steps.indexWhere((step) => step == currentStep);
    final progress = currentIndex >= 0 ? (currentIndex + 1) / _steps.length : 0.0;

    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.white.withOpacity(0.3),
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
    );
  }
}
