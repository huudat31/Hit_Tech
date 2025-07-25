import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cubit/training_flow_cubit.dart';
import '../../cubit/training_flow_state.dart';
import 'progress_indicator_widget.dart';
import 'step_header_widget.dart';

abstract class BaseStepWidget extends StatelessWidget {
  final String stepTitle;
  final String stepDescription;
  final String currentStepKey;
  final String nextStepKey;
  final bool allowMultipleSelection;
  final bool isLastStep;

  const BaseStepWidget({
    super.key,
    required this.stepTitle,
    required this.stepDescription,
    required this.currentStepKey,
    required this.nextStepKey,
    this.allowMultipleSelection = false,
    this.isLastStep = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            StepHeaderWidget(
              currentStep: currentStepKey,
              onBackPressed: () => _handleBackPress(context),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                child: Column(
                  children: [
                    _buildStepInfo(),
                    Expanded(child: buildStepContent(context)),
                    _buildActionButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepInfo() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stepTitle,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            stepDescription,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return BlocBuilder<TrainingFlowCubit, TrainingFlowState>(
      builder: (context, state) {
        final isEnabled = _isButtonEnabled(context, state);
        
        return Container(
          padding: EdgeInsets.all(24.w),
          child: SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: isEnabled ? () => _handleButtonPress(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: Text(
                _getButtonText(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isEnabled ? Colors.white : Colors.grey[600],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isButtonEnabled(BuildContext context, TrainingFlowState state) {
    if (state is TrainingFlowLoaded) {
      final currentSelections = context
          .read<TrainingFlowCubit>()
          .getUserSelection(currentStepKey);
      return currentSelections.isNotEmpty;
    }
    return false;
  }

  void _handleButtonPress(BuildContext context) {
    final cubit = context.read<TrainingFlowCubit>();
    final currentSelections = cubit.getUserSelection(currentStepKey);
    
    if (isLastStep) {
      _handleLastStep(context, cubit, currentSelections);
    } else {
      cubit.selectAndProceed(
        currentStep: currentStepKey,
        selectedValues: currentSelections,
        nextStep: nextStepKey.isNotEmpty ? nextStepKey : null,
      );
    }
  }

  void _handleLastStep(BuildContext context, TrainingFlowCubit cubit, List<String> selections) {
    // Save final selection first
    cubit.selectAndProceed(
      currentStep: currentStepKey,
      selectedValues: selections,
    );
    
    // Then call completion callback which will trigger API call
    onLastStepCompleted(context);
  }

  void _handleBackPress(BuildContext context) {
    Navigator.of(context).pop();
  }

  String _getButtonText() {
    return isLastStep ? 'Hoàn thành' : 'Tiếp tục';
  }

  // Abstract methods to be implemented by concrete step widgets
  Widget buildStepContent(BuildContext context);
  
  // Optional method for last step completion handling
  void onLastStepCompleted(BuildContext context) {
    // Default implementation - can be overridden
  }
}
