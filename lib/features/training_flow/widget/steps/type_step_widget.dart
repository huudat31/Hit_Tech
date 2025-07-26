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

class TypeStepWidget extends BaseStepWidget {
  final TrainingStepModel stepData;

  const TypeStepWidget({super.key, required this.stepData})
    : super(
        stepTitle: 'Loại hình tập luyện',
        stepDescription: 'Chọn loại hình tập luyện phù hợp với sở thích',
        currentStepKey: 'type',
        nextStepKey: 'frequency',
      );

  @override
  Widget buildStepContent(BuildContext context) {
    // Only use API data - no fallback to hardcoded options
    final availableTypes = stepData.selectedValues.type ?? [];

    // If no options from API, show loading or error
    if (availableTypes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text(
              'Đang tải các loại hình tập luyện...',
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
      );
    }

    return BlocBuilder<TrainingFlowCubit, TrainingFlowState>(
      builder: (context, state) {
        if (state is TrainingFlowLoaded) {
          final selectedType = context
              .read<TrainingFlowCubit>()
              .getUserSelection('type');
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 150.h),
            itemCount: availableTypes.length,
            itemBuilder: (context, index) {
              final type = availableTypes[index];
              final isSelected = selectedType.contains(type);

              return GestureDetector(
                onTap: () {
                  context.read<TrainingFlowCubit>().updateTemporarySelection(
                    'type',
                    [type],
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.w),
                  height: 80.h,
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
                        _getTypeAsset(type, isSelected),
                        width: 40.w,
                        height: 40.h,
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Text(
                          _getTypeTitle(type),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: isSelected
                                ? AppColors.bNormal
                                : AppColors.darkActive,
                            fontWeight: FontWeight.w700,
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

  String _getTypeAsset(String type, bool isSelected) {
    switch (type.toLowerCase()) {
      case 'yoga':
        return isSelected ? TrainingAssets.yogaSelected : TrainingAssets.yoga;
      case 'calisthenic':
      case 'calisthenics':
        return isSelected
            ? TrainingAssets.calisthenicSelected
            : TrainingAssets.calisthenic;
      case 'gym':
        return isSelected ? TrainingAssets.gymSelected : TrainingAssets.gym;
      case 'cardio':
        return isSelected
            ? TrainingAssets.cardioSelected
            : TrainingAssets.cardio;
      default:
        return TrainingAssets.yoga;
    }
  }

  String _getTypeTitle(String type) {
    switch (type.toLowerCase()) {
      case 'yoga':
        return 'Yoga';
      case 'calisthenic':
      case 'calisthenics':
        return 'Calisthenics';
      case 'gym':
        return 'Gym';
      case 'cardio':
        return 'Cardio';
      default:
        return type;
    }
  }
}
