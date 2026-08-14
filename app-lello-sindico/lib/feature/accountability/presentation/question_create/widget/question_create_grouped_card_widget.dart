import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account.dart';
import 'package:lello/feature/accountability/presentation/question_create/widget/question_create_grouped_entries_card_widget.dart';

class QuestionCreateGroupedCardWidget extends StatefulWidget {
  final AccountabilityGroupedAccount item;
  final Color subColor;
  final Function() onChanged;

  final AccountabilityDoubt accountabilityDoubt;
  const QuestionCreateGroupedCardWidget({
    Key? key,
    required this.item,
    required this.subColor,
    required this.onChanged,
    required this.accountabilityDoubt,
  }) : super(key: key);

  @override
  State<QuestionCreateGroupedCardWidget> createState() =>
      _QuestionCreateGroupedCardWidgetState();
}

class _QuestionCreateGroupedCardWidgetState
    extends State<QuestionCreateGroupedCardWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final formatCurrency = NumberFormat.currency(symbol: "R\$");
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 10,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: widget.subColor,
              child: Padding(
                padding: EdgeInsets.all(Dimens.spacingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          Container(
                            color: theme.primaryColor,
                            width: 12,
                            height: 12,
                          ),
                          SizedBox(width: Dimens.spacingSmall),
                          Flexible(
                              child: Text(
                            widget.item.description,
                            style: LelloTextStyles.subtitleBold(theme),
                          )),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 40, top: Dimens.spacingXSmall),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    getString(context,
                                        "accountability_total_expenses"),
                                    style: LelloTextStyles.bodyBold(theme)),
                                Text(formatCurrency
                                    .format(widget.item.getTotalDebit))
                              ],
                            ),
                          ),
                          SizedBox(width: Dimens.spacing),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    getString(
                                        context, "accountability_total_income"),
                                    style: LelloTextStyles.bodyBold(theme)),
                                Text(formatCurrency
                                    .format(widget.item.getTotalCredit))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    QuestionCreatenGroupedEntriesCardWidget(
                      entity: widget.item,
                      subColor: widget.subColor,
                      onChanged: widget.onChanged,
                      accountabilityDoubt: widget.accountabilityDoubt,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
