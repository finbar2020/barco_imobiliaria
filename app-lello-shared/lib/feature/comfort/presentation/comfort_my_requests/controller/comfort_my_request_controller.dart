import 'dart:async';

import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/analytics_timer.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_message_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_requests_filter.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_review_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_subcategories.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_utils.dart';
import 'package:shared_features/feature/comfort/domain/use_case/change_partner_favorite_status/change_partner_favorite_status.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_my_requests/get_my_requests.dart';
import 'package:shared_features/feature/comfort/domain/use_case/get_subcategories/get_subcategories.dart';
import 'package:shared_features/feature/comfort/domain/use_case/resend_request/resend_request.dart';
import 'package:shared_features/feature/comfort/domain/use_case/send_review_request/send_review_request.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_event.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/bloc/comfort_my_requests_state.dart';
import 'package:shared_features/shared_features.dart';

class ComfortMyRequestsController {
  final ComfortMyRequestsBloc comfortMyRequestsBloc;
  final GetMyRequestsUseCase getMyRequestsUseCase;
  final ChangePartnerFavoriteStatusUseCase changePartnerFavoriteStatusUseCase;
  final SendReviewRequestUseCase postRateRequestUseCase;
  final ResendRequestUseCase resendRequestUseCase;
  final GetSubcategoriesUseCase subcategoriesUseCase;
  final AppOriginEnum appOriginEnum;
  final sessionBloc;
  final GetToken getToken;

  AnalyticsTimer? comfortMyRequestsTimer, comfortMyRequestsBottomSheetTimer;

  ComfortRequestsFilter? filter;
  List<ComfortSubcategories> subcategories = [];

  StreamSubscription? _subscription;

  List<ComfortCompletedRequest> myRequests = [];

  ComfortCompletedRequest? partnerSelectedRequest;

  late final PagingController<int, ComfortCompletedRequest> pagingController =
      PagingController<int, ComfortCompletedRequest>(
    getNextPageKey: (state) {
      final pages = state.pages;
      if (pages == null || pages.isEmpty) return 1;
      if (pages.last.length < _pageSize) return null;
      return state.nextIntPageKey;
    },
    fetchPage: _fetchPage,
  );

  bool isBottomSheetOpen = false;

  ComfortMyRequestsController({
    required this.comfortMyRequestsBloc,
    required this.getMyRequestsUseCase,
    required this.changePartnerFavoriteStatusUseCase,
    required this.postRateRequestUseCase,
    required this.resendRequestUseCase,
    required this.subcategoriesUseCase,
    required this.sessionBloc,
    required this.getToken,
    this.filter,
    this.partnerSelectedRequest,
    required this.appOriginEnum,
  });

  static const _pageSize = 10;

  bool isFilterActive() {
    bool dateFiltersActive =
        filter?.startDate != null || filter?.endDate != null;

    bool statusFilterActive = filter?.status != null &&
        filter?.status != ComfortFilterRequestStatus.all;

    bool subcategoriesFilterActive = filter?.subcategories != null &&
        filter?.subcategories != ComfortType.all;

    return dateFiltersActive || statusFilterActive || subcategoriesFilterActive;
  }

  Map<String, Map<String?, Function>> generateFilters(BuildContext context) {
    Map<String, Map<String?, Function>> filtersToShow = {};
    if (filter != null) {
      if (filter!.startDate != null && filter!.endDate != null) {
        filtersToShow.addAll({
          "filter_item_datarange_title": {
            "${getString(context, "from")}: ${DateFormat.yMd().format(filter!.startDate!)} ${getString(context, "to")}: ${DateFormat.yMd().format(filter!.endDate!)}":
                () async {
              filter!.startDate = null;
              filter!.endDate = null;
              getMyRequests();
            }
          }
        });
      }
      if (filter!.status != null &&
          filter!.status != ComfortFilterRequestStatus.all) {
        filtersToShow.addAll({
          "comfort_request_filter_status": {
            ComfortFilterRequestStatusExtension.enumToStringStatus(
                context, filter!.status): () async {
              filter!.status = ComfortFilterRequestStatus.all;
              getMyRequests();
            }
          }
        });
      }
      if (filter!.subcategories != null &&
          filter!.subcategories != ComfortType.all) {
        filtersToShow.addAll({
          "comfort_request_filter_subcategories": {
            ComfortSubcategories.enumToStringSubcategories(
                context, filter!.subcategories): () async {
              filter!.subcategories = ComfortType.all;
              getMyRequests();
            }
          }
        });
      }
    }

    return filtersToShow;
  }

