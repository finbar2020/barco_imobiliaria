import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/shared_features.dart';

class DisfavorPartnerDialog extends StatefulWidget {
  final ComfortPartner partner;
  final SharedApplicationContainer applicationContainer;
  final Function(ComfortPartner partner) disfavorPartnerFunction;
  DisfavorPartnerDialog({
    Key? key,
    required this.disfavorPartnerFunction,
    required this.partner,
    required this.applicationContainer,
  }) : super(key: key);

  @override
  State<DisfavorPartnerDialog> createState() => _DisfavorPartnerDialogState();
}

class _DisfavorPartnerDialogState extends State<DisfavorPartnerDialog> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimens.spacingSmall),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 120, maxWidth: 120),
                child: CustomCachedNetworkImage(
                    applicationContainer: widget.applicationContainer,
                    link: widget.partner.partnerIntro.partnerImageLink),
              ),
              SizedBox(height: Dimens.spacingMedium),
              Text(
                widget.partner.partnerIntro.title,
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).grey(),
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              RichText(
                text: TextSpan(
                  style: LelloTextStyles.subtitle(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).grey(),
                  ),
                  children: [
                    TextSpan(
                      text:
                          "${getString(context, "comfort_disfavor_dialog_description_one")}",
                    ),
                    TextSpan(
                      text: widget.partner.partnerIntro.title,
                      style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).grey(),
                      ),
                    ),
                    TextSpan(
                      text:
                          "${getString(context, "comfort_disfavor_dialog_description_two")}",
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              PrimaryButton(
                child: Text(
                    getString(context, "comfort_disfavor_dialog_confirmation")),
                onPressed: () {
                  widget.disfavorPartnerFunction(widget.partner);
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: Dimens.spacingMedium),
              SecondaryButton(
                child:
                    Text(getString(context, "comfort_disfavor_dialog_cancel")),
                buttonBorderColor: theme.primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: Dimens.spacingSmall),
            ],
          ),
        ),
      ),
    );
  }
}
