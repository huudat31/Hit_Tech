import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';
import 'package:hit_tech/features/training_flow/view/widget/training_equipment_selection_widget.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_color.dart';
import '../../model/training_flow_request.dart';
import '../../service/training_flow_service.dart';

class TrainingLocationSelectionWidget extends StatefulWidget {
  final String? nextStep;
  final Map<String, List<String>> selectedValues;
  final List<String> options;

  const TrainingLocationSelectionWidget({
    Key? key,
    required this.nextStep,
    required this.selectedValues,
    required this.options,
  }) : super(key: key);

  @override
  _TrainingLocationSelectionState createState() =>
      _TrainingLocationSelectionState();
}

class _TrainingLocationSelectionState
    extends State<TrainingLocationSelectionWidget> {
  int? selectedIndex;

  String? get currentStep => widget.nextStep;

  Map<String, List<String>> get selectedValues => widget.selectedValues;

  List<String> get options => widget.options;

  final List<String> locations = [
    "Tại nhà",
    "Phòng gym",
    "Ngoài trời",
    "Mọi nơi",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
        children: [
          // Ảnh nền
          Positioned.fill(
            child: Image.asset(
              TrainingAssets.mainBackground,
              fit: BoxFit.cover,
            ),
          ),

          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50, right: 70),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.bNormal,
                      ),
                    ),
                    SizedBox(width: 35),
                    Expanded(
                      child: Container(
                        height: 7,
                        decoration: BoxDecoration(
                          color: AppColors.moreLighter,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadius,
                          ),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final progress = 6 / 7;
                            return Stack(
                              children: [
                                Container(
                                  width: constraints.maxWidth * progress,
                                  decoration: BoxDecoration(
                                    color: AppColors.bNormal,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadius,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Header
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: AppColors.bLightHover,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusSmall,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20.0,
                      height: 90.0,
                      decoration: BoxDecoration(color: AppColors.bLightActive2),
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Text(
                        'Địa điểm luyện tập\nmà bạn ưa thích?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkActive,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Item list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 200),
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        if (selectedIndex == index) {
                          selectedIndex = null;
                        } else {
                          selectedIndex = index;
                        }
                      }),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        height: 80,
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? AppColors.bLightHover
                              : AppColors.wWhite,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.borderRadiusSmall,
                          ),
                          border: Border.all(
                            color: selectedIndex == index
                                ? AppColors.bNormal
                                : Colors.grey.shade300,
                            width: selectedIndex == index ? 2 : 1,
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
                            SizedBox(width: 20),
                            Image.asset(
                              index == 0
                                  ? (selectedIndex == 0
                                        ? TrainingAssets.locationHomeSelected
                                        : TrainingAssets.locationHome)
                                  : index == 1
                                  ? (selectedIndex == 1
                                        ? TrainingAssets.locationGymSelected
                                        : TrainingAssets.locationGym)
                                  : index == 2
                                  ? (selectedIndex == 2
                                        ? TrainingAssets.locationOutSideSelected
                                        : TrainingAssets.locationOutSide)
                                  : (selectedIndex == 3
                                        ? TrainingAssets
                                              .locationAnywhereSelected
                                        : TrainingAssets.locationAnywhere),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                locations[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: selectedIndex == index
                                      ? AppColors.bNormal
                                      : AppColors.darkActive,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                selectedIndex == index
                                    ? TrainingAssets.tickActive
                                    : TrainingAssets.tickNonActive,
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Overlay mờ dần từ dưới lên
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.wWhite, Colors.transparent],
                    stops: [0.0, 0.0],
                  ),
                ),
              ),
            ),
          ),

          // Button "Tiếp tục" nổi lên trên cùng
          Positioned(
            left: 16,
            right: 16,
            bottom: 70,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedIndex != null
                    ? AppColors.bNormal
                    : AppColors.bLightNotActive,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: selectedIndex != null
                  ? () async {
                      final request = TrainingFlowRequest(
                        currentStep: currentStep,
                        selectedValue: options,
                        selectedValues: selectedValues,
                      );

                      try {
                        final response = await TrainingFlowService.sendStep(
                          request,
                        );

                        var selectedValues = response.selectedValues;

                        print(response.nextStep);
                        print(selectedValues);
                        print(response.options);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrainingEquipmentSelectionWidget(
                              nextStep: response.nextStep,
                              selectedValues: selectedValues,
                              options: response.options,
                            ),
                          ),
                        );
                      } catch (e) {
                        print("Error: $e");
                      }
                    }
                  : null,
              child: Text(
                "Tiếp tục",
                style: TextStyle(
                  fontSize: 20,
                  color: selectedIndex != null
                      ? AppColors.wWhite
                      : AppColors.wDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
