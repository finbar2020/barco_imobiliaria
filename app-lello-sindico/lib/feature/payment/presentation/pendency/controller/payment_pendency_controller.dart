import 'dart:developer';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_balance.dart';
import 'package:lello/feature/condominium/domain/use_case/load_condominium_balance/load_condominium_balance.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';
import 'package:lello/feature/payment/domain/entity/ledger_account.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
import 'package:lello/feature/payment/domain/entity/pendency_approval_action.dart';
import 'package:lello/feature/payment/domain/entity/send_token_data.dart';
import 'package:lello/feature/payment/domain/entity/send_token_request_entity.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_accounts.dart';
import 'package:lello/feature/payment/domain/entity/update_installment_lancamento_entity.dart';
import 'package:lello/feature/payment/domain/entity/update_installment_status_enum.dart';
import 'package:lello/feature/payment/domain/entity/update_transaction_installments_entity.dart';
import 'package:lello/feature/payment/domain/use_case/check_approval_profile/check_approval_profile.dart';
import 'package:lello/feature/payment/domain/use_case/check_token/check_token.dart';
import 'package:lello/feature/payment/domain/use_case/contas_pagar/contas_pagar.dart';
import 'package:lello/feature/payment/domain/use_case/get_ledger_accounts/get_ledger_accounts.dart';
import 'package:lello/feature/payment/domain/use_case/get_spupplier/get_spupplier.dart';
import 'package:lello/feature/payment/domain/use_case/intallments_in_approval/get_installments_in_approval.dart';
import 'package:lello/feature/payment/domain/use_case/send_token/send_token.dart';
import 'package:lello/feature/payment/domain/use_case/update_installments/update_installments.dart';
import 'package:lello/feature/payment/domain/use_case/update_ledger_account/update_ledger_account.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/check_token_bloc/check_token_bloc.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/check_token_bloc/check_token_event.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/details_bloc/pendency_bloc.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/details_bloc/pendency_event.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/list_bloc/payment_pendency_event.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/list_bloc/payment_pendency_list_bloc.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/validation_method_bloc/validation_method_bloc.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/validation_method_bloc/validation_method_event.dart';
import 'package:lello/feature/payment/presentation/pendency/page/validation_method/validation_method_page.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

import '../../../../session/presentation/bloc/session_bloc.dart';
import '../../../domain/entity/payment_list_filter.dart';
import '../../../domain/use_case/get_installments/get_installments.dart';
import '../../../domain/use_case/list_payment/list_payment.dart';
import '../../list/bloc/payment_list_bloc.dart';
import '../../list/bloc/payment_list_event.dart';

class PaymentPendencyController {
  final ListPayment listPaymentUsecase;
  final GetInstallments getInstallmentUsecase;
  final GetInstallmentsInApproval getInstallmentInApprovalUsecase;
  final GetSupplier getSupplierUseCase;
  final GetLedgerAccounts getLedgerAccountsUseCase;
  final SendToken sendTokenUseCase;
  final CheckToken checkTokenUseCase;
  final ContasPagar getContasPagarUseCase;
  final CheckApprovalProfile checkApprovalProfileUseCase;
  final UpdateInstallments updateInstallmentsUseCase;
  final UpdateLedgerAccount updateLedgerAccountUseCase;
  final LoadCondominiumBalance loadCondominiumBalanceUseCase;
  final SessionBloc sessionBloc;
  final PaymentPendencyListBloc listBloc;
  final PendencyBloc detailsBloc;
  final ValidationMethodBloc validationMethodBloc;
  final CheckTokenBloc checkTokenBloc;
  final PaymentListBloc paymentListBloc;

