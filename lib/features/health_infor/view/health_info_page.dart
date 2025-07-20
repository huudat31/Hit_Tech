import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/health_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_state.dart';
import 'package:hit_tech/features/health_infor/view/widgets/activity_level_selection_widget.dart';
import 'package:hit_tech/features/health_infor/view/widgets/age_selection_widget.dart';
import 'package:hit_tech/features/health_infor/view/widgets/gender_selection_widget.dart';
import 'package:hit_tech/features/health_infor/view/widgets/height_selection_widget.dart';
import 'package:hit_tech/features/health_infor/view/widgets/weight_selection_widget.dart';

class HealthInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F8FF),
      body: SafeArea(
        child: BlocConsumer<HealthInfoBloc, HealthInfoState>(
          listener: (context, state) {
            if (state is HealthInfoSuccess) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            } else if (state is HealthInfoError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is HealthInfoLoading) {
              return Center(child: CircularProgressIndicator());
            }

            final formState = state is HealthInfoFormState
                ? state
                : HealthInfoFormState();

            return Column(
              children: [
                // Progress Bar
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (formState.currentStep + 1) / 5,
                          backgroundColor: Color(0xffEDF3F8),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(child: _buildCurrentStep(formState)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentStep(HealthInfoFormState state) {
    switch (state.currentStep) {
      case 0:
        return GenderSelectionWidget();
      case 1:
        return AgeSelectionWidget();
      case 2:
        return HeightSelectionWidget();
      case 3:
        return WeightSelectionWidget();
      case 4:
        return ActivityLevelSelectionWidget();
      default:
        return GenderSelectionWidget();
    }
  }
}
