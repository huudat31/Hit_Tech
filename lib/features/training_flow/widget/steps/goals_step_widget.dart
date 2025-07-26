import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cubit/training_flow_cubit.dart';
import '../../cubit/training_flow_state.dart';
import '../../model/training_step_model.dart';
import '../common/base_step_widget.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/app_dimension.dart';

class GoalsStepWidget extends BaseStepWidget {
  final TrainingStepModel stepData;

  const GoalsStepWidget({super.key, required this.stepData})
    : super(
        stepTitle: 'Mục tiêu luyện tập\ncủa bạn là gì?',
        stepDescription: 'Chọn mục tiêu phù hợp với bạn',
        currentStepKey: 'goals',
        nextStepKey: 'level',
      );

  @override
  Widget buildStepContent(BuildContext context) {
    final availableGoals = stepData.selectedValues.goals ?? [];

    // Show loading state if no options available from API
    if (availableGoals.isEmpty) {
      return Center(
        child: Text(
          'Đang tải...',
          style: TextStyle(fontSize: 16.sp, color: AppColors.lightHover),
        ),
      );
    }

    return BlocBuilder<TrainingFlowCubit, TrainingFlowState>(
      builder: (context, state) {
        if (state is TrainingFlowLoaded) {
          final selectedGoals = context
              .read<TrainingFlowCubit>()
              .getUserSelection('goals');

          return ListView.builder(
            padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 150.h),
            itemCount: availableGoals.length,
            itemBuilder: (context, index) {
              final goal = availableGoals[index];
              final isSelected = selectedGoals.contains(goal);

              return GestureDetector(
                onTap: () {
                  context.read<TrainingFlowCubit>().updateTemporarySelection(
                    'goals',
                    [goal],
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.w),
                  height: 110.h,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.bLightHover
                        : AppColors.wWhite,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusSmall,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.bNormal
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getGoalTitle(goal),
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: isSelected
                                ? AppColors.bNormal
                                : AppColors.darkActive,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          TrainingAssets.goalDemo,
                          width: 90.w,
                          height: 90.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  String _getGoalTitle(String goal) {
    switch (goal.toLowerCase()) {
      case 'lose weight':
      case 'giảm cân':
        return 'Giảm cân / Giảm mỡ';
      case 'gain weight':
      case 'tăng cân':
        return 'Tăng cân';
      case 'build muscle':
      case 'tăng cơ':
        return 'Tăng cơ';
      case 'maintain':
      case 'duy trì':
        return 'Duy trì vóc dáng';
      case 'endurance':
      case 'sức bền':
        return 'Tăng sức bền';
      case 'cardio':
      case 'tim mạch':
        return 'Cải thiện tim mạch';
      case 'stress':
      case 'thư giãn':
        return 'Giảm stress, thư giãn';
      case 'height':
      case 'chiều cao':
        return 'Tăng chiều cao';
      default:
        return goal;
    }
  }
}
