import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/features/training_flow/cubit/training_flow_state.dart';

import '../../cubit/training_flow_cubit.dart';
import '../../model/training_step_model.dart';
import '../common/base_step_widget.dart';

class FrequencyStepWidget extends BaseStepWidget {
  final TrainingStepModel stepData;

  const FrequencyStepWidget({super.key, required this.stepData})
    : super(
        stepTitle: 'Tần suất tập luyện',
        stepDescription: 'Bạn thường tập luyện bao nhiêu ngày trong tuần?',
        currentStepKey: 'frequency',
        nextStepKey: 'location',
      );

  @override
  Widget buildStepContent(BuildContext context) {
    // Only use API data - no fallback to hardcoded options
    final availableFrequencies = stepData.selectedValues.frequency ?? [];

    // If no options from API, show loading or error
    if (availableFrequencies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text(
              'Đang tải tần suất tập luyện...',
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<TrainingFlowCubit, TrainingFlowState>(
      builder: (context, state) {
        if (state is TrainingFlowLoaded) {
          final selectedFrequency = context
              .read<TrainingFlowCubit>()
              .getUserSelection('frequency');

          int selectedIndex = selectedFrequency.isNotEmpty
              ? availableFrequencies.indexOf(selectedFrequency.first)
              : 0;

          if (selectedIndex == -1) selectedIndex = 0;

          return Column(
            children: [
              SizedBox(height: 70.h),

              // Main frequency image
              Image.asset(
                _getFrequencyImage(selectedIndex),
                width: 120.w,
                height: 120.h,
              ),
              SizedBox(height: 25.h),

              // Frequency text
              Text(
                _getFrequencyText(selectedIndex),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dark,
                ),
              ),
              SizedBox(height: 20.h),

              // Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  _getFrequencyDescription(selectedIndex),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp, color: AppColors.dark),
                ),
              ),
              SizedBox(height: 62.h),

              // Progress Dots
              Container(
                height: 30.h,
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[100],
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusLarge,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(availableFrequencies.length, (index) {
                    bool isSelected = index == selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        context
                            .read<TrainingFlowCubit>()
                            .updateTemporarySelection('frequency', [
                              availableFrequencies[index],
                            ]);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isSelected ? 24.w : 16.w,
                        height: isSelected ? 24.h : 16.h,
                        decoration: BoxDecoration(
                          color: AppColors.bNormal,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 5)
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  ),
                                ]
                              : [],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  String _getFrequencyImage(int index) {
    switch (index) {
      case 0:
        return TrainingAssets.frequency1;
      case 1:
        return TrainingAssets.frequency2;
      case 2:
        return TrainingAssets.frequency3;
      case 3:
        return TrainingAssets.frequency4;
      case 4:
        return TrainingAssets.frequency5;
      default:
        return TrainingAssets.frequency1;
    }
  }

  String _getFrequencyText(int index) {
    switch (index) {
      case 0:
        return '1 buổi / tuần';
      case 1:
        return '2-3 buổi / tuần';
      case 2:
        return '4-5 buổi / tuần';
      case 3:
        return '6 buổi / tuần';
      case 4:
        return '7 buổi / tuần';
      default:
        return '1 buổi / tuần';
    }
  }

  String _getFrequencyDescription(int index) {
    switch (index) {
      case 0:
        return 'Phù hợp cho người mới bắt đầu hoặc có lịch trình bận rộn';
      case 1:
        return 'Lý tưởng để duy trì sức khỏe và xây dựng thói quen tập luyện';
      case 2:
        return 'Tốt cho việc cải thiện thể lực và đạt kết quả rõ rệt';
      case 3:
        return 'Chế độ tập luyện chuyên nghiệp, cần có kinh nghiệm';
      case 4:
        return 'Dành cho vận động viên hoặc người có mục tiêu cao';
      default:
        return 'Chọn tần suất phù hợp với lịch trình của bạn';
    }
  }
}
