import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/health_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_event.dart';

import 'package:hit_tech/features/health_infor/cubit/blocs/heath_state.dart';

class GenderSelectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthInfoBloc, HealthInfoState>(
      builder: (context, state) {
        final formState = state is HealthInfoFormState
            ? state
            : HealthInfoFormState();

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Giới Tính',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF07314F),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Chọn giới tính của bạn để chúng tôi cá\nnhân hóa kế hoạch phù hợp nhất.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Gender Options
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGenderOption(
                      context,
                      gender: 'MALE',
                      label: 'Nam',
                      imagePath:
                          'assets/images/health_infor/boy.png', // Replace with actual asset path
                      isSelected: formState.gender == 'MALE',
                    ),
                    SizedBox(width: 16),
                    _buildGenderOption(
                      context,
                      gender: 'FEMALE',
                      label: 'Nữ',
                      imagePath:
                          'assets/images/health_infor/girl.png', // Replace with actual asset path
                      isSelected: formState.gender == 'FEMALE',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Continue Button
              Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: formState.gender != null
                        ? () {
                            context.read<HealthInfoBloc>().add(NextStep());
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: formState.gender != null
                          ? Color(0xFF2196F3)
                          : Color(0xFFE0E0E0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: formState.gender != null ? 2 : 0,
                    ),
                    child: Text(
                      'Tiếp tục',
                      style: TextStyle(
                        fontSize: 16,
                        color: formState.gender != null
                            ? Colors.white
                            : Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenderOption(
    BuildContext context, {
    required String gender,
    required String label,
    required String imagePath,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<HealthInfoBloc>().add(UpdateGender(gender));
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 260,
        width: 160, // Fixed width to match the design
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Container(
              height: 280,
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFB6DBF6) : Color(0xFFFfff),
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: Color(0xFF2196F3), width: 2)
                    : Border.all(color: Color(0xFFE0E0E0), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          gender == 'MALE' ? Icons.male : Icons.female,
                          size: 80,
                          color: isSelected ? Colors.white : Color(0xFF757575),
                        ),
                        SizedBox(height: 8),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected
                                ? Colors.white
                                : Color(0xFF757575),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // Label at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Color(0xFF2196F3) : Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      gender == 'MALE' ? Icons.male : Icons.female,
                      size: 18,
                      color: isSelected ? Color(0xFF2196F3) : Color(0xFF757575),
                    ),
                    SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Color(0xFF2196F3)
                            : Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
