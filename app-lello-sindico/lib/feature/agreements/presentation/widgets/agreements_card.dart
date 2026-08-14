import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_status.dart';

class AgreementsCard extends StatelessWidget {
  final Agreement agreement;
  final VoidCallback onPressed;
  const AgreementsCard(
      {Key? key, required this.agreement, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacing),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 8,
          backgroundColor: LelloTheme.palleteOf(theme).background(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: cardBody(context),
      ),
    );
  }

  Widget cardBody(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: LelloTheme.palleteOf(theme).background(),
      child: Row(
        children: [
          Expanded(
            flex: 30,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.spacing),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agreement.unitAndNameDescription,
                    style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: Dimens.spacingMedium),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildColumn(
                              theme,
                              3,
                              getString(context, "agreements_payment"),
                              getString(
                                  context, agreement.getPaymentMethodKey)),
                          _buildColumn(
                              theme,
                              4,
                              getString(context, "agreements_value_with_fine"),
                              agreement.getTotalValueFormatted),
                        ]),
                  ),
                  RichText(
                    text: TextSpan(
                      style: LelloTextStyles.body(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                      children: [
                        TextSpan(
                          text: (agreement.status == AgreementStatus.pending ||
                                  agreement.status == AgreementStatus.rejected)
                              ? getString(
                                  context, "agreements_proposal_made_in")
                              : getString(context, "agreements_date"),
                          style: LelloTextStyles.bodyBold(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).text(),
                          ),
                        ),
                        TextSpan(
                            text:
                                (agreement.status == AgreementStatus.pending ||
                                        agreement.status ==
                                            AgreementStatus.rejected)
                                    ? " ${agreement.getProposalDate}"
                                    : " ${agreement.getApprovalDate}")
                      ],
                    ),
                  ),
                  _buildStatus(theme, context),
                ],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: SvgPicture.asset(
              "assets/ic_arrow_right.svg",
              height: 20.0,
              color: LelloTheme.palleteOf(theme).overlay(),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildColumn(
      ThemeData theme, int flex, String topText, String bottomText) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topText,
            style: LelloTextStyles.bodyBold(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).text(),
            ),
          ),
          SizedBox(
            height: Dimens.spacingSmall,
          ),
          Text(
            bottomText,
            style: LelloTextStyles.body(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).grey(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatus(ThemeData theme, BuildContext context) {
    return agreement.status == AgreementStatus.pending
        ? Container()
        : Padding(
            padding: EdgeInsets.only(top: Dimens.spacing),
            child: Row(
              children: [
                Container(
                  height: 8.0,
                  width: 8.0,
                  decoration: BoxDecoration(
                      color: agreement.getStatusColor(theme),
                      borderRadius: BorderRadius.circular(1000.0)),
                ),
                SizedBox(
                  width: Dimens.spacingSmall,
                ),
                Text(
                  (agreement.status == AgreementStatus.approvedAutomatically ||
                          agreement.status == AgreementStatus.approvedByManager)
                      ? "${agreement.getPendingOverTotalInstallments} Parcelas restantes"
                      : getString(context, agreement.getStatusKey),
                  style: LelloTextStyles.body(theme)!.copyWith(
                    color: agreement.getStatusColor(theme),
                  ),
                ),
              ],
            ),
          );
  }
}
