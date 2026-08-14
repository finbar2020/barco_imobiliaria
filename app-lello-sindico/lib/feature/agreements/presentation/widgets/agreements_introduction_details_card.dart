import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_status.dart';

class IntroductionDetailsCard extends StatelessWidget {
  const IntroductionDetailsCard({
    Key? key,
    required this.theme,
    required this.agreement,
  }) : super(key: key);

  final ThemeData theme;
  final Agreement agreement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(Dimens.spacingMedium, Dimens.spacingMedium,
          Dimens.spacingMedium, Dimens.spacingMedium),
      width: double.infinity,
      color: LelloTheme.palleteOf(theme).separator(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.35),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                agreement.unitAndNameDescription,
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              (agreement.status == AgreementStatus.pending ||
                      agreement.status == AgreementStatus.rejected)
                  ? _buildComponent(
                      title: getString(context, "agreements_proposal_made_in"),
                      subtitle: agreement.getProposalDate)
                  : _buildComponent(
                      title: getString(context, "agreements_agreement_made_in"),
                      subtitle: agreement.getApprovalDate),
              SizedBox(height: Dimens.spacing),
              _buildComponent(
                  title: getString(context, "agreements_agreement_total_value"),
                  subtitle: agreement.getTotalValueFormatted),
              SizedBox(height: Dimens.spacing),
              _buildComponent(
                  title: getString(context, "agreements_payment_method"),
                  subtitle: getString(context, agreement.getPaymentMethodKey)),
              SizedBox(height: Dimens.spacing),
              _buildComponent(
                  title: getString(context, "agreements_expiration_date"),
                  subtitle:
                      "${getString(context, 'agreements_introduction_details_card_day')} ${agreement.getExpirationDay}"),
              SizedBox(height: Dimens.spacing),
              _buildComponent(
                  title: getString(context, "agreements_installments"),
                  subtitle: agreement.getInstallmentsAndValue),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildComponent({required String title, required String subtitle}) {
    return Row(
      children: [
        Flexible(
          child: Text(
            "$title ",
            style: LelloTextStyles.bodyBold(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).text(),
            ),
          ),
        ),
        SizedBox(height: Dimens.spacing),
        Flexible(
          child: Text(
            subtitle,
            style: LelloTextStyles.subtitle(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).text(),
            ),
          ),
        ),
      ],
    );
  }
}
