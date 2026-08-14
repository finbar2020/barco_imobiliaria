import 'package:essentials/essentials.dart' hide Slider;
import 'package:flutter/material.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';

class AgreementInstallmentsBottomSheet extends StatefulWidget {
  final Function() onPressed;
  final int min;
  final AgreementCreated agreement;
  const AgreementInstallmentsBottomSheet({
    Key? key,
    required this.onPressed,
    required this.min,
    required this.agreement,
  }) : super(key: key);

  @override
  State<AgreementInstallmentsBottomSheet> createState() =>
      _AgreementInstallmentsBottomSheetState();
}

class _AgreementInstallmentsBottomSheetState
    extends State<AgreementInstallmentsBottomSheet> {
  int min = 1;
  int max = 12;
  double sliderValue = 1.0;

  @override
  void initState() {
    super.initState();
    if (widget.min > max) {
      min = max;
    } else {
      min = widget.min;
    }
    sliderValue = (min).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 340.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              color: LelloTheme.palleteOf(theme).grey(),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
            Text(
              getString(context, "agreements_liked_installments"),
              style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).hubText(),
              ),
            ),
            SizedBox(height: Dimens.spacing),
            Wrap(
              children: [
                RichText(
                  text: new TextSpan(
                    style: LelloTextStyles.subtitle(theme),
                    children: <TextSpan>[
                      TextSpan(
                          text: getString(context,
                              "agreements_liked_installments_description"),
                          style: LelloTextStyles.subtitle(theme)),
                      TextSpan(
                          text:
                              " ${getString(context, "agreements_liked_installments_description_complement")}",
                          style: LelloTextStyles.subtitle(theme)!
                              .copyWith(color: theme.primaryColor)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimens.spacingMedium),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    ((max - min) + 1),
                    (index) => Text(
                          "${index + min}x",
                          style: _sliderLabelStyle(index + min, theme),
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
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: (max - min) == 0 ? 1 : max - min,
            ),
            SizedBox(height: Dimens.spacingMedium),
            Container(
              width: double.infinity,
              height: 52.0,
              child: PrimaryButton(
                text: getString(context, "agreements_accept_next"),
                onPressed: () {
                  widget.agreement.installmentQuantity = sliderValue.toInt();
                  widget.onPressed();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _sliderLabelStyle(int index, ThemeData theme) {
    int installment = index;
    if (installment == min) {
      return (installment == sliderValue)
          ? LelloTextStyles.body(theme)!.copyWith(color: theme.primaryColor)
          : LelloTextStyles.body(theme)!
              .copyWith(color: LelloTheme.palleteOf(theme).grey());
    }
    if (installment == max) {
      return (installment == sliderValue)
          ? LelloTextStyles.body(theme)!.copyWith(color: theme.primaryColor)
          : LelloTextStyles.body(theme)!
              .copyWith(color: LelloTheme.palleteOf(theme).grey());
    }
    return (installment == sliderValue)
        ? LelloTextStyles.body(theme)!.copyWith(color: theme.primaryColor)
        : LelloTextStyles.body(theme)!.copyWith(color: Colors.transparent);
  }
}
