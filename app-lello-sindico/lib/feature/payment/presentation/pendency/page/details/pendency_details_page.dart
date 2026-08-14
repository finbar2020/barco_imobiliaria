import 'dart:developer';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/condominium/presentation/widget/condominium_balance_widget.dart';
import 'package:lello/feature/payment/domain/entity/ledger_account.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_ledger_account.dart';
import 'package:lello/feature/payment/domain/entity/pendency_approval_action.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/details_bloc/pendency_event.dart';
import 'package:lello/feature/payment/presentation/pendency/bloc/details_bloc/pendency_state.dart';
import 'package:lello/feature/payment/presentation/pendency/controller/payment_pendency_controller.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/condominium_balance_widget.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/edit_ledger_account_dialog.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/info_banner_widget.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/no_ledger_account_dialog.dart';
import 'package:lello/feature/payment/presentation/widget/payment_pendency_info_bottomsheet.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class PendencyDetailsPageArgs {
  bool infoBannerVisible;
  int index;
  PaymentInstallmentInApprovalEntity payment;
  PendencyDetailsPageArgs(
      {required this.index,
      required this.payment,
      required this.infoBannerVisible});
}

class PendencyDetailsPage extends StatefulWidget {
  const PendencyDetailsPage({super.key});

  @override
  State<PendencyDetailsPage> createState() => _PendencyDetailsPageState();
}

