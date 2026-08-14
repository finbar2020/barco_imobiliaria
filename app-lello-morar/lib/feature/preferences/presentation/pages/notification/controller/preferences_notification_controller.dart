import 'package:morar/feature/preferences/domain/use_case/get_preferences_notification/get_preferences_notification.dart';
import 'package:morar/feature/preferences/domain/use_case/put_preferences_notification/put_preferences_notification.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/bloc/preferences_notification_bloc.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/bloc/preferences_notification_event.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/bloc/preferences_notification_state.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

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

    if (sessionBloc.state.session?.condominium?.id == null) {
      bloc.add(PreferencesNotificationFailureEvent(error: ""));
      return;
    }

    final response = await getNotificationUseCase.call(
        GetNotificationParam(unityId: sessionBloc.state.session!.unity!.id!));
    response.fold(
        (error) => bloc.add(PreferencesNotificationFailureEvent(error: "")),
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
        (error) => bloc.add(PreferencesNotificationFailureEvent(error: "")),
        (res) => bloc.add(PreferencesNotificationSuccessEvent()));
  }
}
