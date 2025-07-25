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

class DurationStepWidget extends BaseStepWidget {
  final TrainingStepModel stepData;

  const DurationStepWidget({
    super.key,
    required this.stepData,
  }) : super(
          stepTitle: 'Thời gian luyện tập mà bạn\ndành ra trong một ngày?',
          stepDescription: 'Chọn thời gian phù hợp với lịch trình của bạn',
          currentStepKey: 'duration',
          nextStepKey: 'type',
        );

  @override
  Widget buildStepContent(BuildContext context) {
    final availableDurations = stepData.selectedValues.duration ?? [];
    
    return BlocBuilder<TrainingFlowCubit, TrainingFlowState>(
      builder: (context, state) {
        if (state is TrainingFlowLoaded) {
          final selectedDuration = context
              .read<TrainingFlowCubit>()
              .getUserSelection('duration');

          return ListView.builder(
            padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 150.h),
            itemCount: availableDurations.length,
            itemBuilder: (context, index) {
              final duration = availableDurations[index];
              final isSelected = selectedDuration.contains(duration);

              return GestureDetector(
                onTap: () {
                  context.read<TrainingFlowCubit>().updateTemporarySelection(
                    'duration',
                    [duration],
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.w),
                  height: 90.h,
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
                      SizedBox(width: 10.w),
                      Image.asset(
                        _getDurationAsset(index, isSelected),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Text(
                          _getDurationTitle(duration),
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: isSelected
                                ? AppColors.bNormal
                                : AppColors.darkActive,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          isSelected
                              ? TrainingAssets.tickActive
                              : TrainingAssets.tickNonActive,
                          width: 20.w,
                          height: 20.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10.w),
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

  String _getDurationAsset(int index, bool isSelected) {
    switch (index) {
      case 0:
        return isSelected 
            ? TrainingAssets.durationSelected1
            : TrainingAssets.duration1;
      case 1:
        return isSelected
            ? TrainingAssets.durationSelected2
            : TrainingAssets.duration2;
      case 2:
        return isSelected
            ? TrainingAssets.durationSelected3
            : TrainingAssets.duration3;
      case 3:
        return isSelected
            ? TrainingAssets.durationSelected4
            : TrainingAssets.duration4;
      default:
        return TrainingAssets.duration1;
    }
  }

  String _getDurationTitle(String duration) {
    if (duration.contains('15') || duration == "15 - 30 phút") {
      return '15 - 30 phút';
    } else if (duration.contains('30') || duration == "30 - 45 phút") {
      return '30 - 45 phút';
    } else if (duration.contains('45') || duration == "45 - 60 phút") {
      return '45 - 60 phút';
    } else if (duration.contains('60') || duration == "Trên 60 phút") {
      return 'Trên 60 phút';
    }
    return duration;
  }
}
