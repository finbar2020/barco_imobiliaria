import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/nonpayment/domain/entity/nonpayments.dart';
import 'package:lello/feature/nonpayment/presentation/widgets/nonpayments_Item_container_widget.dart';
import 'package:lello/feature/nonpayment/presentation/widgets/nonpayments_build_title_subtitle_widget.dart';

class DetailsListWidget extends StatefulWidget {
  final NonPayment payments;
  
  const DetailsListWidget({Key? key, required this.payments}) : super(key: key);

  @override
  State<DetailsListWidget> createState() => _DetailsListWidgetState();
}

class _DetailsListWidgetState extends State<DetailsListWidget> {
    Map<int, bool> _isExpanded = Map();
     final formatCurrency = new NumberFormat.currency(symbol: "R\$");
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: widget.payments.details == null ? 0 : widget.payments.details!.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ExpansionTile(
            key: PageStorageKey<int>(index),
            initiallyExpanded: false,
            title: Row(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(Dimens.spacingSmall, 0, 0, 0),
                    child: TitleSubtitleWidget(
                      subTitle:
                          widget.payments.details![index]!.resident!.unit!.title!,
                      title: getString(context, "non_payments_item_title"),
                      usingSpacingBottom: false,
                    ),
                  ),
                ),
                _isExpanded[index] == false || _isExpanded[index] == null
                    ? Flexible(
                        child: TitleSubtitleWidget(
                          subTitle: formatCurrency
                              .format(widget.payments.details![index]!.value),
                          title: getString(context,
                              "non_payments_details_container_value_penalty"),
                          usingSpacingBottom: false,
                        ),
                      )
                    : Container()
              ],
            ),
            onExpansionChanged: ((newState) {
              setState(() {
                _isExpanded[index] = newState;
              });
            }),
            children: <Widget>[
              ItemContainerWidget(
                detail: widget.payments.details![index]!,
              )
            ],
          );
        },
      ),
    );
  }
}
