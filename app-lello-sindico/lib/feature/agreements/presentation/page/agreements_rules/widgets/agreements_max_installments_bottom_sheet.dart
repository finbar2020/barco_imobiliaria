import 'package:essentials/essentials.dart' hide Slider;
import 'package:flutter/material.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_rules.dart';

class AgreementsMaxInstallmentsBottomSheet extends StatefulWidget {
  final int maxValue;
  final int minValue;
  final AgreementsRules rules;
  final Function(AgreementsRules newRules) onPressed;

  const AgreementsMaxInstallmentsBottomSheet({
    Key? key,
    this.minValue = 1,
    this.maxValue = 12,
    required this.rules,
    required this.onPressed,
  }) : super(key: key);

  @override
  _AgreementsMaxInstallmentsBottomSheetState createState() =>
      _AgreementsMaxInstallmentsBottomSheetState();
}

class _AgreementsMaxInstallmentsBottomSheetState
    extends State<AgreementsMaxInstallmentsBottomSheet> {
  late double sliderValue;

  @override
  void initState() {
    super.initState();
    sliderValue = widget.rules.installmentQtd.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 400.0),
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingLarge),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getString(context, "agreements_rules_accept_more_installments"),
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Text(
                getString(context,
                    "agreements_rules_accept_more_installments_details"),
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      (widget.maxValue - widget.minValue + 1),
                      (index) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              _labelText(index + widget.minValue),
                              style: _sliderLabelStyle(
                                  index + widget.minValue, theme),
                            ),
                          )),
                ),
              ),
              Slider(
                value: sliderValue,
                onChanged: (value) {
                  setState(() {
                    sliderValue = value;
                  });
                },
                min: widget.minValue.toDouble(),
                max: widget.maxValue.toDouble(),
                divisions: widget.maxValue - widget.minValue,
              ),
              SizedBox(height: Dimens.spacingLarge),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: getString(context, "agreements_rules_change"),
                  onPressed: () {
                    widget.rules.installmentQtd = sliderValue.toInt();
                    widget.onPressed(widget.rules);
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _labelText(int value) {
    if (value == sliderValue ||
        value == widget.minValue ||
        value == widget.maxValue) {
      return "${value}x";
    }
    return "";
  }

  TextStyle _sliderLabelStyle(int value, ThemeData theme) {
    return (value == sliderValue)
        ? LelloTextStyles.body(theme)!.copyWith(color: theme.primaryColor)
        : LelloTextStyles.body(theme)!
            .copyWith(color: LelloTheme.palleteOf(theme).grey());
  }
}
