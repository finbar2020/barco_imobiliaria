import 'package:lello/feature/dashboard_preferences/domain/entity/notifications_preferences.dart';
import 'package:lello/feature/dashboard_preferences/domain/use_case/get_notifications_preferences/get_notifications_preferences.dart';
import 'package:lello/feature/dashboard_preferences/domain/use_case/update_notifications_preferences/update_notifications_preferences.dart';
import 'package:lello/feature/dashboard_preferences/presentation/bloc/notifications_preferences_bloc.dart';
import 'package:lello/feature/dashboard_preferences/presentation/bloc/notifications_preferences_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class NotificationsPreferencesController {
  final SessionBloc sessionBloc;
  final NotificationsPreferencesBloc notificationsPreferencesBloc;
  final GetNotificationsPreferencesUseCase getNotificationsPreferencesUseCase;
  final UpdateNotificationsPreferences updateNotificationsPreferencesUseCase;
  List<NotificationsPreferences> notificationsPreferences = [];

  NotificationsPreferencesController({
    required this.sessionBloc,
    required this.notificationsPreferencesBloc,
    required this.getNotificationsPreferencesUseCase,
    required this.updateNotificationsPreferencesUseCase,
  });

  Future<void> getNotificationsPreferences() async {
    notificationsPreferencesBloc.add(NotificationsPreferencesLoadingEvent());

    final response = await getNotificationsPreferencesUseCase
        .call(GetNotificationsPreferencesParam(
      condoId: sessionBloc.state.session!.selectedCondominium!.id,
    ));

    response.fold(
        (error) => notificationsPreferencesBloc.add(
              NotificationsPreferencesFailedEvent(failure: error),
            ), (data) {
      if (data.isEmpty) {
        notificationsPreferencesBloc.add(NotificationsPreferencesEmptyEvent());
      } else {
        notificationsPreferencesBloc.add(
            NotificationsPreferencesLoadedEvent(notificationsPreference: data));
      }
    });
  }

  Future<void> updateNotificationsPreferences(
      {required List<NotificationsPreferences>
          notificationsPreferences}) async {
    notificationsPreferencesBloc.add(NotificationsPreferencesLoadingEvent());

    final response = await updateNotificationsPreferencesUseCase.call(
        UpdateNotificationsPreferencesParam(
            condominiumId: sessionBloc.state.session!.selectedCondominium!.id,
            notificationsPreferences: notificationsPreferences));

    response.fold(
      (error) => notificationsPreferencesBloc
          .add(NotificationsPreferencesUpdateFailedEvent(failure: error)),
      (data) => notificationsPreferencesBloc.add(
        UpdateNotificationsPreferencesLoadedEvent(
            notificationsPreferences: data),
      ),
    );
  }
}
