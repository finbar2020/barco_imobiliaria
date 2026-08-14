import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_quotas.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreements_taxes_information_bottom.dart';

class AgreementsQuotaAvailableWidget extends StatefulWidget {
  final AgreementQuota agreementQuota;
  final bool isChecked;
  final Function(bool?) onChanged;
  final Function() dialogOnPressed;
  const AgreementsQuotaAvailableWidget({
    Key? key,
    required this.agreementQuota,
    required this.isChecked,
    required this.onChanged,
    required this.dialogOnPressed,
  }) : super(key: key);

  @override
  _AgreementsQuotaAvailableWidgetState createState() =>
      _AgreementsQuotaAvailableWidgetState();
}

class _AgreementsQuotaAvailableWidgetState
    extends State<AgreementsQuotaAvailableWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.grey,
        child: Container(
          child: Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  activeColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                      // Making around shape
                      borderRadius: BorderRadius.circular(4)),
                  side: BorderSide(width: 0.5),
                  value: widget.isChecked,
                  onChanged: widget.onChanged,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.agreementQuota.date,
                      style: LelloTextStyles.subtitle(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).textLight(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        getString(context, 'original_value'),
                        style: LelloTextStyles.caption(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).textLight(),
                        ),
                      ),
                    ),
                    Text(
                      widget.agreementQuota.origin,
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          InkWell(
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {
                              Modal.showBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      AgreementsTaxesInformationBottom(
                                        dialogOnPressed: widget.dialogOnPressed,
                                      ));
                            },
                            child: Row(
                              children: [
                                Text(
                                  getString(context, 'taxes'),
                                  style:
                                      LelloTextStyles.caption(theme)!.copyWith(
                                    color:
                                        LelloTheme.palleteOf(theme).textLight(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/ic_information.svg")
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.agreementQuota.fee,
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        getString(context, 'update_value'),
                        style: LelloTextStyles.caption(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).textLight(),
                        ),
                      ),
                    ),
                    Text(
                      widget.agreementQuota.total,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(height: Dimens.spacing),
                    Text(
                      "${widget.agreementQuota.daysRemanining} ${getString(context, 'days_remaining_agreement')}",
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        overflow: TextOverflow.ellipsis,
                        color: LelloTheme.palleteOf(theme).warning(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
