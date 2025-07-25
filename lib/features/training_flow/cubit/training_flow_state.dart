import 'package:equatable/equatable.dart';
import '../model/training_step_model.dart';

abstract class TrainingFlowState extends Equatable {
  const TrainingFlowState();

  @override
  List<Object?> get props => [];
}

class TrainingFlowInitial extends TrainingFlowState {}

class TrainingFlowLoading extends TrainingFlowState {}

class TrainingFlowLoaded extends TrainingFlowState {
  final TrainingStepModel stepData;
  final Map<String, List<String>> userSelections;

  const TrainingFlowLoaded({
    required this.stepData,
    required this.userSelections,
  });

  TrainingFlowLoaded copyWith({
    TrainingStepModel? stepData,
    Map<String, List<String>>? userSelections,
  }) {
    return TrainingFlowLoaded(
      stepData: stepData ?? this.stepData,
      userSelections: userSelections ?? this.userSelections,
    );
  }

  @override
  List<Object?> get props => [stepData, userSelections];
}

class TrainingFlowError extends TrainingFlowState {
  final String message;

  const TrainingFlowError(this.message);

  @override
  List<Object?> get props => [message];
}

class TrainingFlowCompleted extends TrainingFlowState {
  final Map<String, List<String>> userSelections;
  final Map<String, dynamic> completionResult;

  const TrainingFlowCompleted({
    required this.userSelections,
    required this.completionResult,
  });

  @override
  List<Object?> get props => [userSelections, completionResult];
}