  PaymentPendencyController({
    required this.listPaymentUsecase,
    required this.getInstallmentUsecase,
    required this.getInstallmentInApprovalUsecase,
    required this.getSupplierUseCase,
    required this.getLedgerAccountsUseCase,
    required this.sendTokenUseCase,
    required this.checkTokenUseCase,
    required this.getContasPagarUseCase,
    required this.checkApprovalProfileUseCase,
    required this.updateInstallmentsUseCase,
    required this.updateLedgerAccountUseCase,
    required this.loadCondominiumBalanceUseCase,
    required this.sessionBloc,
    required this.listBloc,
    required this.detailsBloc,
    required this.validationMethodBloc,
    required this.checkTokenBloc,
    required this.paymentListBloc,
  });

  SupplierDataEntity? supplier;
  bool? canUserApprove = true;
  List<PaymentInstallmentInApprovalEntity>? installmentsInApproval;
  List<PaymentInstallmentInApprovalEntity>? allInstallmentsInApproval;
  List<ContasPagarEntity>? contasPagar;

  PaymentListFilter filter = PaymentListFilter();
  TextEditingController? installmentIdFilterController;
  String? numDoc;
  DateTime? startDate;
  DateTime? endDate;

  TextEditingController validationStepReasonController =
      TextEditingController();
  String? validateTokenSelectedOption;
  double? condominiumBalance;

  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  setFilter({
    DateTime? start,
    DateTime? end,
    String? doc,
  }) {
    startDate = start;
    endDate = end;
    numDoc = doc;
  }

  Future<CondominiumBalance?> loadCondominiumBalance() async {
    detailsBloc.add(PendencyBalanceLoadingEvent());
    final result = await loadCondominiumBalanceUseCase(
      CondominiumBalanceParam(
          id: condominiumId, reference: referenceId, origin: DataOrigin.remote),
    );
    return result.fold((err) {
      detailsBloc.add(PendencyBalanceFailedEvent(error: err));
      return null;
    }, (balance) {
      if (balance != null) {
        detailsBloc.add(PendencyBalanceSuccessEvent(balance: balance));
        condominiumBalance = balance.balance;
      }
      return balance;
    });
  }

  Future<SupplierLedgerAccountsEntity?> getLedgerAccounts(
      String supplierId) async {
    if (supplierId.isEmpty) {
      return null;
    }
    detailsBloc.add(PendencySupplierLoadingEvent());
    final result = await getLedgerAccountsUseCase(GetLedgerAccountsParam(
        condominiumId: condominiumId, supplierId: supplierId));
    return result.fold((err) {
      detailsBloc.add(PendencySupplierFailedEvent(error: err));
      return null;
    }, (ledger) {
      if (ledger != null) {
        detailsBloc
            .add(PendencySupplierSuccessEvent(supplierLedgerAccounts: ledger));
      }
      return ledger;
    });
  }

  Future<void> getContasPagar() async {
    paymentListBloc.add(PaymentContaPagarLoadingEvent());
    String formattedStartDate = startDate != null
        ? formatDate(startDate!)
        : formatDate(DateTime.now().firstDayOfMonth());
    String formattedEndDate = endDate != null
        ? formatDate(endDate!)
        : formatDate(DateTime.now().lastDayOfMonth());
    final result = await getContasPagarUseCase(
      ContasPagarParam(
        condominiumId: condominiumId,
        dataVencimentoDe:
            formattedStartDate.isNotEmpty ? formattedStartDate : '',
        dataVencimentoAte: formattedEndDate.isNotEmpty ? formattedEndDate : '',
      ),
    );
    return result.fold((err) {
      paymentListBloc.add(PaymentContaPagarFailureEvent(error: err));
      return null;
    }, (items) {
      if (items.isEmpty) {
        return paymentListBloc.add(PaymentContaPagarEmptyEvent());
      }
      if (numDoc != null) {
        items = items
            .where((element) =>
                element.installmentId?.toString().contains(numDoc!) ?? false)
            .toList();
      }
      contasPagar = items.where((element) {
        if (numDoc != null) {
          return element.installmentId?.toString().contains(numDoc!) ?? false;
        }
        return true;
      }).toList();
      paymentListBloc.add(PaymentContaPagarSuccessEvent(data: items));
    });
  }

