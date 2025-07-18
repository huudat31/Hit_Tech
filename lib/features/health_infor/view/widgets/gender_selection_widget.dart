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
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Giới Tính',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Chọn giới tính của bạn để chúng tôi có thể hoàn hóa kế hoạch luyện tập.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGenderOption(
                    context,
                    gender: 'MALE',
                    label: 'Nam',
                    icon: Icons.male,
                    isSelected: formState.gender == 'MALE',
                  ),
                  _buildGenderOption(
                    context,
                    gender: 'FEMALE',
                    label: 'Nữ',
                    icon: Icons.female,
                    isSelected: formState.gender == 'FEMALE',
                  ),
                ],
              ),

              Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: formState.canProceedFromGender
                      ? () {
                          // Move to next step automatically handled by bloc
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<HealthInfoBloc>().add(UpdateGender(gender));
      },
      child: Container(
        width: 120,
        height: 140,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: isSelected ? Colors.blue : Colors.grey[600],
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.blue : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
