import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class AgreementResumeBottomSheet extends StatefulWidget {
  final bool pendingProposal;
  final bool creditCard;
  final AgreementCreated agreement;
  final AgreementsBloc bloc;
  const AgreementResumeBottomSheet({
    Key? key,
    required this.pendingProposal,
    required this.agreement,
    this.creditCard = false,
    required this.bloc,
  }) : super(key: key);

  @override
  State<AgreementResumeBottomSheet> createState() =>
      _AgreementResumeBottomSheetState();
}

class _AgreementResumeBottomSheetState
    extends State<AgreementResumeBottomSheet> {
  final formatCurrency = new NumberFormat.currency(symbol: "R\$");
  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: IconButton(
                icon: Icon(Icons.keyboard_arrow_down),
                color: LelloTheme.palleteOf(theme).grey(),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
              Text(
                getString(context, "agreements_resume"),
                style: LelloTextStyles.titleSmallBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              _buildRowInfo(
                title: "agreements_quotas",
                subtitle: widget.agreement.receiptList.length.toString(),
              ),
              SizedBox(height: Dimens.spacing),
              _buildRowInfo(
                title: "register_payment_file_payment_method",
                subtitle:
                    getString(context, widget.agreement.chosenPaymentMethod),
              ),
              SizedBox(height: Dimens.spacing),
              widget.creditCard
                  ? _buildRowInfo(
                      title: "space_reservation_expiration",
                      subtitle:
                          getString(context, "agreement_credit_expiration"),
                    )
                  : _buildRowInfo(
                      title: "space_reservation_expiration",
                      subtitle:
                          "${getString(context, "access_control_days").replaceAll("s", "")} ${widget.agreement.dueDate}",
                    ),
              if (!widget.creditCard) SizedBox(height: Dimens.spacing),
              if (!widget.creditCard)
                _buildRowInfo(
                  title: "agreements_value_installment",
                  subtitle: formatCurrency.format(widget.agreement.totalValue /
                      widget.agreement.installmentQuantity),
                  installment: widget.agreement.installmentQuantity.toString(),
                ),
              SizedBox(height: Dimens.spacing),
              _buildRowInfo(
                title: widget.creditCard
                    ? "agreement_billet_total_value"
                    : "agreements_total_value",
                subtitle: formatCurrency.format(widget.agreement.totalValue),
                redColor: true,
              ),
              if (widget.creditCard) SizedBox(height: Dimens.spacingLarge),
              if (widget.creditCard)
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: Dimens.spacingMedium,
                      color: LelloTheme.palleteOf(theme).textOpaque(),
                    ),
                    SizedBox(width: Dimens.spacingSmall),
                    Expanded(
                      child: Text(
                        getString(context, "agreement_info_resume_credit"),
                        style: LelloTextStyles.caption(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).textOpaque(),
                        ),
                      ),
                    ),
                  ],
                ),
              if (widget.pendingProposal) SizedBox(height: Dimens.spacingLarge),
              if (widget.pendingProposal)
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/ic_information.svg",
                      width: 32.0,
                      height: 32.0,
                      color: LelloTheme.palleteOf(theme).warning(),
                    ),
                    SizedBox(width: Dimens.spacing),
                    Flexible(
                      child: RichText(
                        text: new TextSpan(
                          style: LelloTextStyles.subtitle(theme),
                          children: <TextSpan>[
                            TextSpan(
                                text: getString(context, "agreements_remember"),
                                style: LelloTextStyles.subtitle(theme)!
                                    .copyWith(
                                        color: LelloTheme.palleteOf(theme)
                                            .warning())),
                            TextSpan(
                                text: getString(
                                    context, "agreements_remember_description"),
                                style: LelloTextStyles.subtitle(theme)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: Dimens.spacingMedium),
              Container(
                width: double.infinity,
                height: 52.0,
                child: PrimaryButton(
                  text: getString(
                      context,
                      widget.pendingProposal
                          ? "agreements_end_proposal"
                          : "agreements_end"),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.bloc.postAgreement(widget.agreement,
                        widget.pendingProposal, widget.creditCard);
                  },
                ),
              ),
              if (widget.pendingProposal) SizedBox(height: Dimens.spacing),
              if (widget.pendingProposal)
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      side: BorderSide(
                          width: 1, color: LelloTheme.palleteOf(theme).text()),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 23.0),
                      child: Text(
                        getString(context, "agreements_recuse_back"),
                        style: LelloTextStyles.button(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).text(),
                        ),
                      ),
                    ),
                    onPressed: () {
                      OwnerAnalyticsLogEvents.logEvent(
                        event: AnalyticsEventsOwner.acordosRecusarAcordo(),
                        userId: sessionBloc.state.session?.me?.id ?? "",
                        unitValue: sessionBloc.state.session!.unity?.namedTitle
                                .toString() ??
                            "",
                        referenceValue: sessionBloc
                                .state.session!.condominium?.reference
                                ?.toString() ??
                            "",
                      );
                      Navigator.pop(context);
                      widget.bloc.goToAgreements(widget.agreement);
                      Navigator.pushReplacementNamed(
                        context,
                        ApplicationRoute.agreements,
                      );
                    },
                  ),
                ),
              SizedBox(height: Dimens.spacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowInfo(
      {required String title,
      required String subtitle,
      String? installment,
      bool? redColor}) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          installment != null
              ? "${getString(context, title)} [${installment}x]"
              : getString(context, title),
          style: LelloTextStyles.subtitleBold(theme)!.copyWith(
              color: redColor == null
                  ? LelloTheme.palleteOf(theme).hubText()
                  : LelloTheme.palleteOf(theme).secondGradient()),
        ),
        Text(
          subtitle,
          style: LelloTextStyles.subtitleBold(theme)!.copyWith(
              color: redColor == null
                  ? LelloTheme.palleteOf(theme).textOpaque()
                  : theme.primaryColor),
        ),
      ],
    );
  }
}
