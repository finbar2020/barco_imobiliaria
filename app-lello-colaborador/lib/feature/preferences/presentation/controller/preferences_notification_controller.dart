import 'package:colaborador/feature/preferences/domain/use_case/get_preferences_notification/get_preferences_notification.dart';
import 'package:colaborador/feature/preferences/domain/use_case/put_preferences_notification/put_preferences_notification.dart';
import 'package:colaborador/feature/preferences/presentation/bloc/preferences_notification_bloc.dart';
import 'package:colaborador/feature/preferences/presentation/bloc/preferences_notification_event.dart';
import 'package:colaborador/feature/preferences/presentation/bloc/preferences_notification_state.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';

class PreferencesNotificationController {
  final PreferencesNotificationBloc bloc;
  final GetNotificationUseCase getNotificationUseCase;
  final PutNotificationUseCase putNotificationUseCase;
  final SessionBloc sessionBloc;
  PreferencesNotificationController({
    required this.bloc,
    required this.getNotificationUseCase,
    required this.putNotificationUseCase,
    required this.sessionBloc,
  });

  Future<void> getPreferences() async {
    bloc.add(PreferencesNotificationLoadingEvent());

    if (sessionBloc.getSession?.condominium.id == null) {
      bloc.add(PreferencesNotificationFailureEvent(failure: null));
      return;
    }

    final response = await getNotificationUseCase.call(
        GetNotificationParam(unityId: sessionBloc.getSession!.condominium.id));
    response.fold(
        (error) =>
            bloc.add(PreferencesNotificationFailureEvent(failure: error)),
        (res) {
      return bloc.add(PreferencesNotificationLoadedEvent(
        preferences: res,
      ));
    });
  }

  Future<void> putPreferences(PreferencesNotificationLoadedState loaded) async {
    bloc.add(PreferencesNotificationLoadingEvent());

    final response = await putNotificationUseCase
        .call(PutNotificationParam(entity: loaded.preferences));

    response.fold(
        (error) =>
            bloc.add(PreferencesNotificationFailureEvent(failure: error)),
        (res) => bloc.add(PreferencesNotificationSuccessEvent()));
  }
}
