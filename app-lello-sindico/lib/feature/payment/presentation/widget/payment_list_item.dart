import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';

class PaymentListItem extends StatelessWidget {
  final PaymentInstallmentInApprovalEntity payment;
  final bool showFileButton;
  final Function(String)? onPressed;
  final dateFormat = DateFormat.yMd();

  PaymentListItem({
    super.key,
    required this.payment,
    this.onPressed,
    this.showFileButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(symbol: "R\$");
    final theme = Theme.of(context);

    return Material(
      color: LelloTheme.palleteOf(theme).background(),
      child: InkWell(
        onTap: () {
          if (onPressed != null) {
            String transactionId =
                payment.lancamento?.transactionId?.toString() ?? "";
            if (transactionId.isNotEmpty) {
              onPressed!(transactionId);
            }
          }
        },
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                  vertical: Dimens.spacing, horizontal: Dimens.spacingMedium),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          _buildRichText(
                            theme,
                            "Lançamento: ",
                            payment.lancamento?.transactionId?.toString() ??
                                "Não informado",
                          ),
                        ],
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          _buildRichText(
                            theme,
                            "",
                            payment.lancamento?.status?.toString() ??
                                "Não informado",
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  Text(
                    _getSupplierName(),
                    style: LelloTextStyles.bodyBold(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).grey(),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  _buildRichText(
                    theme,
                    "Conta Contábil: ",
                    payment.lancamento?.ledgerAccount?.shortCode != null
                        ? "${payment.lancamento!.ledgerAccount!.shortCode} - ${payment.lancamento!.ledgerAccount!.name?.toUpperCase() ?? "Não informado"}"
                        : payment.lancamento?.ledgerAccount?.name
                                ?.toUpperCase() ??
                            "Não informado",
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  Row(
                    children: [
                      Expanded(
                        child: _buildRichText(
                          theme,
                          "Valor: ",
                          formatCurrency
                              .format(payment.lancamento?.netValue ?? 0),
                          color: LelloTheme.palleteOf(theme).primary(),
                        ),
                      ),
                      SizedBox(width: Dimens.spacingSmall),
                      Expanded(
                        child: _buildRichText(
                          theme,
                          "Parcela: ",
                          payment.installmentId?.toString() ?? "Não informado",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  Wrap(
                    children: [
                      _buildRichText(
                        theme,
                        "Data de inclusão: ",
                        payment.lancamento?.registrationDate != null
                            ? payment.lancamento!.registrationDate!
                            : "Não informado",
                      ),
                      SizedBox(width: Dimens.spacingMedium),
                      _buildRichText(
                        theme,
                        "Venc: ",
                        payment.dueDate != null
                            ? payment.dueDate!
                            : "Não informado",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(ThemeData theme, String label, String value,
      {Color? color}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: LelloTextStyles.body(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).grey(),
            ),
          ),
          TextSpan(
            text: value,
            style: LelloTextStyles.bodyBold(theme)?.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  String _getSupplierName() {
    return payment.lancamento?.supplier?.tradeName?.toUpperCase() ??
        payment.lancamento?.supplier?.legalName ??
        "Fornecedor não informado";
  }

  String capitalize(String? s) {
    if (s == null || s.isEmpty) return "Não informado";
    return s[0].toUpperCase() + s.substring(1);
  }
}
