import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/modal/month_picker.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreement_analysis_type.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_analysis_element.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_analysis/agreements_refused.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_analysis/widgets/agreements_scale_bar.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_analysis/widgets/doughnut_chart.dart';

class AgreementsAnalysisRefusedWidget extends StatefulWidget {
  final DateTime currentPeriod;
  final AgreementsRefused? agreementsRefused;
  final Function(DateTime? fromDate) onTap;
  const AgreementsAnalysisRefusedWidget({
    Key? key,
    required this.currentPeriod,
    this.agreementsRefused,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AgreementsAnalysisRefusedWidget> createState() =>
      _AgreementsAnalysisRefusedWidgetState();
}

class _AgreementsAnalysisRefusedWidgetState
    extends State<AgreementsAnalysisRefusedWidget> {
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
            child: widget.agreementsRefused == null
                ? ErrorMessageWidget(
                    message:
                        getString(context, "agreements_analysis_not_found"))
                : widget.agreementsRefused!.agreementsReprovedQtd == 0
                    ? ErrorMessageWidget(
                        message:
                            getString(context, "agreements_analysis_empty"))
                    : _buildAnalysisBody(widget.agreementsRefused!),
          )
        ],
      ),
    );
  }

  Widget _buildAnalysisBody(AgreementsRefused agreementsRefused) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getString(context, "agreements_analysis_refused_proposals"),
            style: LelloTextStyles.subtitleBold(theme)!
                .copyWith(color: LelloTheme.palleteOf(theme).grey()),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Text(
            agreementsRefused.agreementsReprovedQtd.toString(),
            style: LelloTextStyles.subtitle(theme)!
                .copyWith(color: LelloTheme.palleteOf(theme).accent()),
          ),
          if (agreementsRefused.reportReprovedReason.isNotEmpty)
            _buildRefusedProposalsChart(theme, agreementsRefused),
          Text(
            getString(context, "agreements_analysis_most_wanted"),
            style: LelloTextStyles.subtitleBold(theme)!
                .copyWith(color: LelloTheme.palleteOf(theme).text()),
          ),
          SizedBox(height: Dimens.spacing),
          if (agreementsRefused.reportInstallments.isNotEmpty)
            _buildListView(
              list: agreementsRefused.getReportInstallmentsSorted,
              type: AgreementAnalysisType.installmentQtd,
              title:
                  getString(context, "agreements_analysis_installments_number"),
            ),
          SizedBox(height: Dimens.spacing),
          if (agreementsRefused.reportDueDate.isNotEmpty)
            _buildListView(
              list: agreementsRefused.getReportDueDateSorted,
              type: AgreementAnalysisType.dueDate,
              prefix: "agreements_analysis_day",
              title: getString(context, "agreements_analysis_payment_days"),
            ),
        ],
      ),
    );
  }

  Column _buildRefusedProposalsChart(
      ThemeData theme, AgreementsRefused agreementsRefused) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: DoughnutChart(
              data: agreementsRefused.getReportReprovedReasonChart(context)),
        ),
      ],
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
          widget.onTap(period);
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

  Widget _buildListView(
      {required List<AgreementsAnalysisElement> list,
      required String type,
      required String title,
      String? prefix}) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: LelloTextStyles.subtitleBold(theme)!
              .copyWith(color: LelloTheme.palleteOf(theme).grey()),
        ),
        SizedBox(height: Dimens.spacingSmall),
        ListView.builder(
          itemCount: list.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    prefix != null
                        ? "${getString(context, prefix)} ${list[index].description}"
                        : list[index].description,
                    textAlign:
                        prefix == null ? TextAlign.center : TextAlign.left,
                    style: LelloTextStyles.body(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).grey(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: AgreementsScaleBar(
                      color: list[index].getColor(theme, type) ??
                          LelloTheme.palleteOf(theme).warning(),
                      value: list[index].percentage),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
