import 'package:equatable/equatable.dart';

class TrainingStepModel extends Equatable {
  final String currentStep;
  final List<String> selectedValue;
  final TrainingStepData selectedValues;

  const TrainingStepModel({
    required this.currentStep,
    required this.selectedValue,
    required this.selectedValues,
  });

  factory TrainingStepModel.fromJson(Map<String, dynamic> json) {
    return TrainingStepModel(
      currentStep: json['currentStep'] ?? '',
      selectedValue: List<String>.from(json['selectedValue'] ?? []),
      selectedValues: TrainingStepData.fromJson(json['selectedValues'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStep': currentStep,
      'selectedValue': selectedValue,
      'selectedValues': selectedValues.toJson(),
    };
  }

  TrainingStepModel copyWith({
    String? currentStep,
    List<String>? selectedValue,
    TrainingStepData? selectedValues,
  }) {
    return TrainingStepModel(
      currentStep: currentStep ?? this.currentStep,
      selectedValue: selectedValue ?? this.selectedValue,
      selectedValues: selectedValues ?? this.selectedValues,
    );
  }

  @override
  List<Object?> get props => [currentStep, selectedValue, selectedValues];
}

class TrainingStepData extends Equatable {
  final List<String>? goals;
  final List<String>? level;
  final List<String>? duration;
  final List<String>? type;
  final List<String>? frequency;
  final List<String>? location;
  final List<String>? equipment;

  const TrainingStepData({
    this.goals,
    this.level,
    this.duration,
    this.type,
    this.frequency,
    this.location,
    this.equipment,
  });

  factory TrainingStepData.fromJson(Map<String, dynamic> json) {
    return TrainingStepData(
      goals: json['goals'] != null ? List<String>.from(json['goals']) : null,
      level: json['level'] != null ? List<String>.from(json['level']) : null,
      duration: json['duration'] != null ? List<String>.from(json['duration']) : null,
      type: json['type'] != null ? List<String>.from(json['type']) : null,
      frequency: json['frequency'] != null ? List<String>.from(json['frequency']) : null,
      location: json['location'] != null ? List<String>.from(json['location']) : null,
      equipment: json['equipment'] != null ? List<String>.from(json['equipment']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (goals != null) 'goals': goals,
      if (level != null) 'level': level,
      if (duration != null) 'duration': duration,
      if (type != null) 'type': type,
      if (frequency != null) 'frequency': frequency,
      if (location != null) 'location': location,
      if (equipment != null) 'equipment': equipment,
    };
  }

  @override
  List<Object?> get props => [goals, level, duration, type, frequency, location, equipment];
}

class TrainingStepRequest extends Equatable {
  final String currentStep;
  final List<String> selectedValue;
  final Map<String, dynamic> selectedValues;

  const TrainingStepRequest({
    required this.currentStep,
    required this.selectedValue,
    required this.selectedValues,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentStep': currentStep,
      'selectedValue': selectedValue,
      'selectedValues': selectedValues,
    };
  }

  @override
  List<Object?> get props => [currentStep, selectedValue, selectedValues];
}
