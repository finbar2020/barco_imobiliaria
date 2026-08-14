import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';
import 'package:lello/feature/resin/presentation/resin_receipt_details/page/resin_receipt_details_page.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_confirmation_dialog.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_status_selector_widget.dart';

class ResinHistoryListWidget extends StatelessWidget {
  final List<ResinRefund> refunds;
  final Function(ResinRefund refund) editRefund;
  final Function(ResinRefund account) cancelRefund;
  const ResinHistoryListWidget({
    Key? key,
    required this.refunds,
    required this.cancelRefund,
    required this.editRefund,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    NumberFormat formatCurrency = new NumberFormat.currency(symbol: "R\$");
    final dateFormat = DateFormat.yMd();
    return Expanded(
      child: refunds.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Text(
                  getString(context, "resin_history_empty"),
                  style: LelloTextStyles.body(theme)
                      ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
                ),
              ),
            )
          : ListView.separated(
              itemCount: refunds.length,
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ApplicationRoute.resinReceiptDetails,
                            arguments: ResinReceiptDetailsPageArgs(
                                refund: refunds[index]),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(Dimens.spacingSmall),
                          child: ListTile(
                            leading: iconSelector(refunds[index]),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Flexible(
                                        flex: 1,
                                        child: Wrap(
                                          children: [
                                            Text(
                                              getString(context,
                                                  "resin_history_new_advance_protocol"),
                                              style: LelloTextStyles.body(theme)
                                                  ?.copyWith(
                                                      color:
                                                          LelloTheme.palleteOf(
                                                                  theme)
                                                              .hubText()),
                                            ),
                                            Text(
                                              refunds[index].protocol,
                                              style: LelloTextStyles.bodyBold(
                                                      theme)
                                                  ?.copyWith(
                                                      color:
                                                          LelloTheme.palleteOf(
                                                                  theme)
                                                              .text()),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ResinStatusSelectorWidget(
                                            context: context,
                                            refundRelatoryStatus:
                                                refunds[index].status ??
                                                    ResinRefundStatus.sended,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimens.spacingSmall),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      children: [
                                        Text(
                                          getString(context,
                                              "resin_history_new_advance_value"),
                                          style: LelloTextStyles.body(theme)
                                              ?.copyWith(
                                                  color: LelloTheme.palleteOf(
                                                          theme)
                                                      .hubText()),
                                        ),
                                        Text(
                                          formatCurrency
                                              .format(refunds[index].value),
                                          style: LelloTextStyles.bodyBold(theme)
                                              ?.copyWith(
                                                  color: LelloTheme.palleteOf(
                                                          theme)
                                                      .primary()),
                                        ),
                                      ],
                                    ),
                                    SvgPicture.asset(
                                      "assets/ic_arrow_right.svg",
                                      color:
                                          LelloTheme.palleteOf(theme).hubText(),
                                    )
                                  ],
                                ),
                                SizedBox(height: Dimens.spacingSmall),
                                Wrap(
                                  children: [
                                    Text(
                                      getString(context,
                                          "resin_history_new_advance_request_date"),
                                      style: LelloTextStyles.body(theme)
                                          ?.copyWith(
                                              color: LelloTheme.palleteOf(theme)
                                                  .hubText()),
                                    ),
                                    Text(
                                      dateFormat
                                          .format(refunds[index].requestDate!),
                                      style: LelloTextStyles.bodyBold(theme),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimens.spacingSmall),
                                Row(
                                  children: [
                                    if (refunds[index].canEdit)
                                      Container(
                                        width: 80.0,
                                        child: SecondaryButton(
                                          height: 30.0,
                                          text: getString(context, "edit"),
                                          buttonBorderColor:
                                              LelloTheme.palleteOf(theme)
                                                  .text(),
                                          onPressed: () {
                                            editRefund(refunds[index]);
                                          },
                                        ),
                                      ),
                                    if (refunds[index].canCancel)
                                      SizedBox(width: Dimens.spacingSmall),
                                    if (refunds[index].canCancel)
                                      PrimaryButton(
                                        height: 30.0,
                                        text: getString(context, "cancel"),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                ResinConfirmationDialog(
                                                    title: refunds[0].type ==
                                                            ResinRefundType
                                                                .advance
                                                        ? getString(context,
                                                            "resin_cancel_advance_confirmation_title")
                                                        : getString(context,
                                                            "resin_cancel_refund_confirmation_title"),
                                                    subtitle: refunds[0].type ==
                                                            ResinRefundType
                                                                .advance
                                                        ? getString(context,
                                                            "resin_cancel_advance_confirmation")
                                                        : getString(context,
                                                            "resin_cancel_refund_confirmation"),
                                                    confirmationFunction: () {
                                                      cancelRefund(
                                                        refunds[index],
                                                      );
                                                    }),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: 0)),
    );
  }

  Widget iconSelector(ResinRefund refund) {
    if (refund.status != ResinRefundStatus.canceled) {
      return SvgPicture.asset("assets/ic_doc_red.svg");
    } else {
      return SvgPicture.asset("assets/ic_doc.svg");
    }
  }
}
