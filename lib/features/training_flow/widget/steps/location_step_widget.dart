import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/training_assets.dart';
import '../../cubit/training_flow_cubit.dart';
import '../../model/training_step_model.dart';
import '../common/base_step_widget.dart';

class LocationStepWidget extends BaseStepWidget {
  const LocationStepWidget({
    super.key,
    required super.stepData,
  });

  @override
  String get stepTitle => 'Địa điểm tập luyện';

  @override
  String get stepDescription => 'Địa điểm luyện tập mà bạn ưa thích?';

  @override
  String get currentStepKey => 'location';

  @override
  String get nextStepKey => 'equipment';

  @override
  Widget buildStepContent(BuildContext context) {
    final availableLocations = stepData.selectedValues.location ?? [];
    
    return BlocBuilder<TrainingFlowCubit, TrainingFlowState>(
      builder: (context, state) {
        if (state is TrainingFlowLoaded) {
          final selectedLocations = context
              .read<TrainingFlowCubit>()
              .getUserSelection('location');

          return ListView.builder(
            padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 150.h),
            itemCount: availableLocations.length,
            itemBuilder: (context, index) {
              final location = availableLocations[index];
              final isSelected = selectedLocations.contains(location);

              return GestureDetector(
                onTap: () {
                  List<String> newSelection = List.from(selectedLocations);
                  if (isSelected) {
                    newSelection.remove(location);
                  } else {
                    newSelection.add(location);
                  }
                  
                  context.read<TrainingFlowCubit>().updateTemporarySelection(
                    'location',
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
                      Image.asset(
                        _getLocationAsset(location, isSelected),
                        width: 40.w,
                        height: 40.h,
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Text(
                          _getLocationTitle(location),
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

  String _getLocationAsset(String location, bool isSelected) {
    switch (location.toLowerCase()) {
      case 'home':
      case 'nhà':
      case 'tại nhà':
        return isSelected 
            ? TrainingAssets.locationHomeSelected
            : TrainingAssets.locationHome;
      case 'gym':
      case 'phòng gym':
        return isSelected
            ? TrainingAssets.locationGymSelected
            : TrainingAssets.locationGym;
      case 'outside':
      case 'ngoài trời':
      case 'outdoor':
        return isSelected
            ? TrainingAssets.locationOutSideSelected
            : TrainingAssets.locationOutSide;
      case 'anywhere':
      case 'bất kỳ đâu':
      case 'mọi nơi':
        return isSelected
            ? TrainingAssets.locationAnywhereSelected
            : TrainingAssets.locationAnywhere;
      default:
        return TrainingAssets.locationHome;
    }
  }

  String _getLocationTitle(String location) {
    switch (location.toLowerCase()) {
      case 'home':
        return 'Tại nhà';
      case 'gym':
        return 'Phòng Gym';
      case 'outside':
        return 'Ngoài trời';
      case 'anywhere':
        return 'Bất kỳ đâu';
      default:
        return location;
    }
  }
}
