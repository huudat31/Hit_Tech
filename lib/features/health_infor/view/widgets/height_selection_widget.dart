import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/health_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_event.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_state.dart';

class HeightSelectionWidget extends StatelessWidget {
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
                'Chiều Cao',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Chiều cao hiện tại để giúp tính toán chỉ số thể hiện và xuất chế độ dinh dưỡng.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 40),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Height ruler visual
                    Container(
                      width: 60,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          // Ruler markings
                          for (int i = 140; i <= 200; i += 10)
                            Positioned(
                              bottom: ((i - 140) / 60) * 380,
                              left: 0,
                              right: 0,
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 2,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '$i',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Selected height indicator
                          if (formState.height != null)
                            Positioned(
                              bottom: ((formState.height! - 140) / 60) * 380,
                              left: 0,
                              right: 0,
                              child: Container(height: 3, color: Colors.blue),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(width: 40),

                    // Height display
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${formState.height ?? 170}',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          'cm',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Height slider
              Slider(
                value: (formState.height ?? 170).toDouble(),
                min: 140,
                max: 200,
                divisions: 60,
                onChanged: (value) {
                  context.read<HealthInfoBloc>().add(
                    UpdateHeight(value.toInt()),
                  );
                },
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: formState.canProceedFromHeight
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
}
