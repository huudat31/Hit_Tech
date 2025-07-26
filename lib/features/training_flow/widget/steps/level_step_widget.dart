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

class LevelStepWidget extends BaseStepWidget {
  final TrainingStepModel stepData;

  const LevelStepWidget({super.key, required this.stepData})
    : super(
        stepTitle: 'Mức độ kinh nghiệm\ncủa bạn là gì?',
        stepDescription: 'Chọn trình độ phù hợp với khả năng hiện tại',
        currentStepKey: 'level',
        nextStepKey: 'duration',
      );

  @override
  Widget buildStepContent(BuildContext context) {
    final availableLevels = stepData.selectedValues.level ?? [];

    // Show loading state if no options available from API
    if (availableLevels.isEmpty) {
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
          final selectedLevel = context
              .read<TrainingFlowCubit>()
              .getUserSelection('level');

          return ListView.builder(
            padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 150.h),
            itemCount: availableLevels.length,
            itemBuilder: (context, index) {
              final level = availableLevels[index];
              final isSelected = selectedLevel.contains(level);

              return GestureDetector(
                onTap: () {
                  context.read<TrainingFlowCubit>().updateTemporarySelection(
                    'level',
                    [level],
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.w),
                  height: 100.h,
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
                      SizedBox(width: 20.w),
                      Image.asset(
                        _getLevelAsset(index, isSelected),
                        width: 60.w,
                        height: 60.h,
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getLevelTitle(level),
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: AppColors.dark,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              _getLevelDescription(level),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.lightHover,
                              ),
                            ),
                          ],
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

  String _getLevelAsset(int index, bool isSelected) {
    switch (index) {
      case 0:
        return isSelected
            ? TrainingAssets.beginnerSelected
            : TrainingAssets.beginner;
      case 1:
        return isSelected
            ? TrainingAssets.intermediateSelected
            : TrainingAssets.intermediate;
      case 2:
        return isSelected
            ? TrainingAssets.advancedSelected
            : TrainingAssets.advanced;
      default:
        return TrainingAssets.beginner;
    }
  }

  String _getLevelTitle(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
      case 'mới bắt đầu':
        return 'Mới bắt đầu';
      case 'intermediate':
      case 'cơ bản':
        return 'Cơ bản';
      case 'advanced':
      case 'nâng cao':
        return 'Nâng cao';
      default:
        return level;
    }
  }

  String _getLevelDescription(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
      case 'mới bắt đầu':
        return 'Tập nhẹ, làm quen với động tác cơ bản';
      case 'intermediate':
      case 'cơ bản':
        return 'Đã có nền tảng, muốn nâng cao hiệu quả luyện tập';
      case 'advanced':
      case 'nâng cao':
        return 'Tập cường độ cao, hướng tới mục tiêu rõ ràng';
      default:
        return 'Trình độ luyện tập của bạn';
    }
  }
}
