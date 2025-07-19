import 'package:flutter/material.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../core/constants/app_dimension.dart';

class PersonalHealthSelectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Header + Avatar
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/icons/facebook_icon.png'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Truong NguyenX',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.normal,
                  ),
                ),
                const Text(
                  'nguyenxtruong05@gmail.com',
                  style: TextStyle(fontSize: 12, color: AppColors.lightActive),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Các mục
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [_buildProfileSection()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build Inner tile
  Widget _buildInnerTile(IconData icon, String title) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 14)),
      trailing: Text(
        "Check",
        style: TextStyle(color: AppColors.bNormal, fontSize: 14),
      ),
      onTap: () {},
    );
  }

  Widget _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          _buildInnerTile(Icons.person_outline, 'Chiều cao'),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Cân nặng'),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Tuổi'),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Giới tính'),
          const Divider(height: 1, color: AppColors.bLightHover),
          _buildInnerTile(Icons.favorite_border, 'Mức độ hoạt động'),
        ],
      ),
    );
  }
}
