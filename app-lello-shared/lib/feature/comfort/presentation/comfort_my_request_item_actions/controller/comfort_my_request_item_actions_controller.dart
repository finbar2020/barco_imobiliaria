import 'package:essentials/enum/app_origin_enum.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_message_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_utils.dart';
import 'package:shared_features/feature/comfort/domain/use_case/cancel_request/cancel_request.dart';
import 'package:shared_features/feature/comfort/domain/use_case/resend_request/resend_request.dart';
import 'package:shared_features/feature/comfort/domain/use_case/update_request/update_request.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/bloc/comfort_my_request_item_actions_bloc.dart';

class ComfortMyRequestItemActionsController {
  final ResendRequestUseCase resendRequestUseCase;
  final CancelRequestUseCase cancelRequestUseCase;
  final UpdateRequestUseCase updateRequestUseCase;
  final ComfortMyRequestItemActionsBloc bloc;
  final AppOriginEnum appOriginEnum;
  final sessionBloc;

  ComfortMyRequestItemActionsController({
    required this.resendRequestUseCase,
    required this.cancelRequestUseCase,
    required this.updateRequestUseCase,
    required this.bloc,
    required this.sessionBloc,
    required this.appOriginEnum,
  });

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

  Future<void> sendMessage({
    required ComfortCompletedRequest request,
    required ComfortRequestMessageType subject,
    required String message,
  }) async {
    var state = bloc.state;

    if (state is ComfortMyRequestItemActionsLoadedState) {
      bloc.add(ComfortMyRequestItemActionsLoadingEvent(
          state.request, ComfortMyRequestItemActions.message));

      request.messageType = subject;
      request.comment = message;

      String condominiumId =
          ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
      final response = await updateRequestUseCase(
        UpdateRequestParam(
            condominiumId: condominiumId,
            requestId: request.idRequest,
            request: request),
      );

      response.fold(
        (error) {
          return bloc.add(
            ComfortMyRequestItemActionsErrorEvent(
                request: state.request,
                action: ComfortMyRequestItemActions.message,
                errorMessageKey: 'comfort_get_my_requests_error',
                errorCode: error.code.toString(),
                errorDescription: ""),
          );
        },
        (response) {
          response.partner.partnerIntro.partnerImageLink =
              "/condominiums/$condominiumId/comfort/${response.idPartner}/image/${response.imageHash}";
          return bloc.add(ComfortMyRequestItemActionsSuccessEvent(
              response, ComfortMyRequestItemActions.message));
        },
      );
    }
  }

  Future<void> resendRequest({required String requestId}) async {
    var state = bloc.state;

    if (state is ComfortMyRequestItemActionsLoadedState) {
      bloc.add(ComfortMyRequestItemActionsLoadingEvent(
          state.request, ComfortMyRequestItemActions.resend));

      String condominiumId =
          ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
      final response = await resendRequestUseCase(
        ResendRequestParam(condominiumId: condominiumId, requestId: requestId),
      );

      response.fold(
        (error) {
          return bloc.add(
            ComfortMyRequestItemActionsErrorEvent(
                request: state.request,
                action: ComfortMyRequestItemActions.resend,
                errorMessageKey: 'comfort_get_my_requests_error',
                errorCode: error.code.toString(),
                errorDescription: ""),
          );
        },
        (response) {
          response.partner.partnerIntro.partnerImageLink =
              "/condominiums/$condominiumId/comfort/${response.idPartner}/image/${response.imageHash}";
          return bloc.add(ComfortMyRequestItemActionsSuccessEvent(
              response, ComfortMyRequestItemActions.resend));
        },
      );
    }
  }

  Future<void> cancelRequest(String requestId) async {
    var state = bloc.state;

    if (state is ComfortMyRequestItemActionsLoadedState) {
      bloc.add(ComfortMyRequestItemActionsLoadingEvent(
          state.request, ComfortMyRequestItemActions.cancel));

      String condominiumId =
          ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
      final response = await cancelRequestUseCase(
        CancelRequestParam(condominiumId: condominiumId, requestId: requestId),
      );

      response.fold(
        (error) {
          return bloc.add(
            ComfortMyRequestItemActionsErrorEvent(
                request: state.request,
                action: ComfortMyRequestItemActions.cancel,
                errorMessageKey: 'comfort_get_my_requests_error',
                errorCode: error.code.toString(),
                errorDescription: ""),
          );
        },
        (response) {
          response.partner.partnerIntro.partnerImageLink =
              "/condominiums/$condominiumId/comfort/${response.idPartner}/image/${response.imageHash}";
          return bloc.add(ComfortMyRequestItemActionsSuccessEvent(
              response, ComfortMyRequestItemActions.cancel));
        },
      );
    }
  }

  Future<void> rateRequest(
      {required ComfortCompletedRequest request,
      required double rating}) async {
    var state = bloc.state;
    var prevRate = request.rating;

    if (state is ComfortMyRequestItemActionsLoadedState) {
      bloc.add(ComfortMyRequestItemActionsLoadingEvent(
          state.request, ComfortMyRequestItemActions.rate));

      request.rating = rating;

      String condominiumId =
          ComfortUtils.getCondoIdByProject(appOriginEnum, sessionBloc);
      final response = await updateRequestUseCase(
        UpdateRequestParam(
            condominiumId: condominiumId,
            requestId: request.idRequest,
            request: request),
      );

      response.fold(
        (error) {
          request.rating = prevRate;
          return bloc.add(
            ComfortMyRequestItemActionsErrorEvent(
                request: state.request,
                action: ComfortMyRequestItemActions.rate,
                errorMessageKey: 'comfort_get_my_requests_error',
                errorCode: error.code.toString(),
                errorDescription: ""),
          );
        },
        (response) {
          response.partner.partnerIntro.partnerImageLink =
              "/condominiums/$condominiumId/comfort/${response.idPartner}/image/${response.imageHash}";
          return bloc.add(ComfortMyRequestItemActionsSuccessEvent(
              response, ComfortMyRequestItemActions.rate));
        },
      );
    }
  }

  void setRequest({required ComfortCompletedRequest request}) {
    bloc.add(ComfortMyRequestItemActionsLoadedEvent(request));
  }
}

enum ComfortMyRequestItemActions { resend, cancel, message, rate }
