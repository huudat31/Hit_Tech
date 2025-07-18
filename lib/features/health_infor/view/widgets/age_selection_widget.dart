import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/health_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_event.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_state.dart';

class AgeSelectionWidget extends StatelessWidget {
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
                'Tuổi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Nhập tuổi của bạn để điều chỉnh mục tiêu phù hợp với độ tuổi của bạn.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 40),

              Expanded(
                child: PageView.builder(
                  itemCount: 80,
                  onPageChanged: (index) {
                    final age = index + 10;
                    context.read<HealthInfoBloc>().add(UpdateAge(age));
                  },
                  itemBuilder: (context, index) {
                    final age = index + 10;
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          '$age',
                          style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
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
                  onPressed: formState.canProceedFromAge
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
