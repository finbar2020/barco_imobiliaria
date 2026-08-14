import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/my_preferences/domain/use_cases/get_unit_personal_data/get_unit_personal_data_use_case.dart';
import 'package:morar/feature/my_preferences/domain/use_cases/update_unit_personal_data/update_unit_personal_data_use_case.dart';

import '../../../../../session/domain/entity/session.dart';
import '../../../../../session/presentation/bloc/session_bloc.dart';
import '../../../../domain/entities/access_data_entity.dart';
import '../../../../domain/entities/personal_data_entity.dart';
import 'in_cara_event.dart';
import 'in_cara_state.dart';

class InCareBloc extends Bloc<InCareEvent, InCareState> {
  InCareBloc(
    this._getUnitPersonalData,
    this._updatePersonalData,
    this._sessionBloc,
  ) : super(const InCareInitialState()) {
    on<InCareSendRequestEvent>((event, emit) {
      emit(const InCareLoadingState());
    });
    on<InCareSuccessEvent>((event, emit) {
      emit(const InCareLoadedState());
    });
    on<InCareFailureEvent>((event, emit) {
      emit(InCareFailureState(error: event.error));
    });
    on<InCareUpdateSuccessEvent>((event, emit) {
      emit(const InCareUpdateSuccessState());
    });
  }

  final GetUnitPersonalDataUseCase _getUnitPersonalData;
  final UpdateUnitPersonalDataUseCase _updatePersonalData;
  final SessionBloc _sessionBloc;
  final formKey = GlobalKey<FormState>();

  Session? get session => _sessionBloc.state.session;

  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();

  final focusNodeName = FocusNode();
  final focusNodeEmail = FocusNode();
  AccessData? accessData;

  bool _hasUnsavedChanges = false;

  bool get hasUnsavedChanges => _hasUnsavedChanges;

  void onChangeEmail() {
    _hasUnsavedChanges = emailTextEditingController.text.isNotEmpty ||
        nameTextEditingController.text != accessData?.unitContactData.careName;
  }

  void onChangeName() {
    _hasUnsavedChanges = nameTextEditingController.text.isNotEmpty ||
        emailTextEditingController.text !=
            accessData?.unitContactData.careEmail;
  }

  Future getUnitPersonalData() async {
    add(const InCareSendRequestEvent());
    final unitId = session?.unity?.notificationContext;
    final result = await _getUnitPersonalData(
      int.tryParse(unitId ?? '0') ?? 0,
    );
    result.fold(
      (error) => add(
        InCareFailureEvent(
          error: error.toString(),
        ),
      ),
      (data) {
        accessData = data;
        nameTextEditingController.text = data.unitContactData.careName;
        emailTextEditingController.text = data.unitContactData.careEmail;
        add(const InCareSuccessEvent());
      },
    );
  }

  Future updateUnitPersonalData() async {
    if (accessData == null) return;

    if (!formKey.currentState!.validate()) return;

    add(const InCareSendRequestEvent());
    final result = await _updatePersonalData(
      accessData!.copyWith(
        personalData: PersonalDataEntity(
          cpf: session?.me?.cpf ?? '',
        ),
        unitContactData: accessData!.unitContactData.copyWith(
          careEmail: emailTextEditingController.text,
          careName: nameTextEditingController.text,
        ),
      ),
    );
    result.fold(
      (error) => add(
        InCareFailureEvent(
          error: error.toString(),
        ),
      ),
      (data) {
        accessData = data;
        _hasUnsavedChanges = false;
        add(const InCareUpdateSuccessEvent());
      },
    );
  }
}
