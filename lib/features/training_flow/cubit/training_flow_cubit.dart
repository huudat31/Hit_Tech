import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/training_step_model.dart';
import '../service/training_flow_service.dart';
import 'training_flow_state.dart';

class TrainingFlowCubit extends Cubit<TrainingFlowState> {
  final TrainingFlowService _trainingFlowService;
  
  // Store user selections across steps
  final Map<String, List<String>> _userSelections = {};

  TrainingFlowCubit({
    required TrainingFlowService trainingFlowService,
  })  : _trainingFlowService = trainingFlowService,
        super(TrainingFlowInitial());

  /// Initialize training flow with the first step
  Future<void> initializeTrainingFlow() async {
    await getTrainingStep(
      currentStep: 'goals',
      selectedValue: [],
    );
  }

  /// Get training step data from API
  Future<void> getTrainingStep({
    required String currentStep,
    required List<String> selectedValue,
  }) async {
    try {
      emit(TrainingFlowLoading());
      
      final stepData = await _trainingFlowService.getTrainingStep(
        currentStep: currentStep,
        selectedValue: selectedValue,
        selectedValues: _userSelections,
      );

      emit(TrainingFlowLoaded(
        stepData: stepData,
        userSelections: Map.from(_userSelections),
      ));
    } catch (e) {
      emit(TrainingFlowError(e.toString()));
    }
  }

  /// Save user selection and move to next step
  Future<void> selectAndProceed({
    required String currentStep,
    required List<String> selectedValues,
    String? nextStep,
  }) async {
    // Save current selection
    _userSelections[currentStep] = selectedValues;

    // If nextStep is provided, get next step data
    if (nextStep != null && nextStep.isNotEmpty) {
      await getTrainingStep(
        currentStep: nextStep,
        selectedValue: selectedValues,
      );
    } else {
      // Just update state with current selections
      final currentState = state;
      if (currentState is TrainingFlowLoaded) {
        emit(currentState.copyWith(
          userSelections: Map.from(_userSelections),
        ));
      }
    }
  }

  /// Go back to previous step
  Future<void> goToPreviousStep(String previousStep) async {
    final previousSelections = _userSelections[previousStep] ?? [];
    await getTrainingStep(
      currentStep: previousStep,
      selectedValue: previousSelections,
    );
  }

  /// Get user selection for a specific step
  List<String> getUserSelection(String step) {
    return _userSelections[step] ?? [];
  }

  /// Clear all selections and start over
  void resetTrainingFlow() {
    _userSelections.clear();
    emit(TrainingFlowInitial());
  }

  /// Update selection without API call (for temporary selection)
  void updateTemporarySelection(String step, List<String> values) {
    final currentState = state;
    if (currentState is TrainingFlowLoaded) {
      final updatedSelections = Map<String, List<String>>.from(_userSelections);
      updatedSelections[step] = values;
      
      emit(currentState.copyWith(
        userSelections: updatedSelections,
      ));
    }
  }

  /// Complete training flow (final step)
  Future<void> completeTrainingFlow() async {
    try {
      emit(TrainingFlowLoading());
      
      // Call API to submit training configuration
      final completionResult = await _trainingFlowService.submitTrainingConfiguration(
        userSelections: _userSelections,
      );
      
      emit(TrainingFlowCompleted(
        userSelections: Map.from(_userSelections),
        completionResult: completionResult,
      ));
    } catch (e) {
      emit(TrainingFlowError('Không thể hoàn thành thiết lập: ${e.toString()}'));
    }
  }
}
