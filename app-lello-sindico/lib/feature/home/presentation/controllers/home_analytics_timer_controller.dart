import 'package:essentials/analytics/analytics_timer.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/shared_features.dart';

class HomeAnalyticsTimerController {
  final SessionBloc sessionBloc;
  HomeAnalyticsTimerController({required this.sessionBloc});
  AnalyticsTimer? sindicoHomeTimer;

  Future<AccessToken?> get _getAccessToken async {
    GetToken getToken = ApplicationContainer.instance().resolve<GetToken>();
    final token = await getToken.call(GetTokenParams(role: null));
    return token.getOrElse(() => null);
  }

  Future<String> get _getUserType async {
    final token = await _getAccessToken;
    return token?.selectedRole ?? "";
  }

  void sindicoHomeTimerStart(int id) async {
    sindicoHomeTimer = AnalyticsTimer(
      userType: await _getUserType,
      userId: sessionBloc.state.session?.me?.id.toString() ?? "",
      event: AnalyticsEventsManager.homeTemporizador(),
      referenceValue: sessionBloc.state.session?.selectedCondominium?.reference
              .toString() ??
          "",
      appOrigin: AppOriginEnum.manager,
      otherParameters: {
        "sindicoHomeTimerStart": id.toString(),
      },
    );
  }

  void sindicoHomeTimerStop() {
    sindicoHomeTimer?.stopTimer();
  }
}
