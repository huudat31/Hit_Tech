import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

import '../../core/constants/app_color.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      margin: const EdgeInsets.only(left: 50, top: 16, right: 50, bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.bNormal,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          return _buildNavItem(index);
        }),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final icons = [
      Icons.home_outlined,
      Icons.menu_book_outlined,
      Icons.bar_chart,
      Icons.notifications_none,
      Icons.person_outline,
    ];

    final labels = [
      "Tổng quan",
      "Thư viện",
      "Luyện tập",
      "Thông báo",
      "Cá nhân",
    ];

    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 8 : 0,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.bLightActive2 : Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        ),
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(left: isSelected ? 0 : 8),
              child: Icon(
                icons[index],
                color: isSelected ? Colors.white : Colors.black,
                size: 23,
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  labels[index],
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}