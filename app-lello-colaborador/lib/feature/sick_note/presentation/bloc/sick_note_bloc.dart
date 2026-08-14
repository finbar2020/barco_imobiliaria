import 'dart:io';

import 'package:colaborador/core/analytics/analytics_log_events.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:colaborador/feature/sick_note/domain/use_case/register_sick_note/sick_note.dart';
import 'package:colaborador/feature/sick_note/presentation/bloc/sick_note_event.dart';
import 'package:colaborador/feature/sick_note/presentation/bloc/sick_note_state.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SickNoteBloc extends Bloc<SickNoteEvent, SickNoteState> {
  final RegisterSickNoteUsecase registerSickNoteUsecase;
  final SessionBloc sessionBloc;

  SickNoteBloc({
    required this.registerSickNoteUsecase,
    required this.sessionBloc,
  }) : super(const SickNoteInitialState()) {
    on<SendSickNoteEvent>(_registerSickNote);
  }

  Future<void> _registerSickNote(
    SendSickNoteEvent event,
    Emitter<SickNoteState> emit,
  ) async {
    emit(const SickNoteLoadingState());

    String condoId = sessionBloc.getSession?.condominium.id ?? "";
    String meId = sessionBloc.getSession?.me.id ?? "";
    if (event.sickNoteEntity.file != null) {
      event.sickNoteEntity.typeFile = event.sickNoteEntity.file!.path
          .substring(event.sickNoteEntity.file!.path.lastIndexOf('.'));
    }

    final result = await registerSickNoteUsecase.call(RegisterSickNoteParam(
      condoId: condoId,
      meId: meId,
      sickNoteEntity: event.sickNoteEntity,
    ));

    SickNoteState response = result.fold((error) {
      return const SickNoteRegisterFailedState();
    }, (s3) {
      EmployeeAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsEmployee.pontoDigitalAtestadoMedicoSucesso(),
        referenceValue:
            sessionBloc.getSession?.condominium.reference.toString() ?? "",
      );
      return const SickNoteRegisterLoadedState();
    });

    emit(response);
  }

  void sendSickNote(
      {required DateTime date,
      required File file,
      String? fileTempHash,
      String? typeFile,
      int? sickNoteDays}) {
    add(SendSickNoteEvent(
        sickNoteEntity: SickNoteEntity(
            date: date, file: file, sickNoteDays: sickNoteDays)));
  }
}
