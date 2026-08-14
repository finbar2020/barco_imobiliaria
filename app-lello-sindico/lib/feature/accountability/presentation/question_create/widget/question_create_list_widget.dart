import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/widget/hex_color.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account_entrie.dart';
import 'package:lello/feature/accountability/presentation/detail/bloc/accountability_detail_bloc.dart';

import '../controller/question_create_controller.dart';

class QuestionCreateListWidget extends StatefulWidget {
  final AccountabilityGrouped? accountability;
  final Function() onChanged;
  final AccountabilityDoubt doubt;

  const QuestionCreateListWidget({
    Key? key,
    required this.accountability,
    required this.onChanged,
    required this.doubt,
  }) : super(key: key);

  @override
  State<QuestionCreateListWidget> createState() =>
      _QuestionCreateListWidgetState();
}

class _QuestionCreateListWidgetState extends State<QuestionCreateListWidget> {
  final AccountabilityDetailBloc bloc =
      ApplicationContainer.instance().resolve();
  final formatCurrency = NumberFormat.currency(symbol: "R\$");
  final QuestionCreateController controller =
      ApplicationContainer.instance().resolve<QuestionCreateController>();
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final formatCurrency = NumberFormat.currency(symbol: "R\$");
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).background(),
        body: BlocBuilder(
          bloc: bloc,
          builder: (context, state) {
            return DismissKeyboard(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 120.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: IconButton(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          color: HexColor("#828282"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(
                        color: LelloTheme.palleteOf(theme).background(),
                        padding: EdgeInsets.all(Dimens.spacingXSmall),
                        child: Center(
                          child: Text(
                            getString(context,
                                "accounttability_question_select_release_show"),
                            style: LelloTextStyles.bodyBold(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).textLight(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      ListView.builder(
                        itemCount: widget.accountability?.accounts.length ?? 0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final item = widget.accountability?.accounts[index];
                          var subColor = LelloTheme.palleteOf(theme).greyCard();
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 10,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: subColor,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(Dimens.spacingSmall),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  color: theme.primaryColor,
                                                  width: 12,
                                                  height: 12,
                                                ),
                                                SizedBox(
                                                    width: Dimens.spacingSmall),
                                                Flexible(
                                                  child: Text(
                                                    item!.description,
                                                    style: LelloTextStyles
                                                        .subtitleBold(theme),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 40,
                                                top: Dimens.spacingXSmall),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        getString(context,
                                                            "accountability_total_expenses"),
                                                        style: LelloTextStyles
                                                            .bodyBold(theme),
                                                      ),
                                                      Text(
                                                        formatCurrency.format(
                                                            item.getTotalDebit),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: Dimens.spacing),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        getString(context,
                                                            "accountability_total_income"),
                                                        style: LelloTextStyles
                                                            .bodyBold(theme),
                                                      ),
                                                      Text(
                                                        formatCurrency.format(
                                                            item.getTotalCredit),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: Dimens.spacingSmall),
                                          ListView.separated(
                                            itemBuilder: (context, index) {
                                              final entry = item.entries[index];
                                              return GestureDetector(
                                                onTap: (() {
                                                  toggleSelectItem(entry);
                                                }),
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  color: Colors.white,
                                                  elevation: 8,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 30,
                                                        child: Transform.scale(
                                                          scale: 1.2,
                                                          child: Checkbox(
                                                            activeColor: theme
                                                                .primaryColor,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                            side: BorderSide(
                                                              width: 1.0,
                                                              color: LelloTheme
                                                                      .palleteOf(
                                                                          theme)
                                                                  .separator(),
                                                            ),
                                                            value:
                                                                entry.checked,
                                                            onChanged:
                                                                (newValue) {
                                                              toggleSelectItem(
                                                                  entry);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              left: Dimens
                                                                  .spacingSmall),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      vertical:
                                                                          Dimens
                                                                              .spacingSmall,
                                                                    ),
                                                                    child:
                                                                        RichText(
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                "${getString(context, "accountability_history_account")} ",
                                                                            style:
                                                                                LelloTextStyles.bodyBold(theme),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                item.account.toString(),
                                                                            style:
                                                                                LelloTextStyles.body(theme),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: Dimens
                                                                        .spacingLarge,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      vertical:
                                                                          Dimens
                                                                              .spacingSmall,
                                                                    ),
                                                                    child:
                                                                        RichText(
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                "${getString(context, "accountability_history_date")} ",
                                                                            style:
                                                                                LelloTextStyles.bodyBold(theme),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                entry.dateFormatted,
                                                                            style:
                                                                                LelloTextStyles.body(theme),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  vertical: Dimens
                                                                      .spacingSmall,
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      getString(
                                                                          context,
                                                                          "accountability_history_description"),
                                                                      style: LelloTextStyles
                                                                          .bodyBold(
                                                                              theme),
                                                                    ),
                                                                    SizedBox(
                                                                      height: Dimens
                                                                          .spacingSmall,
                                                                    ),
                                                                    Text(
                                                                      entry
                                                                          .history,
                                                                      style: LelloTextStyles
                                                                          .body(
                                                                              theme),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .clip,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      vertical:
                                                                          Dimens
                                                                              .spacingSmall,
                                                                    ),
                                                                    child:
                                                                        RichText(
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                              text: "${getString(context, "accountability_history_debit")} ",
                                                                              style: LelloTextStyles.bodyBold(theme)),
                                                                          TextSpan(
                                                                            text:
                                                                                formatCurrency.format(entry.debit),
                                                                            style:
                                                                                LelloTextStyles.body(theme),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: Dimens
                                                                        .spacingLarge,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      vertical:
                                                                          Dimens
                                                                              .spacingSmall,
                                                                    ),
                                                                    child:
                                                                        RichText(
                                                                      text:
                                                                          TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                "${getString(context, "accountability_history_credit")} ",
                                                                            style:
                                                                                LelloTextStyles.bodyBold(theme),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                formatCurrency.format(entry.credit),
                                                                            style:
                                                                                LelloTextStyles.body(theme),
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
                                            itemCount: item.entries.length,
                                            shrinkWrap: true,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            separatorBuilder:
                                                (BuildContext context,
                                                        int index) =>
                                                    Divider(
                                              color: LelloTheme.palleteOf(theme)
                                                  .separator(),
                                              endIndent: 20,
                                              indent: 20,
                                              height: 0,
                                              thickness: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        bottomSheet: SizedBox(
          height: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  clickNoItem();
                },
                child: Container(
                  color: LelloTheme.palleteOf(theme).greyCard(),
                  child: Padding(
                    padding: EdgeInsets.all(Dimens.spacingSmall),
                    child: Row(
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            activeColor: theme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            side: BorderSide(
                              width: 1.0,
                              color: LelloTheme.palleteOf(theme).separator(),
                            ),
                            value: widget.doubt.noEnterieSelected,
                            onChanged: (value) {
                              clickNoItem();
                            },
                          ),
                        ),
                        Text(
                          getString(context,
                              "accounttability_question_no_select_release"),
                          style: LelloTextStyles.bodyBold(theme),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TertiaryButton(
                  style: TextStyle(
                    color: theme.primaryColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: getString(
                      context, "accounttability_question_select_conclude"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void toggleSelectItem(AccountabilityGroupedAccaountEntrie entry) {
    setState(
      () {
        entry.checked = !entry.checked;
        widget.doubt.noEnterieSelected = false;
        controller.doubtSelected = widget.doubt;
      },
    );
    widget.onChanged();
  }

  void clickNoItem() {
    setState(
      () {
        if (widget.doubt.noEnterieSelected) {
          widget.doubt.noEnterieSelected = false;
        } else {
          for (var element in (widget.accountability?.accounts ?? [])) {
            for (var element in element.entries) {
              element.checked = false;
            }
          }

          controller.doubtSelected = widget.doubt;
          widget.doubt.noEnterieSelected = true;
        }
        bool anyIsChecked = false;
        for (var element in (widget.accountability?.accounts ?? [])) {
          for (var element in element.entries) {
            if (element.checked) anyIsChecked = true;
          }
        }
        if (anyIsChecked) widget.doubt.noEnterieSelected = false;
        widget.onChanged();
      },
    );
  }
}