  Future<void> getSubcategories() async {
    comfortMyRequestsBloc.add(LoadingComfortMyRequestsEvent());
    String condominiumId =
        ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);

    final response = await subcategoriesUseCase(
        GetSubcategoriesUseCaseParam(condominiumId: condominiumId));

    response.fold(
        (error) => comfortMyRequestsBloc.add(ErrorComfortMyRequestsEvent(
            errorMessageKey: 'comfort_get_subcategories_error',
            errorCode: error.code.toString(),
            errorDescription: null)), (response) {
      subcategories
        ..clear()
        ..addAll(response);
      return comfortMyRequestsBloc
          .add(LoadedSubcategoriesMyRequestEvent(subcategories: subcategories));
    });
  }

  Future<void> getMyRequests({
    int page = 1,
  }) async {
    if (page == 1) {
      pagingController.refresh();
      return;
    }
    pagingController.fetchNextPage();
  }

  Future<List<ComfortCompletedRequest>> _fetchPage(int page) async {
    if (page == 1) {
      comfortMyRequestsBloc.add(LoadingComfortMyRequestsEvent());
      myRequests.clear();
    }

    String condominiumId =
        ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
    final response = await getMyRequestsUseCase(
      GetMyRequestsUseCaseParam(
        condominiumId: condominiumId,
        page: page,
        pageSize: _pageSize,
        startDate: filter?.startDate,
        endDate: filter?.endDate,
        status: filter?.status == ComfortFilterRequestStatus.all
            ? null
            : filter?.status,
        requestType: filter?.subcategories == ComfortType.all
            ? null
            : filter?.subcategories,
      ),
    );

    return response.fold((error) {
      if (page == 1) {
        comfortMyRequestsBloc.add(
          ErrorComfortMyRequestsEvent(
            errorMessageKey: 'comfort_get_my_requests_error',
            errorCode: error.code.toString(),
            errorDescription: "",
          ),
        );
      }
      // O `Failure` não é uma `Exception`: relançá-lo faria o
      // `PagingController` propagar um erro não tratado. O erro é registrado
      // no próprio controller de paginação, que passa a exibir o indicador
      // de erro da página.
      pagingController.value = pagingController.value.copyWith(error: error);
      return <ComfortCompletedRequest>[];
    }, (response) {
      if (page == 1) {
        myRequests.clear();
      }
      if (response.data.isEmpty && page == 1) {
        debugPrint("No items found");
      } else {
        myRequests.addAll(response.data);
      }
      comfortMyRequestsBloc.add(LoadedMyRequestsEvent(myRequests: myRequests));
      return response.data;
    });
  }

  Future<void> changePartnerFavoriteStatus(
      String partnerId, String partnerName, bool favorite) async {
    comfortMyRequestsBloc.add(LoadingComfortMyRequestsEvent());
    String condominiumId =
        ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
    final response = await changePartnerFavoriteStatusUseCase(
      ChangePartnerFavoriteStatusParam(
          condominiumId: condominiumId,
          partnerId: partnerId,
          isFavorite: favorite),
    );
    if (partnerSelectedRequest == null) {
      comfortMyRequestsBloc.add(
        ErrorComfortMyRequestsEvent(
            errorMessageKey: 'comfort_rate_page_error',
            errorCode: null,
            errorDescription: null),
      );
    } else {
      response.fold(
        (error) => comfortMyRequestsBloc.add(
          LoadedRateRequestEvent(
              selectedRequest: partnerSelectedRequest!,
              flushbarMessage: "comfort_change_partner_favorite_status_error"),
        ),
        (response) {
          analyticsComodidadesMudarFavorito(partnerId, partnerName);
          partnerSelectedRequest!.partner.partnerIntro.favorite =
              response.isFavorite;

          return comfortMyRequestsBloc.add(
            LoadedRateRequestEvent(selectedRequest: partnerSelectedRequest!),
          );
        },
      );
    }
  }

  Future<void> reviewRequest(
      {required String requestId,
      required double rate,
      String? comment}) async {
    comfortMyRequestsBloc.add(LoadingComfortMyRequestsEvent());
    ComfortReviewRequest review = ComfortReviewRequest(
        requestId: requestId, rating: rate, comment: comment);

    String condominiumId =
        ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
    final response = await postRateRequestUseCase(
      SendReviewRequestParam(
        condominiumId: condominiumId,
        review: review,
      ),
    );
    response.fold(
        (error) => comfortMyRequestsBloc.add(
              ErrorComfortMyRequestsEvent(
                  errorMessageKey: 'comfort_send_review_request_error',
                  errorCode: null,
                  errorDescription: null),
            ), (response) {
      analyticsComodidadesAvaliar();
      return comfortMyRequestsBloc.add(
        SuccessComfortMyRequestsEvent(),
      );
    });
  }

  Future<void> goToRateRequestPage(
      ComfortCompletedRequest selectedRequest) async {
    partnerSelectedRequest = selectedRequest;
    return comfortMyRequestsBloc.add(
      LoadedRateRequestEvent(selectedRequest: selectedRequest),
    );
  }

  Future<void> backToLoadedMyRequestsState() async {
    if (myRequests.isEmpty) {
      getMyRequests();
    } else {
      return comfortMyRequestsBloc.add(
        LoadedMyRequestsEvent(myRequests: myRequests),
      );
    }
  }

  Future<void> close() async {
    await _subscription?.cancel();
    pagingController.dispose();
    await comfortMyRequestsBloc.close();
  }

  Future<void> resendRequest(String? requestId) async {
    if (requestId != null &&
        comfortMyRequestsBloc.state is LoadedMyRequestsState) {
      var curentState = comfortMyRequestsBloc.state as LoadedMyRequestsState;

      comfortMyRequestsBloc.add(LoadingComfortMyRequestsEvent());

      String condominiumId =
          ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
      final response = await resendRequestUseCase(
        ResendRequestParam(condominiumId: condominiumId, requestId: requestId),
      );

      response.fold(
        (error) {
          return comfortMyRequestsBloc.add(
            ErrorComfortMyRequestsEvent(
                errorMessageKey: 'comfort_get_my_requests_error',
                errorCode: error.code.toString(),
                errorDescription: ""),
          );
        },
        (response) {
          getMyRequests(page: 1);

          pagingController.mapItems(
            (item) => item.idRequest == requestId ? response : item,
          );

          return comfortMyRequestsBloc.add(LoadedMyRequestsEvent(
              myRequests: curentState.myRequests, selectedRequest: response));
        },
      );
    }
  }

  void sendMessage(String idRequest, ComfortRequestMessageType? newMessageType,
      String? newComment) {}

  String get getCondoName {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
        return sessionBloc.state.session?.condominium?.name ?? "";
      case AppOriginEnum.owner:
        return sessionBloc.state.session?.condominium?.name ?? "";
      case AppOriginEnum.manager:
        return sessionBloc.state.session?.selectedCondominium?.name ?? "";
    }
  }

  void analyticsComodidadesSolicitacoesAcessar() {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        AnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner.comodidadesSolicitacoesAcessar(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title?.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
          appOrigin: appOriginEnum,
        );
        break;
      case AppOriginEnum.employee:
        AnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.comodidadesSolicitacoesAcessar(),
          referenceValue:
              sessionBloc.state.session!.condominiumId?.toString() ?? "",
          appOrigin: appOriginEnum,
        );
        break;
      case AppOriginEnum.manager:
        // TODO: Handle this case.
        break;
    }
  }

  void analyticsComodidadesMudarFavorito(String partnerId, String partnerName) {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        AnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner.comodidadesMudarFavorito(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title?.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
          appOrigin: appOriginEnum,
          otherParameters: {
            "id_parceiro": partnerId,
            "id_partner": partnerId,
            "nome_parceiro": partnerName
          },
        );
        break;
      case AppOriginEnum.employee:
        AnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.comodidadesMudarFavorito(),
          referenceValue:
              sessionBloc.state.session!.condominium?.reference.toString() ??
                  "",
          appOrigin: appOriginEnum,
          otherParameters: {
            "id_parceiro": partnerId,
            "id_partner": partnerId,
            "nome_parceiro": partnerName
          },
        );
        break;
      case AppOriginEnum.manager:
        AnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.comodidadesMudarFavorito(),
          referenceValue: sessionBloc
                  .state.session?.selectedCondominium?.reference
                  .toString() ??
              "",
          appOrigin: appOriginEnum,
          otherParameters: {
            "id_parceiro": partnerId,
            "id_partner": partnerId,
            "nome_parceiro": partnerName
          },
        );
        break;
    }
  }

  void analyticsComodidadesAvaliar() {
    switch (appOriginEnum) {
      case AppOriginEnum.owner:
        AnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner.comodidadesAvaliar(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title?.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
          appOrigin: appOriginEnum,
        );
        break;
      case AppOriginEnum.employee:
        AnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.comodidadesAvaliar(),
          referenceValue:
              sessionBloc.state.session!.condominiumId?.toString() ?? "",
          appOrigin: appOriginEnum,
        );
        break;
      case AppOriginEnum.manager:
        // TODO: Handle this case.
        break;
    }
  }

  String get getCondoReference {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
        return sessionBloc.state.session?.condominium?.reference ?? "";
      case AppOriginEnum.owner:
        return sessionBloc.state.session?.condominium?.reference ?? "";
      case AppOriginEnum.manager:
        return sessionBloc.state.session?.selectedCondominium?.reference ?? "";
    }
  }

  //TODO: Refactor this to a better place
  Future<AccessToken?> get _getAccessToken async {
    final token = await getToken.call(GetTokenParams(role: null));
    return token.getOrElse(() => null);
  }

  Future<String> get _getUserType async {
    final token = await _getAccessToken;
    return token?.selectedRole ?? "";
  }

  void comfortMyRequestsAnalyticsTimerStart() async {
    comfortMyRequestsTimer = AnalyticsTimer(
      userType: await _getUserType,
      userId: sessionBloc.state.session?.me?.id ?? "",
      event: AnalyticsEventsManager.comodidadesMinhasSolicitacoesTemporizador(),
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
    );
  }

  void comfortMyRequestsAnalyticsTimerStop() {
    comfortMyRequestsTimer?.stopTimer();
  }

  void comfortMyRequestsBottomSheetAnalyticsTimerStart() async {
    comfortMyRequestsBottomSheetTimer = AnalyticsTimer(
      userType: await _getUserType,
      userId: sessionBloc.state.session?.me?.id ?? "",
      event: AnalyticsEventsManager
          .comodidadesBottomSheetMinhasSolicitacoesTemporizador(),
      referenceValue: getCondoReference,
      appOrigin: appOriginEnum,
    );
  }

  void comfortMyRequestsBottomSheetAnalyticsTimerStop() {
    comfortMyRequestsBottomSheetTimer?.stopTimer();
  }

  void updateItem(ComfortCompletedRequest updatedItem, int index) {
    myRequests[index] = updatedItem;
    pagingController.mapItems(
      (item) => item.idRequest == updatedItem.idRequest ? updatedItem : item,
    );
    comfortMyRequestsBloc.add(LoadedMyRequestsEvent(myRequests: myRequests));
  }

  void updateAll() {
    getMyRequests(page: 1);
  }
}