  Future<void> getInstallmentsInApproval(
      {bool onlyInApprovalStatus = true, String installmentId = ''}) async {
    if (onlyInApprovalStatus) {
      canUserApprove = await checkApprovalProfile();
      if (canUserApprove == false) return;
    }
    allInstallmentsInApproval = [];
    listBloc.add(PaymentPendencyLoadingEvent());
    String formattedStartDate = startDate != null ? formatDate(startDate!) : '';
    String formattedEndDate = endDate != null ? formatDate(endDate!) : '';
    final result =
        await getInstallmentInApprovalUsecase(GetInstallmentsInApprovalParam(
      condominiumId: condominiumId,
      installmentId: installmentId,
      dataCadastroDe: formattedStartDate.isNotEmpty ? formattedStartDate : '',
      dataCadastroAte: formattedEndDate.isNotEmpty ? formattedEndDate : '',
      status: onlyInApprovalStatus ? "EMAPROVACAO" : null,
      filtrarAprovador: onlyInApprovalStatus ? "S" : "N",
    ));
    result.fold(
      (err) => listBloc.add(PaymentPendencyFailureEvent(error: err)),
      (items) {
        if (items.isEmpty) {
          return listBloc.add(PaymentPendencyEmptyEvent());
        }
        if (numDoc != null) {
          items = items
              .where((element) =>
                  element.lancamento?.transactionId
                      ?.toString()
                      .contains(numDoc!) ??
                  false)
              .toList();
        }
        installmentsInApproval = items.where((element) {
          if (onlyInApprovalStatus) {
            return element.lancamento?.approvers?.isNotEmpty == true;
          }
          return true;
        }).toList();

        allInstallmentsInApproval = items;
        listBloc.add(
          PaymentPendencySuccessEvent(
            data: items,
          ),
        );
      },
    );
  }

  Future<bool> inAppAuthUpdateInstallments({
    required bool isUserApproved,
    required UpdateInstallmentStatus status,
    required List<PaymentInstallmentInApprovalEntity> installments,
  }) async {
    checkTokenBloc.add(UpdateInstallmentsLoadingEvent());
    if (!isUserApproved) {
      checkTokenBloc.add(UpdateInstallmentsFailureEvent(failure: null));
      return false;
    }
    final result = await updateInstallmentsUseCase(
      UpdateInstallmentsParam(
        condominiumId: condominiumId,
        body: UpdateInstallmentLancamentoEntity(
          motivo: validationStepReasonController.text,
          status: updateInstallmentStatusToString(status),
          canal: 'APLICATIVO',
          lancamentos: installments
              .map((e) => UpdateTransactionInstallmentsEntity(
                    transactionId: e.lancamento?.transactionId,
                    installmentId: e.installmentId,
                  ))
              .toList(),
        ),
      ),
    );
    return result.fold((err) {
      checkTokenBloc.add(UpdateInstallmentsFailureEvent(failure: err));
      return false;
    }, (data) {
      checkTokenBloc.add(UpdateInstallmentsSuccessEvent(success: data));
      return data;
    });
  }

  Future<bool> checkTokenAndUpdateInstallments({
    required int value,
    required int tokenId,
    required bool isTokenValid,
    required UpdateInstallmentStatus status,
    required String channel,
    required List<PaymentInstallmentInApprovalEntity> installments,
  }) async {
    checkTokenBloc.add(UpdateInstallmentsLoadingEvent());
    channel == 'SMS' ? channel = 'TELEFONE' : channel = channel;
    if (!isTokenValid) {
      checkTokenBloc.add(UpdateInstallmentsFailureEvent(failure: null));
      return false;
    }
    final result = await updateInstallmentsUseCase(
      UpdateInstallmentsParam(
        condominiumId: condominiumId,
        body: UpdateInstallmentLancamentoEntity(
          motivo: validationStepReasonController.text,
          status: updateInstallmentStatusToString(status),
          canal: "APLICATIVO",
          lancamentos: installments
              .map((e) => UpdateTransactionInstallmentsEntity(
                    transactionId: e.lancamento?.transactionId,
                    installmentId: e.installmentId,
                  ))
              .toList(),
        ),
      ),
    );
    return result.fold((err) {
      checkTokenBloc.add(UpdateInstallmentsFailureEvent(failure: err));
      return false;
    }, (data) {
      checkTokenBloc.add(UpdateInstallmentsSuccessEvent(success: data));
      return true;
    });
  }

