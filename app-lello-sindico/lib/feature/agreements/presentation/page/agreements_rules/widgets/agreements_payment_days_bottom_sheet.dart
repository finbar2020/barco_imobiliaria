import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_rules.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_rules/widgets/agreements_alert_dialog.dart';

class AgreementsPaymentDaysBottomSheet extends StatefulWidget {
  final AgreementsRules rules;
  final Function(AgreementsRules newRules) onPressed;

  const AgreementsPaymentDaysBottomSheet({
    Key? key,
    required this.rules,
    required this.onPressed,
  }) : super(key: key);

  @override
  _AgreementsPaymentDaysBottomSheetState createState() =>
      _AgreementsPaymentDaysBottomSheetState();
}

class _AgreementsPaymentDaysBottomSheetState
    extends State<AgreementsPaymentDaysBottomSheet> {
  late List<int> newPaymentDays;

  @override
  void initState() {
    newPaymentDays = widget.rules.days;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 600.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getString(context, "agreements_rules_change_payment_dates"),
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Text(
                getString(
                    context, "agreements_rules_change_payment_dates_details"),
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              _buildDays(context),
              SizedBox(height: Dimens.spacingLarge),
              Container(
                width: double.infinity,
                child: PrimaryButton(
                    text: getString(context, "agreements_rules_change"),
                    onPressed: () {
                      widget.rules.days = newPaymentDays;
                      widget.onPressed(widget.rules);
                      Navigator.pop(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDays(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        _buildDaysRow(min: 1),
        _buildDaysRow(min: 8),
        _buildDaysRow(min: 15),
        _buildDaysRow(min: 22),
        _buildDaysRow(min: 29)
      ]),
    );
  }

  Row _buildDaysRow({required int min}) {
    int max = min + 6;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        max - min + 1,
        (index) {
          int day = min + index;
          return InkWell(
            onTap: () {
              setState(() {
                _addOrRemoveDay(day);
              });
            },
            child: day <= 31
                ? Padding(
                    padding: EdgeInsets.only(bottom: Dimens.spacingSmall),
                    child: Container(
                      padding: EdgeInsets.all(Dimens.spacingSmall),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _setBackgroundDayColor(day),
                      ),
                      width: 40.0,
                      height: 40.0,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Center(
                          child: Text(
                            day.toString(),
                            style: _setTextDayStyle(day),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 40.0,
                    height: 40.0,
                  ),
          );
        },
      ),
    );
  }

  Color? _setBackgroundDayColor(int day) {
    ThemeData theme = Theme.of(context);
    return newPaymentDays.contains(day) ? theme.primaryColor : null;
  }

  TextStyle _setTextDayStyle(int day) {
    ThemeData theme = Theme.of(context);
    return newPaymentDays.contains(day)
        ? LelloTextStyles.body(theme)!.copyWith(color: Colors.white)
        : LelloTextStyles.body(theme)!
            .copyWith(color: LelloTheme.palleteOf(theme).grey());
  }

  void _addOrRemoveDay(int day) {
    if (newPaymentDays.contains(day)) {
      newPaymentDays.remove(day);
    } else {
      if (newPaymentDays.length < 5) {
        if (day > 28) {
          showDialog(
            context: context,
            builder: (context) => AgreementsAlertDialog(),
          );
        }
        newPaymentDays.add(day);
      } else {
        Flushbar(
          message: getString(
              context, "agreements_rules_payment_days_maximum_number"),
          duration: Duration(seconds: 4),
        )..show(context);
      }
    }
  }
}
