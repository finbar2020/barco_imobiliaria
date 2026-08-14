import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/modal/month_picker.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis_element.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_finished.dart';
import 'package:lello/feature/agreements/domain/entity/payment_method.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_analysis/widgets/agreements_scale_bar.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_analysis/widgets/doughnut_chart.dart';

class AgreementsAnalysisFinishedWidget extends StatefulWidget {
  final AgreementsFinished? agreementsFinished;
  final DateTime currentPeriod;
  final Function(DateTime? fromDate) onTap;
  const AgreementsAnalysisFinishedWidget(
      {Key? key,
      this.agreementsFinished,
      required this.currentPeriod,
      required this.onTap})
      : super(key: key);

  @override
  State<AgreementsAnalysisFinishedWidget> createState() =>
      _AgreementsAnalysisFinishedWidgetState();
}

class _AgreementsAnalysisFinishedWidgetState
    extends State<AgreementsAnalysisFinishedWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
          top: Dimens.spacingLarge,
          left: Dimens.spacingMedium,
          right: Dimens.spacingMedium,
          bottom: Dimens.spacingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getString(context, "agreements_analysis_period"),
                style: LelloTextStyles.subtitleBold(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).grey()),
              ),
              _buildPeriodSelector(context, theme),
            ],
          ),
          SizedBox(height: Dimens.spacing),
          Flexible(
            child: widget.agreementsFinished == null
                ? ErrorMessageWidget(
                    message:
                        getString(context, "agreements_analysis_not_found"))
                : widget.agreementsFinished!.isEmpty
                    ? ErrorMessageWidget(
                        message:
                            getString(context, "agreements_analysis_empty"))
                    : _buildAnalysisBody(widget.agreementsFinished!),
          )
        ],
      ),
    );
  }

  Widget _buildAnalysisBody(AgreementsFinished agreementsFinished) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getString(context, "agreements_analysis_made_automatically"),
            style: LelloTextStyles.subtitleBold(theme)!
                .copyWith(color: LelloTheme.palleteOf(theme).grey()),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Text(
            agreementsFinished.agreementsPerformedAutomaticallyQtd.toString(),
            style: LelloTextStyles.subtitle(theme)!
                .copyWith(color: LelloTheme.palleteOf(theme).success()),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Text(
            getString(context, "agreements_analysis_made_with_approval"),
            style: LelloTextStyles.subtitleBold(theme)!
                .copyWith(color: LelloTheme.palleteOf(theme).grey()),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Text(
            agreementsFinished.agreementsManuallyApprovedQtd.toString(),
            style: LelloTextStyles.subtitle(theme)!
                .copyWith(color: LelloTheme.palleteOf(theme).warning()),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Text(
            getString(context, "agreements_analysis_total"),
            style: LelloTextStyles.subtitleBold(theme)!
                .copyWith(color: LelloTheme.palleteOf(theme).grey()),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Text(
            agreementsFinished.getTotal.toString(),
            style: LelloTextStyles.subtitle(theme)!
                .copyWith(color: LelloTheme.palleteOf(theme).accent()),
          ),
          SizedBox(height: Dimens.spacingMedium),
          if (agreementsFinished.reportPaymentMethod.isNotEmpty)
            _buildPaymentMethodList(agreementsFinished.reportPaymentMethod),
          SizedBox(height: Dimens.spacingSmall),
          if (agreementsFinished.reportInstallments.isNotEmpty)
            _buildBilletsInstallmentsChart(agreementsFinished),
          if (agreementsFinished.reportDueDate.isNotEmpty)
            _buildDueDateList(agreementsFinished.getReportDueDateSorted),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context, ThemeData theme) {
    DateTime currentPeriod = DateTime.now();
    currentPeriod = widget.currentPeriod;
    final dateFormat = DateFormat.yM();
    return InkWell(
      onTap: () async {
        final period = await showMonthPicker(
          context: context,
          initialDate: currentPeriod,
          lastDate: DateTime.now(),
        );
        if (period != null) {
          await widget.onTap(period);
        }
      },
      child: Row(children: [
        Text(dateFormat.format(widget.currentPeriod),
            style: LelloTextStyles.subtitle(theme)),
        SizedBox(width: Dimens.spacing),
        SvgPicture.asset("assets/ic_arrow_down_black.svg")
      ]),
    );
  }

  Widget _buildPaymentMethodList(
      List<AgreementsAnalysisElement> reportPaymentMethod) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          getString(context, "agreements_analysis_payment_method"),
          style: LelloTextStyles.subtitleBold(theme)!
              .copyWith(color: LelloTheme.palleteOf(theme).text()),
        ),
        SizedBox(height: Dimens.spacing),
        ListView.builder(
            itemCount: reportPaymentMethod.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getString(
                        context,
                        PaymentMethod.getPaymentMethodKey(
                            reportPaymentMethod[index].description)),
                    style: LelloTextStyles.body(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).grey(),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingXSmall),
                  AgreementsScaleBar(
                      color: LelloTheme.palleteOf(theme).accent(),
                      value: reportPaymentMethod[index].percentage),
                  SizedBox(height: Dimens.spacingSmall),
                ],
              );
            }),
      ],
    );
  }

  Widget _buildBilletsInstallmentsChart(AgreementsFinished agreementsFinished) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getString(context, "agreements_analysis_installments_number_billet"),
          style: LelloTextStyles.subtitleBold(theme)!
              .copyWith(color: LelloTheme.palleteOf(theme).text()),
        ),
        DoughnutChart(
            data: agreementsFinished.getReportInstallmentsForChart(context)),
      ],
    );
  }

  Widget _buildDueDateList(List<AgreementsAnalysisElement> reportDueDate) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getString(context, "agreements_analysis_payment_days"),
          style: LelloTextStyles.subtitleBold(theme)!
              .copyWith(color: LelloTheme.palleteOf(theme).text()),
        ),
        SizedBox(height: Dimens.spacingSmall),
        ListView.builder(
          itemCount: reportDueDate.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "${getString(context, 'agreements_analysis_day')} ${reportDueDate[index].description}",
                    style: LelloTextStyles.body(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).grey(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: AgreementsScaleBar(
                      color: LelloTheme.palleteOf(theme).success(),
                      value: reportDueDate[index].percentage),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
