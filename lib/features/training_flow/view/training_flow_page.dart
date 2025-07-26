import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/training_flow_cubit.dart';
import '../cubit/training_flow_state.dart';
import '../service/training_flow_service.dart';
import '../widget/steps/goals_step_widget.dart';
import '../widget/steps/level_step_widget.dart';
import '../widget/steps/duration_step_widget.dart';
import '../widget/steps/type_step_widget.dart';
import '../widget/steps/frequency_step_widget.dart';
import '../widget/steps/location_step_widget.dart';
import '../widget/steps/equipment_step_widget.dart';

class TrainingFlowPage extends StatelessWidget {
  const TrainingFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrainingFlowCubit(
        null, // trainingFlowRepo parameter
        trainingFlowService: TrainingFlowService(),
      )..initializeTrainingFlow(),
      child: const TrainingFlowView(),
    );
  }
}

class TrainingFlowView extends StatelessWidget {
  const TrainingFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TrainingFlowCubit, TrainingFlowState>(
        listener: (context, state) {
          if (state is TrainingFlowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is TrainingFlowCompleted) {
            // Navigate to home when training flow is completed
            _navigateToHome(context);
          }
        },
        builder: (context, state) {
          if (state is TrainingFlowLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TrainingFlowLoaded) {
            return _buildStepContent(context, state);
          }

          if (state is TrainingFlowError) {
            return _buildErrorWidget(context, state);
          }

          if (state is TrainingFlowCompleted) {
            return _buildCompletionWidget(context, state);
          }

          return const Center(child: Text('Initializing training flow...'));
        },
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, TrainingFlowLoaded state) {
    final stepData = state.stepData;

    switch (stepData.currentStep) {
      case 'goals':
        return GoalsStepWidget(stepData: stepData);
      case 'level':
        return LevelStepWidget(stepData: stepData);
      case 'duration':
        return DurationStepWidget(stepData: stepData);
      case 'type':
        return TypeStepWidget(stepData: stepData);
      case 'frequency':
        return FrequencyStepWidget(stepData: stepData);
      case 'location':
        return LocationStepWidget(stepData: stepData);
      case 'equipment':
        return EquipmentStepWidget(
          stepData: stepData,
          stepTitle: 'Thiết bị luyện tập',
          stepDescription: 'Thiết bị luyện tập mà bạn có?',
          currentStepKey: 'equipment',
          nextStepKey: '',
        );
      default:
        return Center(child: Text('Unknown step: ${stepData.currentStep}'));
    }
  }

  Widget _buildErrorWidget(BuildContext context, TrainingFlowError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.r, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            'Đã có lỗi xảy ra',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              context.read<TrainingFlowCubit>().initializeTrainingFlow();
            },
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    // Replace current screen with home screen
    Navigator.of(context).pushReplacementNamed('/home');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Thiết lập thành công! Chào mừng bạn đến với chương trình tập luyện.',
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildCompletionWidget(
    BuildContext context,
    TrainingFlowCompleted state,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 80.r, color: Colors.green),
          SizedBox(height: 24.h),
          Text(
            'Hoàn thành!',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Đang chuyển đến trang chủ...',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 32.h),
          CircularProgressIndicator(color: Colors.green),
        ],
      ),
    );
  }
}
