import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/digital_meeting/presentation/bloc/digital_meeting_bloc.dart';
import 'package:morar/feature/digital_meeting/presentation/bloc/digital_meeting_event.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

import '../../domain/entity/digital_meeting.dart';
import '../../domain/use_case/get_assemblies/get_assemblies.dart';
import '../../domain/use_case/get_assembly/get_assembly.dart';

class DigitalMeetingController {
  final GetMeetings getMeetingsUsecase;
  final GetMeetingDataUseCase getMeetingDataUsecase;
  final SessionBloc sessionBloc;
  final DigitalMeetingBloc bloc;

  DigitalMeetingController({
    required this.getMeetingsUsecase,
    required this.getMeetingDataUsecase,
    required this.sessionBloc,
    required this.bloc,
  });

  Future<void> getMeetings() async {
    bloc.add(DigitalMeetingLoadingEvent());

    final response = await getMeetingsUsecase.call(GetMeetingsParams(
        showAll: false, unitId: sessionBloc.state.session!.unity!.id!));

    response.fold(
        (error) => bloc.add(DigitalMeetingFailureEvent(
              message: error.toString(),
            )), (data) {
      if (data.isEmpty) {
        return bloc.add(DigitalMeetingEmptyEvent());
      }
      OwnerAnalyticsLogEvents.logEvent(
        userId: sessionBloc.state.session?.me?.id ?? "",
        event: AnalyticsEventsOwner.resolvaFacilAssembleiaAcessar(),
        unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
        referenceValue:
            sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
      );
      bloc.add(DigitalMeetingLoadedEvent(meetings: data));
    });
  }

  Future<void> getAllMeetings() async {
    bloc.add(DigitalMeetingLoadingEvent());

    final response = await getMeetingsUsecase.call(GetMeetingsParams(
        showAll: false, unitId: sessionBloc.state.session!.unity!.id!));

    response.fold(
        (error) =>
            bloc.add(DigitalMeetingFailureEvent(message: error.toString())),
        (data) {
      if (data.isEmpty) {
        return bloc.add(DigitalMeetingFailureEvent(message: ""));
      }
      bloc.add(DigitalMeetingShowAllEvent(meetings: data));
    });
  }

  Future<void> getWebView({required DigitalMeeting meeting}) async {
    bloc.add(DigitalMeetingLoadingEvent());

    if (meeting.validtUntul!.difference(DateTime.now()).inMinutes < 20) {
      return bloc.add(DigitalMeetingWebViewEvent(
        meeting: meeting,
      ));
    }
    final response = await getMeetingDataUsecase
        .call(GetMeetingDataParams(meeting.tokenHash!));
    response.fold(
      (error) =>
          bloc.add(DigitalMeetingFailureEvent(message: error.toString())),
      (data) {
        OwnerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner.resolvaFacilAssembleiaParticiparzoom(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
        );
        bloc.add(DigitalMeetingWebViewEvent(meeting: meeting));
      },
    );
  }
}
