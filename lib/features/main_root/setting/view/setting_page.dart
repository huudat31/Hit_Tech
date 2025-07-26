import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_tech/core/constants/app_assets.dart';
import 'package:hit_tech/core/constants/app_color.dart';
import 'package:hit_tech/core/constants/app_dimension.dart';

import '../cubit/setting_cubit.dart';
import '../cubit/setting_state.dart';
import '../service/setting_service.dart';
import 'widgets/personal_information_page.dart';
import 'widgets/personal_health_page.dart';
import 'widgets/notice_training_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingCubit(
        settingService: SettingService(),
      )..loadUserProfile(),
      child: const SettingView(),
    );
  }
}

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bLight,
      body: BlocConsumer<SettingCubit, SettingState>(
        listener: (context, state) {
          if (state is SettingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is SettingProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật thông tin thành công!'),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is SettingAvatarUploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tải ảnh đại diện thành công!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  TrainingAssets.mainBackground,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 50.h),
                  // Header + Avatar
                  _buildHeader(context, state),
                  SizedBox(height: 10.h),
                  // Content sections
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      children: [
                        _buildSectionTitle('Hồ sơ người dùng'),
                        _buildProfileSection(context),
                        _buildSectionTitle('Cài đặt chung'),
                        _buildOverallSettingsSection(context),
                        _buildSectionTitle('Thông tin hỗ trợ'),
                        _buildSupportSection(),
                        SizedBox(height: 20.h),
                        _buildLogoutButton(),
                      ],
                    ),
                  ),
                ],
              ),
              // Loading overlay
              if (state is SettingLoading) _buildLoadingOverlay(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SettingState state) {
    String displayName = 'User';
    String username = 'username';
    
    if (state is SettingLoaded) {
      displayName = state.userProfile.personalInformation?.fullName ?? 
                   '${state.userProfile.firstName ?? ''} ${state.userProfile.lastName ?? ''}';
      username = state.userProfile.username ?? 'username';
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => _showAvatarPicker(context),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundImage: AssetImage(TrainingAssets.profileIcon),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: AppColors.bNormal,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 16.r,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          displayName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: AppColors.normal,
          ),
        ),
        Text(
          username,
          style: TextStyle(
            fontSize: 12.sp, 
            color: AppColors.lightActive,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.bDarkHover,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildInnerTile(String icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Image.asset(icon, color: AppColors.bDarkHover),
      title: Text(title, style: TextStyle(fontSize: 14.sp)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.r,
        color: AppColors.bDarkHover,
      ),
      onTap: onTap,
    );
  }

  Widget _buildProfileSection(BuildContext context) {
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
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<SettingCubit>(),
                  child: const PersonalInformationPage(),
                ),
              ),
            ),
          ),
          _buildInnerTile(
            TrainingAssets.healthInformationIcon,
            'Thông tin sức khỏe',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<SettingCubit>(),
                  child: const PersonalHealthPage(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallSettingsSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: 16.w, right: 5.w),
            leading: Image.asset(TrainingAssets.themeIcon, color: AppColors.bDarkHover),
            title: Text("Chế độ tối", style: TextStyle(fontSize: 14.sp)),
            trailing: Transform.scale(
              scale: 0.7,
              child: Switch(
                value: false,
                onChanged: (value) {
                  // TODO: Implement theme switching
                },
                activeTrackColor: AppColors.bNormal,
                activeColor: AppColors.wWhite,
                inactiveTrackColor: AppColors.moreLighter,
                inactiveThumbColor: AppColors.wWhite,
              ),
            ),
          ),
          _buildInnerTile(
            TrainingAssets.noticeIcon, 
            'Nhắc nhở luyện tập',
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NoticeTrainingPage(),
              ),
            ),
          ),
          _buildInnerTile(
            TrainingAssets.trashIcon, 
            'Xóa dữ liệu người dùng',
            () => _showDeleteDataDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Column(
        children: [
          _buildInnerTile(TrainingAssets.commentIcon, 'Đánh giá', () {}),
          _buildInnerTile(
            TrainingAssets.policyIcon,
            'Chính sách và điều khoản',
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.wWhite,
        borderRadius: BorderRadius.circular(
          AppDimensions.borderRadius,
        ),
      ),
      child: TextButton(
        onPressed: () => _showLogoutDialog(),
        child: const Text(
          'Đăng Xuất',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _showAvatarPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Chọn ảnh đại diện',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAvatarOption(
                  context,
                  Icons.camera_alt,
                  'Camera',
                  () => _pickImageFromCamera(context),
                ),
                _buildAvatarOption(
                  context,
                  Icons.photo_library,
                  'Gallery',
                  () => _pickImageFromGallery(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.bLightHover,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 30.r,
              color: AppColors.bNormal,
            ),
          ),
          SizedBox(height: 8.h),
          Text(label),
        ],
      ),
    );
  }

  void _pickImageFromCamera(BuildContext context) {
    // TODO: Implement camera picker
    // final picker = ImagePicker();
    // final image = await picker.pickImage(source: ImageSource.camera);
    // if (image != null) {
    //   context.read<SettingCubit>().uploadAvatar(avatarFile: File(image.path));
    // }
  }

  void _pickImageFromGallery(BuildContext context) {
    // TODO: Implement gallery picker
    // final picker = ImagePicker();
    // final image = await picker.pickImage(source: ImageSource.gallery);
    // if (image != null) {
    //   context.read<SettingCubit>().uploadAvatar(avatarFile: File(image.path));
    // }
  }

  void _showDeleteDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa tất cả dữ liệu người dùng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete user data
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    // TODO: Implement logout dialog
  }
}
