import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/page/resin_new_advance_page.dart';
import 'package:lello/feature/resin/presentation/resin_receipt_details/page/resin_receipt_details_page.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_status_selector_widget.dart';

class ResinSendReceiptListWidget extends StatelessWidget {
  final List<ResinRefund> refunds;
  final ResinParams params;
  const ResinSendReceiptListWidget({
    Key? key,
    required this.refunds,
    required this.params,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    NumberFormat formatCurrency = NumberFormat.currency(symbol: "R\$");
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
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
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
                                    leading: SvgPicture.asset(
                                        "assets/ic_doc_red.svg"),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          refunds[index].requestDateFormatted,
                                          style: LelloTextStyles.body(theme)
                                              ?.copyWith(
                                                  color: LelloTheme.palleteOf(
                                                          theme)
                                                      .hubText()),
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
                                                  style: LelloTextStyles.body(
                                                      theme),
                                                ),
                                                Text(
                                                  formatCurrency.format(
                                                      refunds[index].value),
                                                  style: LelloTextStyles
                                                          .bodyBold(theme)
                                                      ?.copyWith(
                                                          color: LelloTheme
                                                                  .palleteOf(
                                                                      theme)
                                                              .primary()),
                                                ),
                                              ],
                                            ),
                                            SvgPicture.asset(
                                              "assets/ic_arrow_right.svg",
                                              color: LelloTheme.palleteOf(theme)
                                                  .textOpaque(),
                                            )
                                          ],
                                        ),
                                        SizedBox(height: Dimens.spacingSmall),
                                        ResinStatusSelectorWidget(
                                          context: context,
                                          refundRelatoryStatus:
                                              refunds[index].status ??
                                                  ResinRefundStatus.sended,
                                        ),
                                        SizedBox(height: Dimens.spacingSmall),
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
                          const Divider(height: 0)),
                ),
                SizedBox(height: Dimens.spacingSmall),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: PrimaryButton(
                    text: getString(context, "resin_history_new_advance"),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        ApplicationRoute.resinAdvanceNew,
                        arguments: ResinNewAdvancePageArgs(resinParams: params),
                      );
                    },
                  ),
                ),
                TertiaryButton(
                  text: getString(context, "back"),
                  style: TextStyle(color: theme.primaryColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
    );
  }
}
