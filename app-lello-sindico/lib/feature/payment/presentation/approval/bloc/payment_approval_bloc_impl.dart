import 'dart:math';

import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/foundation.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/account/domain/entity/account.dart';
import 'package:lello/feature/account/domain/use_case/list/list_accounts.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment_approval/register_payment_approval.dart';
import 'package:lello/feature/payment/presentation/approval/bloc/payment_approval_bloc.dart';
import 'package:lello/feature/payment/presentation/approval/bloc/payment_approval_event.dart';
import 'package:lello/feature/payment/presentation/approval/bloc/payment_approval_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/shared_features.dart';

class PaymentApprovalBlocImpl extends PaymentApprovalBloc {
  final RequestValidationCode requestValidationCode;
  final SessionBloc sessionBloc;
  final ListAccounts listAccounts;
  final RegisterPaymentApproval registerPaymentApproval;
  final LocalAuthentication auth = LocalAuthentication();
  bool canAuthenticate = false;

  PaymentApprovalBlocImpl(
      {required this.requestValidationCode,
      required this.sessionBloc,
      required this.listAccounts,
      required this.registerPaymentApproval})
      : super(PaymentApprovalLoadingState.empty()) {
    _beginLoad();
  }

  @override
  Stream<PaymentApprovalState> mapEventToState(
      PaymentApprovalEvent event) async* {
    if (event is PaymentApprovalRequestValidationCodeEvent) {
      yield* _mapRequestValidationCode(event);
    }
    if (event is PaymentApprovalSendEvent) yield* _mapSend(event);
    if (event is PaymentApprovalLoadDataEvent) yield* _mapLoad();
    if (event is PaymentApprovalRevertCodeEvent) {
      yield PaymentApprovalFormState(
          entity: state.entity, accounts: state.accounts);
    }
  }

  Stream<PaymentApprovalState> _mapLoad() async* {
    yield PaymentApprovalLoadingState(entity: state.entity);
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    canAuthenticate =
        (canAuthenticateWithBiometrics || await auth.isDeviceSupported()) &&
            availableBiometrics.isNotEmpty;

    List<Account> accounts = [];
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final selectedCondominium = sessionState.session?.selectedCondominium?.id;
      if (selectedCondominium != null) {
        final cache = await listAccounts.call(ListAccountsParms(
            condominiumId: selectedCondominium, origin: DataOrigin.local));
        if (cache is Success<List<Account>>) {
          accounts = cache.get();
          yield PaymentApprovalLoadingState(
              entity: state.entity, accounts: accounts);
        }
        final remote = await listAccounts.call(ListAccountsParms(
            condominiumId: selectedCondominium, origin: DataOrigin.remote));
        var resultYield = remote.fold(
            (err) => PaymentApprovalLoadingFailedState(
                entity: state.entity, accounts: [], error: err), (res) {
          String reference = sessionBloc
                  .state.session!.selectedCondominium?.reference
                  .toString() ??
              "";
          ManagerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsManager.aprovarPagamentoAcessar(),
              referenceValue: reference);
          return PaymentApprovalFormState(entity: state.entity, accounts: res);
        });

        yield resultYield;
      }
    }
  }

  Stream<PaymentApprovalState> _mapRequestValidationCode(
      PaymentApprovalRequestValidationCodeEvent event) async* {
    yield PaymentApprovalRequestingCodeState(
        entity: state.entity, accounts: state.accounts, source: event.source);
    if (event.source == CodeValidationSource.biometria) {
      try {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason:
                'Autenticação segura e rápida ao aprovar/ suspender e recusar pagamentos, garantindo que somente você possa aprovar os pagamentos');
        if (didAuthenticate) {
          beginSend();
          return;
        }
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
      }
      yield PaymentApprovalBiometricsFailureState(entity: state.entity);
    }

    var rng = Random();
    var randomCode = List.generate(4, (_) => rng.nextInt(10)).join();

    final request = CodeRequest(
        source: event.source,
        token: randomCode,
        value: event.value,
        origin: CodeValidationOrigin.other,
        cpf: sessionBloc.state.session?.me?.cpf);
    final result = await requestValidationCode.call(request);

    yield result.fold(
        (err) =>
            PaymentApprovalCodeFailedState(error: err, entity: state.entity),
        (res) => PaymentApprovalValidatingCodeState(
            entity: state.entity, request: res));
  }

  Stream<PaymentApprovalState> _mapSend(PaymentApprovalSendEvent event) async* {
    yield PaymentApprovalProgressState(
        entity: event.approval, accounts: state.accounts);

    final condominiumId = sessionBloc.state.session?.selectedCondominium?.id;

    final params = RegisterPaymentApprovalParam(
        condominiumId: condominiumId!, approval: event.approval);
    final result = await registerPaymentApproval.call(params);

    var resultYield = result.fold((err) {
      if (err is KnownFailure) {
        return PaymentApprovalRejectedState(
            entity: state.entity, accounts: state.accounts, error: err);
      } else {
        return PaymentApprovalFailedState(
            entity: state.entity, accounts: state.accounts, error: err);
      }
    }, (res) {
      String reference = sessionBloc
              .state.session!.selectedCondominium?.reference
              .toString() ??
          "";
      ManagerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.aprovarPagamentoFinalizado(),
          referenceValue: reference);
      return PaymentApprovalSucceededState(
          entity: res, accounts: state.accounts);
    });

    yield resultYield;
  }

  @override
  void beginRequestValidationCode(CodeValidationSource source) {
    final sessionState = sessionBloc.state;
    if (sessionState is SessionLoadedState) {
      final me = sessionState.session?.me;
      String? value;

      switch (source) {
        case CodeValidationSource.email:
          value = me?.email;
          break;
        case CodeValidationSource.phone:
          value = me?.phone;
          break;
        case CodeValidationSource.biometria:
          value = "";
          break;
      }
      if (value != null) {
        add(PaymentApprovalRequestValidationCodeEvent(
            source: source, value: value));
      }
    }
  }

  @override
  void beginSend() {
    if (state.entity != null) {
      add(PaymentApprovalSendEvent(approval: state.entity!));
    }
  }

  @override
  void setApproval(PaymentApproval approval) {
    state.entity = approval;
  }

  void _beginLoad() {
    add(PaymentApprovalLoadDataEvent());
  }

  @override
  bool revertCodeValidation() {
    if (state is PaymentApprovalValidatingCodeState ||
        state is PaymentApprovalRequestingCodeState ||
        state is PaymentApprovalCodeFailedState) {
      add(PaymentApprovalRevertCodeEvent());
      return false;
    }
    return true;
  }

  @override
  bool getCanAutenticate() {
    return canAuthenticate;
  }
}
