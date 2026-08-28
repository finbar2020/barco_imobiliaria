import 'dart:async';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_utils.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_all_partner_reviews/get_all_partner_reviews.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/bloc/comfort_partner_reviews_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/bloc/comfort_partner_reviews_event.dart';

class ComfortPartnerReviewsController {
  final ComfortPartnerReviewsBloc comfortPartnerReviewsBloc;
  final GetAllPartnerReviewsUseCase getAllPartnerReviewsUseCase;
  final AppOriginEnum appOriginEnum;
  final sessionBloc;

  StreamSubscription? _subscription;

  ComfortPartnerReviewsController(
      {required this.sessionBloc,
      required this.getAllPartnerReviewsUseCase,
      required this.appOriginEnum,
      required this.comfortPartnerReviewsBloc});

  Future<void> getAllPartnerReviews(
      String partnerId, String partnerName) async {
    comfortPartnerReviewsBloc.add(const LoadingComfortPartnerReviewsEvent());
    String condominiumId =
        ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
    final response = await getAllPartnerReviewsUseCase(
      GetAllPartnerReviewsParam(
        condominiumId: condominiumId,
        partnerId: partnerId,
      ),
    );
    response.fold(
      (error) => comfortPartnerReviewsBloc.add(
        ErrorComfortPartnerReviewsEvent(
            errorMessageKey: "comfort_partner_reviews_error"),
      ),
      (response) {
        switch (appOriginEnum) {
          case AppOriginEnum.owner:
            AnalyticsLogEvents.logEvent(
                event:
                    AnalyticsEventsOwner.comodidadesParceiroAvaliacoesAcessar(),
                userId: sessionBloc.state.session?.me?.id ?? "",
                unitValue:
                    sessionBloc.state.session!.unity?.title?.toString() ?? "",
                referenceValue: sessionBloc
                        .state.session!.condominium?.reference
                        ?.toString() ??
                    "",
                appOrigin: appOriginEnum,
                otherParameters: {
                  "id_parceiro": partnerId,
                  "id_partner": partnerId,
                  "nome_parceiro": partnerName
                });
            break;
          case AppOriginEnum.employee:
            AnalyticsLogEvents.logEvent(
                event: AnalyticsEventsEmployee
                    .comodidadesParceiroAvaliacoesAcessar(),
                referenceValue: sessionBloc
                        .state.session!.condominium?.reference
                        .toString() ??
                    "",
                appOrigin: appOriginEnum,
                otherParameters: {
                  "id_parceiro": partnerId,
                  "id_partner": partnerId,
                  "nome_parceiro": partnerName
                });
            break;
          case AppOriginEnum.manager:
            AnalyticsLogEvents.logEvent(
                event: AnalyticsEventsManager
                    .comodidadesParceiroAvaliacoesAcessar(),
                referenceValue: sessionBloc
                        .state.session?.selectedCondominium?.reference
                        .toString() ??
                    "",
                appOrigin: appOriginEnum,
                otherParameters: {
                  "id_parceiro": partnerId,
                  "id_partner": partnerId,
                  "nome_parceiro": partnerName
                });
            break;
        }
        return comfortPartnerReviewsBloc.add(
          LoadedComfortPartnerReviewsEvent(partnerReviews: response),
        );
      },
    );
  }

  Future<void> close() async {
    await _subscription?.cancel();
    await comfortPartnerReviewsBloc.close();
  }
}