  Future<bool> onlyCheckToken({
    required int value,
    required int tokenId,
  }) async {
    checkTokenBloc.add(CheckTokenLoadingEvent());
    final result = await checkTokenUseCase(
      CheckTokenParam(
        condominiumId: condominiumId,
        tokenId: tokenId,
        value: value,
      ),
    );
    return result.fold((err) {
      checkTokenBloc.add(CheckTokenFailureEvent(failure: err));
      return false;
    }, (data) {
      checkTokenBloc.add(CheckTokenSuccessEvent(success: data));
      return true;
    });
  }

  void clearFilters({required bool isPendency}) {
    numDoc = null;
    startDate = null;
    endDate = null;

    isPendency ? getInstallmentsInApproval() : getContasPagar();
  }

  String formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  Future<bool> onInstallmentChange(
      int itemIndex, PaymentInstallmentInApprovalEntity item) async {
    if (item.lancamento?.ledgerAccount?.shortCode == null) {
      return false;
    }

    bool ledgerAccountUpdated = await updateLedgerAccount(
      item.lancamento!.transactionId ?? 0,
      item.lancamento!.ledgerAccount!.shortCode!,
    );

    if (ledgerAccountUpdated) {
      // Atualiza o item na lista local de forma mais robusta
      if (allInstallmentsInApproval != null &&
          allInstallmentsInApproval!.isNotEmpty) {
        if (itemIndex >= 0 && itemIndex < allInstallmentsInApproval!.length) {
          allInstallmentsInApproval![itemIndex] = item;

          if (installmentsInApproval != null &&
              installmentsInApproval!.isNotEmpty) {
            var correspondingIndex = installmentsInApproval!.indexWhere(
                (element) => element.installmentId == item.installmentId);
            if (correspondingIndex >= 0) {
              installmentsInApproval![correspondingIndex] = item;
            }
          }

          listBloc.add(
              PaymentPendencySuccessEvent(data: allInstallmentsInApproval!));

          Future.delayed(Duration(milliseconds: 500), () {
            getInstallmentsInApproval();
          });
        }
      }
    }
    return ledgerAccountUpdated;
  }

  Future getPaymentList() async {
    paymentListBloc.add(
      PaymentListLoadingEvent(),
    );
    final result = await listPaymentUsecase(
      ListPaymentParam(
        condominiumId: condominiumId,
        filter: filter,
      ),
    );
    result.fold(
      (err) => paymentListBloc.add(
        PaymentListFailureEvent(
          error: err,
        ),
      ),
      (items) {
        if (items.isEmpty) {
          return paymentListBloc.add(PaymentListEmptyEvent());
        } else {
          paymentListBloc.add(PaymentListSuccessEvent(data: items));
        }
      },
    );
  }

  navigateOnActionButtonPressed(
      BuildContext context,
      PendencyApprovalAction action,
      List<PaymentInstallmentInApprovalEntity> installments) {
    Navigator.pushNamed(
      context,
      ApplicationRoute.paymentPendencyValidateStep,
      arguments:
          ValidationMethodPageArgs(action: action, installments: installments),
    );
  }

