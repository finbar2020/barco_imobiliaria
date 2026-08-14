// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_filter_sort.dart';

import '../../../../core/dependency/application_container.dart';
import '../../domain/entity/payment_method.dart';
import '../controllers/agreements_controller.dart';

class AgreementsFilterDrawer extends StatefulWidget {
  final bool isProposal;

  const AgreementsFilterDrawer({
    super.key,
    required this.isProposal,
  });

  @override
  State<AgreementsFilterDrawer> createState() => _AgreementsFilterDrawerState();
}

class _AgreementsFilterDrawerState extends State<AgreementsFilterDrawer> {
  final controller =
      ApplicationContainer.instance().resolve<AgreementsController>();

  @override
  void initState() {
    // if (controller.agreementsFilterSort.sortDueDateKey.isEmpty) {
    //   return;
    // }
    // if (widget.isProposal) {
    //   controller.agreementsFilterSort = AgreementsFilterSort(
    //       sortDueDateKey: AgreementsFilterSortKeys.dueDateCrescent);
    // } else {
    //   controller.agreementsFilterSort = AgreementsFilterSort(
    //       sortDueDateKey: AgreementsFilterSortKeys.dueDateDecrescent);
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = LelloTheme.dark;
    var themeContext = Theme.of(context);
    theme = theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: themeContext.primaryColor,
      ),
      primaryColor: themeContext.primaryColor,
    );
    return Container(
      color: LelloTheme.palleteOf(theme).greyDarker(),
      padding: EdgeInsets.only(top: Dimens.spacingMedium),
      child: Theme(
        data: themeContext,
        child: Container(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          color: LelloTheme.palleteOf(theme).greyDarker(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: SvgPicture.asset("assets/ic_close_white.svg"),
                  ),
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: Dimens.spacingLarge),
                        child: Text(getString(context, "payment_filter_title"),
                            style: LelloTextStyles.title(theme)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: Dimens.spacing),
                            child: Text(
                                getString(context,
                                    "agreements_filter_payment_method"),
                                style: LelloTextStyles.bodyBold(theme)),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              Dimens.spacing,
                              Dimens.spacing,
                              Dimens.spacing,
                              Dimens.spacingLarge,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: 2.0,
                                        child: Checkbox(
                                          tristate: true,
                                          value: controller
                                                  .filterPaymentMethodKey ==
                                              PaymentMethod.billet,
                                          activeColor:
                                              themeContext.primaryColor,
                                          shape: const CircleBorder(),
                                          side: BorderSide(
                                              width: 1,
                                              color: LelloTheme.palleteOf(theme)
                                                  .button()),
                                          onChanged: (bool? value) {
                                            setState(
                                              () {
                                                controller
                                                        .filterPaymentMethodKey =
                                                    PaymentMethod.billet;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Text(
                                        getString(
                                          context,
                                          AgreementsFilterSortKeys.billet,
                                        ),
                                        style: LelloTextStyles.body(theme),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: Dimens.spacingMedium),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: 2.0,
                                        child: Checkbox(
                                          tristate: true,
                                          value: controller
                                                  .filterPaymentMethodKey ==
                                              PaymentMethod.credit,
                                          activeColor:
                                              themeContext.primaryColor,
                                          shape: const CircleBorder(),
                                          side: BorderSide(
                                              width: 1,
                                              color: LelloTheme.palleteOf(theme)
                                                  .button()),
                                          onChanged: (bool? value) {
                                            setState(
                                              () {
                                                controller
                                                        .filterPaymentMethodKey =
                                                    PaymentMethod.credit;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Text(
                                        getString(context,
                                            AgreementsFilterSortKeys.credit),
                                        style: LelloTextStyles.body(theme),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimens.spacingMedium),
                        child: Text(
                            getString(context, "agreements_filter_sort"),
                            style: LelloTextStyles.title(theme)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: Dimens.spacing),
                            child: Text(
                                getString(context, "agreements_filter_name"),
                                style: LelloTextStyles.bodyBold(theme)),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              Dimens.spacing,
                              Dimens.spacing,
                              Dimens.spacing,
                              Dimens.spacingLarge,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: 2.0,
                                        child: Checkbox(
                                          tristate: true,
                                          value: controller.sortNameKey ==
                                              AgreementsFilterSortKeys.nameAtoZ,
                                          activeColor:
                                              themeContext.primaryColor,
                                          shape: const CircleBorder(),
                                          side: BorderSide(
                                              width: 1,
                                              color: LelloTheme.palleteOf(theme)
                                                  .button()),
                                          onChanged: (bool? value) {
                                            setState(
                                              () {
                                                controller.sortNameKey =
                                                    AgreementsFilterSortKeys
                                                        .nameAtoZ;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Text(
                                        getString(
                                          context,
                                          AgreementsFilterSortKeys.nameAtoZ,
                                        ),
                                        style: LelloTextStyles.body(theme),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: Dimens.spacingMedium),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: 2.0,
                                        child: Checkbox(
                                          tristate: true,
                                          value: controller.sortNameKey ==
                                              AgreementsFilterSortKeys.nameZtoA,
                                          activeColor:
                                              themeContext.primaryColor,
                                          shape: const CircleBorder(),
                                          side: BorderSide(
                                              width: 1,
                                              color: LelloTheme.palleteOf(theme)
                                                  .button()),
                                          onChanged: (bool? value) {
                                            setState(
                                              () {
                                                controller.sortNameKey =
                                                    AgreementsFilterSortKeys
                                                        .nameZtoA;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Text(
                                        getString(context,
                                            AgreementsFilterSortKeys.nameZtoA),
                                        style: LelloTextStyles.body(theme),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: Dimens.spacing),
                            child: Text(
                                getString(context, "agreements_filter_unit"),
                                style: LelloTextStyles.bodyBold(theme)),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              Dimens.spacing,
                              Dimens.spacing,
                              Dimens.spacing,
                              Dimens.spacingLarge,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: 2.0,
                                        child: Checkbox(
                                          tristate: true,
                                          value: controller.sortUnitKey ==
                                              AgreementsFilterSortKeys
                                                  .unitCrescent,
                                          activeColor:
                                              themeContext.primaryColor,
                                          shape: const CircleBorder(),
                                          side: BorderSide(
                                              width: 1,
                                              color: LelloTheme.palleteOf(theme)
                                                  .button()),
                                          onChanged: (bool? value) {
                                            setState(
                                              () {
                                                controller.sortUnitKey =
                                                    AgreementsFilterSortKeys
                                                        .unitCrescent;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Text(
                                        getString(
                                          context,
                                          AgreementsFilterSortKeys.unitCrescent,
                                        ),
                                        style: LelloTextStyles.body(theme),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: Dimens.spacingMedium),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: 2.0,
                                        child: Checkbox(
                                          tristate: true,
                                          value: controller.sortUnitKey ==
                                              AgreementsFilterSortKeys
                                                  .unitDecrescent,
                                          activeColor:
                                              themeContext.primaryColor,
                                          shape: const CircleBorder(),
                                          side: BorderSide(
                                              width: 1,
                                              color: LelloTheme.palleteOf(theme)
                                                  .button()),
                                          onChanged: (bool? value) {
                                            setState(
                                              () {
                                                controller.sortUnitKey =
                                                    AgreementsFilterSortKeys
                                                        .unitDecrescent;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Text(
                                        getString(
                                            context,
                                            AgreementsFilterSortKeys
                                                .unitDecrescent),
                                        style: LelloTextStyles.body(theme),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      widget.isProposal
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: Dimens.spacing),
                                  child: Text(
                                      getString(context,
                                          "agreements_filter_agreement_proposal"),
                                      style: LelloTextStyles.bodyBold(theme)),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    Dimens.spacing,
                                    Dimens.spacing,
                                    Dimens.spacing,
                                    Dimens.spacingLarge,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Transform.scale(
                                              scale: 2.0,
                                              child: Checkbox(
                                                tristate: true,
                                                value: controller
                                                        .sortProposalDateKey ==
                                                    AgreementsFilterSortKeys
                                                        .proposalDateCrescent,
                                                activeColor:
                                                    themeContext.primaryColor,
                                                shape: const CircleBorder(),
                                                side: BorderSide(
                                                    width: 1,
                                                    color: LelloTheme.palleteOf(
                                                            theme)
                                                        .button()),
                                                onChanged: (bool? value) {
                                                  setState(
                                                    () {
                                                      controller
                                                              .sortProposalDateKey =
                                                          AgreementsFilterSortKeys
                                                              .proposalDateCrescent;
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            Text(
                                              getString(
                                                context,
                                                AgreementsFilterSortKeys
                                                    .proposalDateCrescent,
                                              ),
                                              style:
                                                  LelloTextStyles.body(theme),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: Dimens.spacingMedium),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Transform.scale(
                                              scale: 2.0,
                                              child: Checkbox(
                                                tristate: true,
                                                value: controller
                                                        .sortProposalDateKey ==
                                                    AgreementsFilterSortKeys
                                                        .proposalDateDecrescent,
                                                activeColor:
                                                    themeContext.primaryColor,
                                                shape: const CircleBorder(),
                                                side: BorderSide(
                                                    width: 1,
                                                    color: LelloTheme.palleteOf(
                                                            theme)
                                                        .button()),
                                                onChanged: (bool? value) {
                                                  setState(
                                                    () {
                                                      controller
                                                              .sortProposalDateKey =
                                                          AgreementsFilterSortKeys
                                                              .proposalDateDecrescent;
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            Text(
                                              getString(
                                                  context,
                                                  AgreementsFilterSortKeys
                                                      .proposalDateDecrescent),
                                              style:
                                                  LelloTextStyles.body(theme),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: Dimens.spacing),
                                  child: Text(
                                      getString(context,
                                          "agreements_filter_agreement_due"),
                                      style: LelloTextStyles.body(theme)),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    Dimens.spacing,
                                    Dimens.spacing,
                                    Dimens.spacing,
                                    Dimens.spacingLarge,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Transform.scale(
                                              scale: 2.0,
                                              child: Checkbox(
                                                tristate: true,
                                                value:
                                                    controller.sortDueDateKey ==
                                                        AgreementsFilterSortKeys
                                                            .dueDateCrescent,
                                                activeColor:
                                                    themeContext.primaryColor,
                                                shape: const CircleBorder(),
                                                side: BorderSide(
                                                    width: 1,
                                                    color: LelloTheme.palleteOf(
                                                            theme)
                                                        .button()),
                                                onChanged: (bool? value) {
                                                  setState(
                                                    () {
                                                      controller
                                                              .sortDueDateKey =
                                                          AgreementsFilterSortKeys
                                                              .dueDateCrescent;
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            Text(
                                              getString(
                                                context,
                                                AgreementsFilterSortKeys
                                                    .dueDateCrescent,
                                              ),
                                              style:
                                                  LelloTextStyles.body(theme),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: Dimens.spacingMedium),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Transform.scale(
                                              scale: 2.0,
                                              child: Checkbox(
                                                tristate: true,
                                                value:
                                                    controller.sortDueDateKey ==
                                                        AgreementsFilterSortKeys
                                                            .dueDateDecrescent,
                                                activeColor:
                                                    themeContext.primaryColor,
                                                shape: const CircleBorder(),
                                                side: BorderSide(
                                                    width: 1,
                                                    color: LelloTheme.palleteOf(
                                                            theme)
                                                        .button()),
                                                onChanged: (bool? value) {
                                                  setState(
                                                    () {
                                                      controller
                                                              .sortDueDateKey =
                                                          AgreementsFilterSortKeys
                                                              .dueDateDecrescent;
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            Text(
                                              getString(
                                                  context,
                                                  AgreementsFilterSortKeys
                                                      .dueDateDecrescent),
                                              style:
                                                  LelloTextStyles.body(theme),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: Dimens.spacingMedium),
                width: double.infinity,
                child: PrimaryButton(
                  text: getString(context, "agreements_filter_apply"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
