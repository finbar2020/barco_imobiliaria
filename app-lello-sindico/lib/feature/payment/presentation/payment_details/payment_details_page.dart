import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

import '../../../../core/dependency/application_container.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entity/payment_installment_in_approval.dart';

class PaymentDetailsPage extends StatefulWidget {
  const PaymentDetailsPage({super.key});

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  PaymentInstallmentInApprovalEntity? arguments;

  Environment env = ApplicationContainer.instance().resolve<Environment>();
  final SessionBloc sessionBloc =
      ApplicationContainer.instance().resolve<SessionBloc>();
  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    arguments = ModalRoute.of(context)!.settings.arguments
        as PaymentInstallmentInApprovalEntity?;
    return Scaffold(
      backgroundColor: LelloTheme.palleteOf(theme).backgroundDark(),
      appBar: PrimaryAppBar(
        iconColor: theme.primaryColor,
        theme: theme,
        onBackArrowPressed: () {
          if (mounted && Navigator.canPop(context)) {
            Navigator.maybePop(context, true);
          }
        },
        title: getString(context, 'payment_detail_title'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: Dimens.spacing,
                horizontal: Dimens.spacingMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    getString(context, 'payment_transaction_data'),
                    style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).textLight(),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  _buildTile(
                    theme,
                    getString(context, 'payment_inclusion_date'),
                    arguments?.lancamento?.registrationDate != null
                        ? arguments!.lancamento!.registrationDate!
                        : getString(context, 'payment_not_informed'),
                    getString(context, 'payment_transaction_number'),
                    arguments?.lancamento?.transactionId?.toString() ??
                        getString(context, 'payment_not_informed'),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  _buildTile(
                      theme,
                      getString(context, 'payment_supplier'),
                      arguments?.lancamento?.supplier?.tradeName ??
                          getString(context, 'payment_not_informed'),
                      '',
                      ''),
                  SizedBox(height: Dimens.spacingMedium),
                  _buildTile(
                      theme,
                      getString(context, 'payment_cpf_cnpj'),
                      arguments?.lancamento?.supplier?.supplierDocument
                              ?.formatCpfCnpj() ??
                          getString(context, 'payment_not_informed'),
                      getString(context, 'payment_document_number'),
                      arguments?.lancamento?.documentNumber ??
                          getString(context, 'payment_not_informed')),
                  SizedBox(height: Dimens.spacingMedium),
                  _buildTile(
                      theme,
                      getString(context, 'payment_history'),
                      arguments?.lancamento?.ledgerAccount?.shortCode != null
                          ? "${arguments?.lancamento!.ledgerAccount!.shortCode} - ${arguments?.lancamento!.ledgerAccount!.name?.toUpperCase() ?? getString(context, 'payment_not_informed')}"
                          : arguments?.lancamento?.ledgerAccount?.name
                                  ?.toUpperCase() ??
                              getString(context, 'payment_not_informed'),
                      getString(context, 'payment_document_number'),
                      arguments?.lancamento?.documentNumber ??
                          getString(context, 'payment_not_informed')),
                ],
              ),
            ),
            const Divider(
              color: Color(0xFF2D2D2D),
              height: 0.5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: Dimens.spacing,
                horizontal: Dimens.spacingMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    getString(context, 'payment_data'),
                    style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).textLight(),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  _buildTile(
                    theme,
                    getString(context, 'payment_current_installment'),
                    arguments?.installmentId?.toString() != null
                        ? arguments!.installmentId!.toString()
                        : getString(context, 'payment_not_informed'),
                    getString(context, 'payment_total_value'),
                    arguments?.lancamento?.totalValue != null
                        ? arguments!.lancamento!.totalValue!.obterReal()
                        : getString(context, 'payment_not_informed'),
                    LelloTheme.palleteOf(theme).primary(),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  PrimaryButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          color: LelloTheme.palleteOf(theme).backgroundDark(),
                        ),
                        SizedBox(width: Dimens.spacingSmall),
                        Text(
                          getString(context, 'payment_view_document'),
                          style: LelloTextStyles.button(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).backgroundDark(),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      if (!mounted ||
                          arguments?.lancamento?.transactionId == null) return;

                      final route = MaterialPageRoute(
                        builder: (ctx) => PDFScreen(
                          url:
                              "${env.apiUrl}/condominiums/${sessionBloc.state.session!.selectedCondominium!.id}/payments/${arguments!.lancamento!.transactionId}/download",
                          fileName:
                              getString(context, 'payment_transaction_file'),
                          canDownload: true,
                          title: getString(context, 'payment_pdf'),
                          headers: authenticationStore.getCustomHeader(),
                        ),
                      );

                      Navigator.of(context).push(route).then((_) {
                        if (mounted) setState(() {});
                      });
                    },
                  )
                ],
              ),
            ),
            if (arguments?.lancamento?.approvers?.isNotEmpty == true)
              const Divider(
                color: Color(0xFF2D2D2D),
                height: 0.5,
              ),
            if (arguments?.lancamento?.approvers?.isNotEmpty == true)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Dimens.spacing,
                  horizontal: Dimens.spacingMedium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      getString(context, 'payment_approvers'),
                      style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).textLight(),
                      ),
                    ),
                    ...arguments?.lancamento?.approvers?.map((approver) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              approver.name ??
                                  getString(context, 'payment_not_informed'),
                              style: LelloTextStyles.bodyBold(theme),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  approver.channel != null
                                      ? "${approver.status} no ${approver.channel}"
                                      : getString(
                                          context, 'payment_not_informed'),
                                  style:
                                      LelloTextStyles.caption(theme)?.copyWith(
                                    color:
                                        LelloTheme.palleteOf(theme).textLight(),
                                  ),
                                ),
                                SizedBox(width: Dimens.spacingXSmall),
                                Text(
                                  approver.approvalTime != null &&
                                          approver.approvalDate != null
                                      ? '${getString(context, 'payment_at_time')} ${approver.approvalTime}, ${getString(context, 'payment_day')} ${approver.approvalDate}'
                                      : getString(
                                          context, 'payment_not_informed'),
                                  style:
                                      LelloTextStyles.caption(theme)?.copyWith(
                                    color:
                                        LelloTheme.palleteOf(theme).textLight(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }) ??
                        const [],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(ThemeData theme, String label1, String value1,
      String label2, String value2,
      [Color? value2Color]) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      runSpacing: Dimens.spacingMedium,
      spacing: Dimens.spacingMedium,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label1,
              overflow: TextOverflow.ellipsis,
              style: LelloTextStyles.body(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).textLight(),
              ),
            ),
            Text(
              value1,
              style: LelloTextStyles.bodyBold(theme),
            ),
          ],
        ),
        if (label2.isNotEmpty && value2.isNotEmpty)
          SizedBox(width: Dimens.spacingLarge),
        if (label2.isNotEmpty && value2.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).textLight(),
                ),
              ),
              Text(
                value2,
                style: LelloTextStyles.bodyBold(theme)?.copyWith(
                  color: value2Color,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
