import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account.dart';

import '../../../../../core/dependency/application_container.dart';
import '../controller/question_create_controller.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account_entrie.dart';

class QuestionCreatenGroupedEntriesCardWidget extends StatefulWidget {
  final AccountabilityGroupedAccount entity;
  final Color subColor;
  final Function() onChanged;

  final AccountabilityDoubt accountabilityDoubt;

  const QuestionCreatenGroupedEntriesCardWidget({
    Key? key,
    required this.entity,
    required this.subColor,
    required this.onChanged,
    required this.accountabilityDoubt,
  }) : super(key: key);

  @override
  State<QuestionCreatenGroupedEntriesCardWidget> createState() =>
      _QuestionCreatenGroupedEntriesCardWidgetState();
}

class _QuestionCreatenGroupedEntriesCardWidgetState
    extends State<QuestionCreatenGroupedEntriesCardWidget> {
  @override
  Widget build(BuildContext context) {
    final QuestionCreateController controller =
        ApplicationContainer.instance().resolve<QuestionCreateController>();
    ThemeData theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: "R\$");
    return ListView.separated(
      itemBuilder: (context, index) {
        final item = widget.entity.entries[index];
        return GestureDetector(
          onTap: (() {
            toggleSelectItem(item, controller);
          }),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.white,
            elevation: 8,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                  child: Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      activeColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      side: BorderSide(
                        width: 1.0,
                        color: LelloTheme.palleteOf(theme).separator(),
                      ),
                      value: item.checked,
                      onChanged: (newValue) {
                        toggleSelectItem(item, controller);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: Dimens.spacingSmall),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Dimens.spacingSmall,
                              ),
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text:
                                        "${getString(context, "accountability_history_account")} ",
                                    style: LelloTextStyles.bodyBold(theme),
                                  ),
                                  TextSpan(
                                    text: widget.entity.account.toString(),
                                    style: LelloTextStyles.body(theme),
                                  )
                                ]),
                              ),
                            ),
                            SizedBox(
                              width: Dimens.spacingLarge,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Dimens.spacingSmall,
                              ),
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text:
                                        "${getString(context, "accountability_history_date")} ",
                                    style: LelloTextStyles.bodyBold(theme),
                                  ),
                                  TextSpan(
                                    text: item.dateFormatted,
                                    style: LelloTextStyles.body(theme),
                                  )
                                ]),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: Dimens.spacingSmall,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                getString(context,
                                    "accountability_history_description"),
                                style: LelloTextStyles.bodyBold(theme),
                              ),
                              SizedBox(
                                height: Dimens.spacingSmall,
                              ),
                              Text(
                                item.history,
                                style: LelloTextStyles.body(theme),
                                overflow: TextOverflow.clip,
                              )
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Dimens.spacingSmall,
                              ),
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          "${getString(context, "accountability_history_debit")} ",
                                      style: LelloTextStyles.bodyBold(theme)),
                                  TextSpan(
                                    text: currencyFormat.format(item.debit),
                                    style: LelloTextStyles.body(theme),
                                  )
                                ]),
                              ),
                            ),
                            SizedBox(
                              width: Dimens.spacingLarge,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Dimens.spacingSmall,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          "${getString(context, "accountability_history_credit")} ",
                                      style: LelloTextStyles.bodyBold(theme),
                                    ),
                                    TextSpan(
                                      text: currencyFormat.format(item.credit),
                                      style: LelloTextStyles.body(theme),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: widget.entity.entries.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: LelloTheme.palleteOf(theme).separator(),
        endIndent: 20,
        indent: 20,
        height: 0,
        thickness: 2,
      ),
    );
  }

  void toggleSelectItem(AccountabilityGroupedAccaountEntrie item,
      QuestionCreateController controller) {
    setState(
      () {
        item.checked = !item.checked;
        controller.doubtSelected = widget.accountabilityDoubt;
      },
    );
    widget.onChanged();
  }
}
