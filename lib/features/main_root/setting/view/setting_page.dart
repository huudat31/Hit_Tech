import 'package:flutter/material.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

class SettingPage extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<SettingPage> {
  int selectedindex = 0;

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
              const SizedBox(height: 50),
              // Header + Avatar
              Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(TrainingAssets.facebookIcon),
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
                    'Truong_05',
                    style: TextStyle(fontSize: 12, color: AppColors.lightActive),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Các mục
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildSectionTitle('Hồ sơ người dùng'),
                    _buildProfileSection(),

                    _buildSectionTitle('Cài đặt chung'),
                    _buildOverallSettingsSection(),

                    _buildSectionTitle('Thông tin hỗ trợ'),
                    _buildSettingsSection(),

                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.wWhite,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadius,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        // style: ,
                        child: const Text(
                          'Đăng Xuất',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Build title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.bDarkHover,
          fontSize: 14,
        ),
      ),
    );
  }

  // Build Inner tile
  Widget _buildInnerTile(String icon, String title) {
    return ListTile(
      leading: Image.asset(icon, color: AppColors.bDarkHover),
      title: Text(title, style: TextStyle(fontSize: 14)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.bDarkHover,
      ),
      onTap: () {},
    );
  }

  // Title 1
  Widget _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          _buildInnerTile(
            TrainingAssets.personalInformationIcon,
            'Thông tin cá nhân',
          ),
          _buildInnerTile(
            TrainingAssets.healthInformationIcon,
            'Thông tin sức khỏe',
          ),
        ],
      ),
    );
  }

  // Title 2
  _buildOverallSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 16, right: 5),
            leading: Image.asset(TrainingAssets.themeIcon, color: AppColors.bDarkHover),
            title: Text("Chế độ tối", style: TextStyle(fontSize: 14)),
            trailing: Transform.scale(
              scale: 0.7,
              child: Switch(
                value: false,
                onChanged: (value) {},
                activeTrackColor: AppColors.bNormal,
                activeColor: AppColors.wWhite,
                inactiveTrackColor: AppColors.moreLighter,
                inactiveThumbColor: AppColors.wWhite,
              ),
            ),
            onTap: () {},
          ),
          _buildInnerTile(TrainingAssets.noticeIcon, 'Nhắc nhở luyện tập'),
          _buildInnerTile(TrainingAssets.trashIcon, 'Xóa dữ liệu người dùng'),
        ],
      ),
    );
  }

  // Title 3
  _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          _buildInnerTile(TrainingAssets.commentIcon, 'Đánh giá'),
          _buildInnerTile(
            TrainingAssets.policyIcon,
            'Chính sách và điều khoản',
          ),
        ],
      ),
    );
  }
}
