import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'progress_indicator_widget.dart';

class StepHeaderWidget extends StatelessWidget {
  final String currentStep;
  final VoidCallback onBackPressed;

  const StepHeaderWidget({
    super.key,
    required this.currentStep,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackPressed,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24.r,
            ),
          ),
          Expanded(
            child: TrainingProgressIndicator(currentStep: currentStep),
          ),
        ],
      ),
    );
  }
}
