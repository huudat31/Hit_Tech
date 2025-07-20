import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_event.dart';
import 'package:hit_tech/features/health_infor/cubit/blocs/heath_state.dart';
import 'package:hit_tech/features/health_infor/cubit/data/repository/health_infor_repo.dart';
import 'package:hit_tech/features/health_infor/model/heath_infor_model.dart';

class HealthInfoBloc extends Bloc<HealthInfoEvent, HealthInfoState> {
  final HealthInforRepo _repository;

  HealthInfoBloc(this._repository) : super(HealthInfoInitial()) {
    on<UpdateGender>(_onUpdateGender);
    on<UpdateAge>(_onUpdateAge);
    on<UpdateHeight>(_onUpdateHeight);
    on<UpdateWeight>(_onUpdateWeight);
    on<UpdateActivityLevel>(_onUpdateActivityLevel);
    on<SubmitHealthInfo>(_onSubmitHealthInfo);
    on<NextStep>(_onNextStep);
    on<PreviousStep>(_onPreviousStep);
  }

  void _onUpdateGender(UpdateGender event, Emitter<HealthInfoState> emit) {
    final currentState = state;
    if (currentState is HealthInfoFormState) {
      emit(currentState.copyWith(gender: event.gender));
    } else {
      emit(HealthInfoFormState(gender: event.gender));
    }
  }

  void _onUpdateAge(UpdateAge event, Emitter<HealthInfoState> emit) {
    final currentState = state;
    if (currentState is HealthInfoFormState) {
      emit(currentState.copyWith(age: event.age));
    }
  }

  void _onUpdateHeight(UpdateHeight event, Emitter<HealthInfoState> emit) {
    final currentState = state;
    if (currentState is HealthInfoFormState) {
      emit(currentState.copyWith(height: event.height));
    }
  }

  void _onUpdateWeight(UpdateWeight event, Emitter<HealthInfoState> emit) {
    final currentState = state;
    if (currentState is HealthInfoFormState) {
      emit(currentState.copyWith(weight: event.weight));
    }
  }

  void _onUpdateActivityLevel(
    UpdateActivityLevel event,
    Emitter<HealthInfoState> emit,
  ) {
    final currentState = state;
    if (currentState is HealthInfoFormState) {
      emit(currentState.copyWith(activityLevel: event.activityLevel));
    }
  }

  void _onSubmitHealthInfo(
    SubmitHealthInfo event,
    Emitter<HealthInfoState> emit,
  ) async {
    final currentState = state;
    if (currentState is HealthInfoFormState && currentState.canSubmit) {
      emit(HealthInfoLoading());
      try {
        var healthInfoModel = HealthInfoModel(
          gender: currentState.gender!,
          height: currentState.height!,
          weight: currentState.weight!,
          age: currentState.age!,
          activityLevel: currentState.activityLevel!,
        );
        final healthInfo = healthInfoModel;

        await _repository.submitHealthInfo(healthInfo);
        emit(HealthInfoSuccess());
      } catch (e) {
        emit(HealthInfoError(e.toString()));
      }
    }
  }

  void _onNextStep(NextStep event, Emitter<HealthInfoState> emit) async {
    if (state is HealthInfoFormState) {
      final currentState = state as HealthInfoFormState;
      if (currentState.currentStep < 4) {
        emit(currentState.copyWith(currentStep: currentState.currentStep + 1));
      }
    }
  }

  void _onPreviousStep(PreviousStep event, Emitter<HealthInfoState> emit) {
    if (state is HealthInfoFormState) {
      final currentState = state as HealthInfoFormState;
      if (currentState.currentStep > 0) {
        emit(currentState.copyWith(currentStep: currentState.currentStep - 1));
      }
    }
  }
}