class _PendencyDetailsPageState extends State<PendencyDetailsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller =
      ApplicationContainer.instance().resolve<PaymentPendencyController>();
  final SessionBloc sessionBloc =
      ApplicationContainer.instance().resolve<SessionBloc>();
  PendencyDetailsPageArgs? arguments;
  PaymentInstallmentInApprovalEntity? payment;
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.detailsBloc.add(PendencySupplierResetEvent());
  }

  setPaymentValue(PaymentInstallmentInApprovalEntity payment) {
    this.payment = payment;
  }

  Future<void> _handleLedgerAccountChange(
      LedgerAccountEntity? ledgerAccount) async {
    if (ledgerAccount == null) return;
    final previousName = payment?.lancamento?.ledgerAccount?.name;
    final previousShortCode = payment?.lancamento?.ledgerAccount?.shortCode;

    if (payment?.lancamento?.ledgerAccount == null) {
      setState(() {
        payment!.lancamento!.ledgerAccount = PaymentInstallmentLedgerAccount(
          name: ledgerAccount.name,
          shortCode: ledgerAccount.shortCode,
        );
      });
    } else {
      setState(() {
        payment!.lancamento!.ledgerAccount!
          ..name = ledgerAccount.name
          ..shortCode = ledgerAccount.shortCode;
      });
    }

    final didChange =
        await controller.onInstallmentChange(arguments!.index, payment!);

    if (!didChange) {
      if (previousName == null && previousShortCode == null) {
        setState(() {
          payment!.lancamento!.ledgerAccount = null;
        });
      } else {
        setState(() {
          payment!.lancamento!.ledgerAccount!
            ..name = previousName
            ..shortCode = previousShortCode;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatCurrency = NumberFormat.currency(symbol: "R\$");
    arguments =
        ModalRoute.of(context)!.settings.arguments as PendencyDetailsPageArgs?;
    setPaymentValue(arguments!.payment);
    return Theme(
        data: theme,
        child: BlocConsumer(
          bloc: controller.detailsBloc,
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              backgroundColor: LelloTheme.palleteOf(theme).background(),
              key: scaffoldKey,
              appBar: PrimaryAppBar(
                iconColor: theme.primaryColor,
                theme: theme,
                title: getString(context, "payment_pendency_detail_page_title"),
                onBackArrowPressed: () {
                  Navigator.pop(context);
                },
                actions: [
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.help_outline),
                    color: Colors.white,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) {
                          return SafeArea(
                              child: PaymentPendencyInfoBottomsheet());
                        },
                      );
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Visibility(
                      visible: arguments!.infoBannerVisible,
                      child: InfoBannerWidget(
                        onClose: () {
                          setState(() {
                            arguments!.infoBannerVisible = false;
                          });
                        },
                        theme: theme,
                      ),
                    ),
                    SizedBox(height: Dimens.spacing),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          getString(context,
                              "payment_pendency_detail_page_body_title"),
                          style: LelloTextStyles.bodyBold(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).grey(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getString(context,
                                    "payment_pendency_detail_page_inclusion_date"),
                                style: LelloTextStyles.body(theme)?.copyWith(
                                  color: LelloTheme.palleteOf(theme).grey(),
                                ),
                              ),
                              Text(
                                arguments!
                                        .payment.lancamento!.registrationDate ??
                                    "Não informado",
                                style: LelloTextStyles.bodyBold(theme)
                                    ?.copyWith(
                                        color:
                                            LelloTheme.palleteOf(theme).text()),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getString(context,
                                    "payment_pendency_detail_page_payment_number"),
                                style: LelloTextStyles.body(theme)?.copyWith(
                                  color: LelloTheme.palleteOf(theme).grey(),
                                ),
                              ),
                              Text(
                                arguments!.payment.lancamento!.transactionId
                                    .toString(),
                                style: LelloTextStyles.bodyBold(theme)
                                    ?.copyWith(
                                        color:
                                            LelloTheme.palleteOf(theme).text()),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getString(context,
                                      "payment_pendency_detail_page_payment_supplier"),
                                  style: LelloTextStyles.body(theme)?.copyWith(
                                    color: LelloTheme.palleteOf(theme).grey(),
                                  ),
                                ),
                                Text(
                                  arguments!.payment.lancamento?.supplier
                                          ?.tradeName
                                          ?.toUpperCase() ??
                                      arguments!.payment.lancamento?.supplier
                                          ?.legalName ??
                                      "Fornecedor não informado",
                                  style: LelloTextStyles.bodyBold(theme),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getString(context,
                                      "payment_pendency_detail_page_payment_value"),
                                  style: LelloTextStyles.body(theme)?.copyWith(
                                    color: LelloTheme.palleteOf(theme).grey(),
                                  ),
                                ),
                                Text(
                                    formatCurrency.format(arguments!
                                            .payment.lancamento!.netValue ??
                                        0),
                                    style: LelloTextStyles.bodyBold(theme)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getString(context,
                                      "payment_pendency_detail_page_payment_total_value"),
                                  style: LelloTextStyles.body(theme)?.copyWith(
                                    color: LelloTheme.palleteOf(theme).grey(),
                                  ),
                                ),
                                Text(
                                    formatCurrency.format(arguments!
                                            .payment.lancamento!.totalValue ??
                                        0),
                                    style: LelloTextStyles.bodyBold(theme)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getString(context,
                                      "payment_pendency_detail_page_payment_installment"),
                                  style: LelloTextStyles.body(theme)?.copyWith(
                                    color: LelloTheme.palleteOf(theme).grey(),
                                  ),
                                ),
                                Text(
                                  arguments!.payment.installmentId
                                          ?.toString() ??
                                      "Não informado",
                                  style:
                                      LelloTextStyles.bodyBold(theme)?.copyWith(
                                    color: LelloTheme.palleteOf(theme).text(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getString(context,
                                      "payment_pendency_detail_page_payment_due_date"),
                                  style: LelloTextStyles.body(theme)?.copyWith(
                                    color: LelloTheme.palleteOf(theme).grey(),
                                  ),
                                ),
                                Text(
                                  arguments!.payment.dueDate ?? "Não informado",
                                  style:
                                      LelloTextStyles.bodyBold(theme)?.copyWith(
                                    color: LelloTheme.palleteOf(theme).text(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Divider(
                        color: LelloTheme.palleteOf(theme).grey(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              getString(context,
                                  "payment_pendency_detail_page_payment_ledger_account"),
                              style: LelloTextStyles.bodyBold(theme)!.copyWith(
                                color: LelloTheme.palleteOf(theme).grey(),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                arguments!.payment.lancamento?.ledgerAccount
                                            ?.shortCode !=
                                        null
                                    ? "${arguments!.payment.lancamento!.ledgerAccount!.shortCode} - ${arguments!.payment.lancamento!.ledgerAccount!.name?.toUpperCase() ?? "Não informado"}"
                                    : arguments!.payment.lancamento
                                            ?.ledgerAccount?.name
                                            ?.toUpperCase() ??
                                        "Não informado",
                                style: LelloTextStyles.bodyBold(theme)
                                    ?.copyWith(
                                        color:
                                            LelloTheme.palleteOf(theme).text()),
                              ),
                              BlocConsumer(
                                bloc: controller.detailsBloc,
                                listener: (context, state) {
                                  if (state is PendencySupplierSuccessState) {
                                    EditLedgerAccountDialog.show(
                                        context: context,
                                        supplierLedgerAccounts:
                                            state.supplierLedgerAccounts,
                                        ledgerAccount: arguments!
                                            .payment.lancamento?.ledgerAccount,
                                        onChange: (ledgerAccount) =>
                                            _handleLedgerAccountChange(
                                                ledgerAccount));
                                  }
                                },
                                builder: (context, state) {
                                  if (state is PendencySupplierLoadingState ||
                                      state
                                          is UpdateLedgerAccountLoadingState) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return arguments!.payment.lancamento
                                              ?.ledgerAccount !=
                                          null
                                      ? PrimaryButton(
                                          onPressed: () async {
                                            await controller.getLedgerAccounts(
                                                arguments!.payment.lancamento!
                                                    .supplier!.supplierId
                                                    .toString());
                                          },
                                          text: getString(context,
                                              "payment_pendency_detail_page_edit_ledger_account"),
                                          width: 100,
                                          height: 20,
                                        )
                                      : TextButton(
                                          onPressed: () async {
                                            await controller.getLedgerAccounts(
                                                arguments!.payment.lancamento!
                                                    .supplier!.supplierId
                                                    .toString());
                                          },
                                          child: Text(
                                            getString(context,
                                                "payment_pendency_detail_page_add_ledger_account"),
                                            style:
                                                LelloTextStyles.bodyBold(theme)!
                                                    .copyWith(
                                              color: LelloTheme.palleteOf(theme)
                                                  .buttonSystem(),
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  LelloTheme.palleteOf(theme)
                                                      .buttonSystem(),
                                            ),
                                          ),
                                        );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Divider(
                        color: LelloTheme.palleteOf(theme).grey(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              getString(context,
                                  "payment_pendency_detail_page_payment_approvers"),
                              style: LelloTextStyles.bodyBold(theme)!.copyWith(
                                color: LelloTheme.palleteOf(theme).grey(),
                              ),
                            ),
                          ),
                          SizedBox(height: Dimens.spacingSmall),
                          Column(
                            children: (arguments
                                        ?.payment.lancamento?.approvers ??
                                    [])
                                .map((e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            e.name ?? "Não informado",
                                            style: LelloTextStyles.bodyBold(
                                                    theme)
                                                ?.copyWith(
                                                    color: LelloTheme.palleteOf(
                                                            theme)
                                                        .text()),
                                          ),
                                          Text(
                                            e.status ?? "Não informado",
                                            style: LelloTextStyles.bodyBold(
                                                    theme)
                                                ?.copyWith(
                                                    color: LelloTheme.palleteOf(
                                                            theme)
                                                        .text()),
                                          ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: PrimaryButton(
                              onPressed: () async {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return PDFScreen(
                                      url:
                                          "${env.apiUrl}/condominiums/${sessionBloc.state.session!.selectedCondominium!.id}/payments/${arguments!.payment.lancamento!.transactionId}/download",
                                      fileName: "LANÇAMENTO",
                                      canDownload: true,
                                      title: "PDF",
                                      headers:
                                          authenticationStore.getCustomHeader(),
                                    );
                                  },
                                ));
                              },
                              text: getString(context,
                                  "payment_pendency_detail_page_payment_visualize_documents"),
                              width: double.infinity,
                              height: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/ic_eye.svg",
                                  ),
                                  SizedBox(width: Dimens.spacingSmall),
                                  Text(
                                    getString(context,
                                        "payment_pendency_detail_page_payment_visualize_documents"),
                                    style: LelloTextStyles.bodyBold(theme)
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: Dimens.spacingXSmall),
                          TextButton.icon(
                            onPressed: () {
                              Launch.whatsApp(
                                  context,
                                  sessionBloc.state.session?.consultantEntity
                                          ?.number ??
                                      FlavorConfig
                                          .config.supportSindicoWhatsAppNumber,
                                  message:
                                      getString(context, "would_speack_lello"));
                            },
                            icon: Icon(Icons.phone,
                                color:
                                    LelloTheme.palleteOf(theme).buttonSystem()),
                            label: Text(
                              getString(context,
                                  "payment_pendency_detail_page_payment_speak_to_your_consultant"),
                              style: TextStyle(
                                color:
                                    LelloTheme.palleteOf(theme).buttonSystem(),
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    LelloTheme.palleteOf(theme).buttonSystem(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionButton('assets/ic_refuse.svg',
                            PendencyApprovalAction.reject),
                        SizedBox(width: Dimens.spacingSmall),
                        _buildActionButton('assets/ic_suspend.svg',
                            PendencyApprovalAction.suspend),
                        SizedBox(width: Dimens.spacingSmall),
                        _buildActionButton('assets/ic_approve.svg',
                            PendencyApprovalAction.approve),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget _buildActionButton(String assetPath, PendencyApprovalAction action) {
    return IconButton(
      icon: SvgPicture.asset(assetPath, height: 75, width: 75),
      onPressed: () {
        if (arguments?.payment.lancamento?.ledgerAccount == null) {
          showDialog(
              context: context,
              builder: (context) => NoLedgerAccountDialog(
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onConfirm: () {
                      Navigator.pop(context);
                      controller.navigateOnActionButtonPressed(
                          context, action, [arguments!.payment]);
                    },
                  ));
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return BalanceApprovalModal(
                  balance: controller.condominiumBalance,
                  action: action,
                  onConfirm: () {
                    Navigator.pop(context);
                    controller.navigateOnActionButtonPressed(
                        context, action, [arguments!.payment]);
                  },
                  onCancel: () {
                    Navigator.pop(context);
                  },
                );
              });
        }
      },
    );
  }
}
