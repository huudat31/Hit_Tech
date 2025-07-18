import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/health_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_event.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_state.dart';

class ActivityLevelSelectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activityLevels = [
    {
      'level': 'SEDENTARY',
      'title': 'Ít vận động',
      'description': 'Chủ yếu ngồi hoặc nằm, ít hoạt động thể chất',
      'icon': Icons.weekend,
    },
    {
      'level': 'LIGHT',
      'title': 'Vận động nhẹ',
      'description': 'Đi bộ, tập thể dục nhẹ 1-3 ngày/tuần',
      'icon': Icons.directions_walk,
    },
    {
      'level': 'MODERATE',
      'title': 'Vận động vừa',
      'description': 'Tập thể dục vừa phải 3-5 ngày/tuần',
      'icon': Icons.directions_run,
    },
    {
      'level': 'ACTIVE',
      'title': 'Vận động nhiều',
      'description': 'Tập thể dục cường độ cao 6-7 ngày/tuần',
      'icon': Icons.fitness_center,
    },
  ];
  ActivityLevelSelectionWidget({super.key});

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
                'Mức Độ Hoạt Động',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Chọn mức độ hoạt động phù hợp với lối sống của bạn',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 40),

              Expanded(
                child: ListView.builder(
                  itemCount: activityLevels.length,
                  itemBuilder: (context, index) {
                    final activity = activityLevels[index];
                    final isSelected =
                        formState.activityLevel == activity['level'];

                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () {
                          context.read<HealthInfoBloc>().add(
                            UpdateActivityLevel(activity['level']),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                activity['icon'],
                                size: 32,
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey[600],
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activity['title'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      activity['description'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: formState.canSubmit
                      ? () {
                          context.read<HealthInfoBloc>().add(
                            SubmitHealthInfo(),
                          );
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
                    'Hoàn thành',
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
}
