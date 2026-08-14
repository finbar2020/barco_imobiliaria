import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgreementsOption extends StatefulWidget {
  final String iconKey;
  final String titleKey;
  final int? optionIndex;
  final VoidCallback onTap;

  const AgreementsOption({
    Key? key,
    required this.iconKey,
    required this.titleKey,
    required this.onTap,
    this.optionIndex,
  }) : super(key: key);

  @override
  _AgreementsOptionState createState() => _AgreementsOptionState();
}

class _AgreementsOptionState extends State<AgreementsOption> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: widget.onTap,
      child: Column(
        children: [
          SizedBox(height: Dimens.spacingMedium),
          Row(
            children: [
              Expanded(flex: 2, child: SvgPicture.asset(widget.iconKey)),
              Expanded(
                flex: 4,
                child: Text(getString(context, widget.titleKey),
                    style: LelloTextStyles.bodyBold(theme)),
              ),
              Text(
                  widget.optionIndex != null
                      ? widget.optionIndex.toString()
                      : "",
                  style: LelloTextStyles.subtitleBold(theme)!
                      .copyWith(color: theme.primaryColor),
                  textAlign: TextAlign.right),
              SizedBox(width: Dimens.spacingLarge),
            ],
          ),
          SizedBox(height: Dimens.spacingMedium),
          Divider(height: 2.0),
        ],
      ),
    );
  }
}
