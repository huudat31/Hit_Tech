import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/training_assets.dart';
import '../../cubit/training_flow_cubit.dart';
import '../../model/training_step_model.dart';
import '../common/base_step_widget.dart';

class EquipmentStepWidget extends BaseStepWidget {
  const EquipmentStepWidget({
    super.key,
    required super.stepData,
  });

  @override
  String get stepTitle => 'Thiết bị luyện tập';

  @override
  String get stepDescription => 'Thiết bị luyện tập mà bạn có?';

  @override
  String get currentStepKey => 'equipment';

  @override
  String get nextStepKey => '';

  @override
  bool get isLastStep => true;

  @override
  Widget buildStepContent(BuildContext context) {
    final availableEquipments = stepData.selectedValues.equipment ?? [];
    
    return BlocBuilder<TrainingFlowCubit, TrainingFlowState>(
      builder: (context, state) {
        if (state is TrainingFlowLoaded) {
          final selectedEquipments = context
              .read<TrainingFlowCubit>()
              .getUserSelection('equipment');

          return ListView.builder(
            padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 200.h),
            itemCount: availableEquipments.length,
            itemBuilder: (context, index) {
              final equipment = availableEquipments[index];
              final isSelected = selectedEquipments.contains(equipment);

              return GestureDetector(
                onTap: () {
                  List<String> newSelection = List.from(selectedEquipments);
                  if (isSelected) {
                    newSelection.remove(equipment);
                  } else {
                    newSelection.add(equipment);
                  }
                  
                  context.read<TrainingFlowCubit>().updateTemporarySelection(
                    'equipment',
                    newSelection,
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
                      Expanded(
                        child: Text(
                          _getEquipmentTitle(equipment),
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

  String _getEquipmentTitle(String equipment) {
    switch (equipment.toLowerCase()) {
      case 'dumbbell':
      case 'tạ đôi':
        return 'Tạ đôi';
      case 'barbell':
      case 'tạ đơn':
        return 'Tạ đơn';
      case 'kettlebell':
        return 'Kettlebell';
      case 'resistance_band':
      case 'dây kháng lực':
        return 'Dây kháng lực';
      case 'yoga_mat':
      case 'thảm yoga':
        return 'Thảm yoga';
      case 'pull_up_bar':
      case 'xà đơn':
        return 'Xà đơn';
      case 'jump_rope':
      case 'dây nhảy':
        return 'Dây nhảy';
      case 'no_equipment':
      case 'không có thiết bị':
        return 'Không có thiết bị';
      default:
        return equipment;
    }
  }

  @override
  void onLastStepCompleted(BuildContext context) {
    // Gọi API hoàn thành training flow
    context.read<TrainingFlowCubit>().completeTrainingFlow();
  }
}
