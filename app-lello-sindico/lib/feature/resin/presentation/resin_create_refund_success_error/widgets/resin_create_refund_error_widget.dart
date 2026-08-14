import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';

class ResinCreateRefundErrorWidget extends StatelessWidget {
  final ResinRefundType? refundType;
  const ResinCreateRefundErrorWidget({
    Key? key,
    required this.refundType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: LelloTheme.palleteOf(theme).warning(),
      body: Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                    width: 150,
                    height: 150,
                    child: Icon(
                      Icons.error,
                      color: LelloTheme.palleteOf(theme).customColor(),
                      size: 150,
                    )),
              ),
              SizedBox(height: Dimens.spacingMedium),
              Container(
                child: Text(
                  refundType == ResinRefundType.refund
                      ? getString(context, "resin_create_refund_error")
                      : getString(context, "resin_create_advance_error"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.title(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor()),
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Container(
                height: 54.0,
                child: PrimaryButton(
                  buttonColor: LelloTheme.palleteOf(theme).customColor(),
                  child: Text(
                    getString(context, "back"),
                    style: LelloTextStyles.button(theme)
                        ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ]),
      ),
    );
  }
}
