import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_color.dart';

class TrainingEquipmentSelectionWidget extends StatefulWidget {
  @override
  _TrainingEquipmentSelectionState createState() =>
      _TrainingEquipmentSelectionState();
}

class _TrainingEquipmentSelectionState
    extends State<TrainingEquipmentSelectionWidget> {
  int? selectedIndex;

  final List<String> equipments = [
    "Không có",
    "Thảm yoga",
    "Máy chạy bộ",
    "Dây kháng lực",
    "Đầy đủ thiết bị Gym",
    "Xà đơn",
    "Xà kép",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: Stack(
        children: [
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
                            final progress = 7 / 7;
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
                        'Thiết bị luyện tập\nmà bạn có?',
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
                  itemCount: equipments.length,
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
                        height: 100,
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
                                  ? 'assets/images/type/yoga.png'
                                  : 'assets/images/type/yoga.png')
                                  : index == 1
                                  ? (selectedIndex == 1
                                  ? 'assets/images/type/calisthenic_selected.png'
                                  : 'assets/images/type/calisthenic.png')
                                  : index == 2
                                  ? (selectedIndex == 2
                                  ? 'assets/images/type/gym.png'
                                  : 'assets/images/type/gym.png')
                                  : (selectedIndex == 3
                                  ? 'assets/images/type/cardio.png'
                                  : 'assets/images/type/cardio.png'),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                equipments[index],
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
                                    ? TrainingAssets.durationSelected
                                    : TrainingAssets.durationNonSelect,
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
                    stops: [0.0, 0.2],
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
              onPressed: selectedIndex != null ? () {} : null,
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