  String? maskedEmail() {
    if (userEmail.isEmpty) {
      return null;
    }
    final parts = userEmail.split('@');
    if (parts.length != 2) {
      return null;
    }
    final localPart = parts[0];
    final domainPart = parts[1];
    final maskedLocalPart = localPart.replaceRange(
        3, localPart.length, '*' * (localPart.length - 3));
    return '$maskedLocalPart@$domainPart';
  }

  String? maskedPhone() {
    if (userPhone.isEmpty || userPhone.length < 11) {
      return null;
    }
    final areaCode = userPhone.substring(0, 2);
    final firstPart = userPhone.substring(2, 4);
    final maskedPart = '*' * 7;
    final lastPart = userPhone.substring(userPhone.length - 2);
    return '$areaCode $firstPart $maskedPart$lastPart';
  }

  Future<SendTokenData> sendTokenByMethod(
    String method,
  ) async {
    validationMethodBloc.add(ValidationMethodLoadingEvent());
    final result = await sendTokenUseCase(SendTokenParam(
        condominiumId: condominiumId,
        data: SendTokenRequestEntity(
          method: method,
          value: getValueByMethod(method),
        )));
    return result.fold((err) {
      validationMethodBloc.add(ValidationMethodFailureEvent(error: err));
      return SendTokenData(id: null);
    }, (data) {
      validationMethodBloc.add(ValidationMethodSuccessEvent(id: data.id));
      return data;
    });
  }

  Future<bool> checkToken(
    int value,
    int tokenId,
  ) async {
    checkTokenBloc.add(CheckTokenLoadingEvent());
    final result = await checkTokenUseCase(CheckTokenParam(
        condominiumId: condominiumId, tokenId: tokenId, value: value));
    return result.fold((err) {
      checkTokenBloc.add(CheckTokenFailureEvent(failure: err));
      return false;
    }, (data) {
      checkTokenBloc.add(CheckTokenSuccessEvent(success: data));
      return data;
    });
  }

  Future<bool> checkApprovalProfile() async {
    listBloc.add(PaymentCheckProfileLoadingEvent());
    if (sessionBloc
            .checkRback(ApplicationRbac.sindicoDespesasAprovacaoPendente) ||
        sessionBloc.checkRback(
            ApplicationRbac.sindicoDespesasAprovacaoPendenteWrite)) {
      listBloc.add(PaymentCheckProfileSuccessEvent(success: true));
      canUserApprove = true;
      return true;
    }
    final result = await checkApprovalProfileUseCase(
        CheckApprovalProfileParam(condominiumId: condominiumId));
    return result.fold((err) {
      listBloc.add(PaymentCheckProfileFailureEvent(error: err));
      return false;
    }, (data) {
      listBloc.add(PaymentCheckProfileSuccessEvent(success: data));
      return data;
    });
  }

  Future<bool> updateLedgerAccount(
    int idLancamento,
    int idContaContabil,
  ) async {
    detailsBloc.add(UpdateLedgerAccountLoadingEvent());
    final result = await updateLedgerAccountUseCase(
      UpdateLedgerAccountParam(
        condominiumId: condominiumId,
        idLancamento: idLancamento,
        idContaContabil: idContaContabil,
      ),
    );
    return result.fold((err) {
      detailsBloc.add(UpdateLedgerAccountFailureEvent(error: err));
      return false;
    }, (data) {
      detailsBloc.add(UpdateLedgerAccountSuccessEvent(success: data));
      return data;
    });
  }

  String? getValueByMethod(
    String method,
  ) {
    switch (method) {
      case 'EMAIL':
        return userEmail;
      case 'WHATSAPP':
        return userPhone;
      case 'SMS':
        return userPhone;
      default:
        return null;
    }
  }

  String get condominiumId =>
      sessionBloc.state.session!.selectedCondominium!.id;

  String get referenceId => sessionBloc.state.session!.selectedCondominium!.id;

  String get userEmail => sessionBloc.state.session!.me!.email!;

  String get userPhone => sessionBloc.state.session!.me!.phone!;
}
