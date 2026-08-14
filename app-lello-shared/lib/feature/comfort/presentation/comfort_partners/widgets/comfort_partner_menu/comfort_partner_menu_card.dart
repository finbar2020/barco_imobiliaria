import 'dart:ui' as ui;

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';

class ComfortMenuItem extends StatefulWidget {
  final ComfortPartnerCategory category;
  final Function() onTap;
  const ComfortMenuItem({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ComfortMenuItem> createState() => _ComfortMenuItemState();
}

class _ComfortMenuItemState extends State<ComfortMenuItem> {
  static const double _categoryLabelFontSize = 15.0;

  late bool activeManager;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: widget.onTap,
      child: Card(
        color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        shadowColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: 56.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    _svgPath(),
                    colorFilter: ColorFilter.mode(
                      theme.primaryColor,
                      ui.BlendMode.srcIn,
                    ),
                  ),
                  if (widget.category == ComfortPartnerCategory.toYourCondo)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        getString(context, "lello_hub_badge_new"),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    _getTitle(context),
                    maxLines: 1,
                    style: (LelloTextStyles.body(theme) ?? const TextStyle())
                        .copyWith(
                      fontSize: _categoryLabelFontSize,
                      fontWeight: FontWeight.w600,
                      color: LelloTheme.palleteOf(theme).grey(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle(BuildContext context) {
    switch (widget.category) {
      case ComfortPartnerCategory.toYourHome:
        return getString(context, "comfort_to_your_home");
      case ComfortPartnerCategory.toYou:
        return getString(context, "comfort_to_you");
      case ComfortPartnerCategory.toYourPet:
        return getString(context, "comfort_to_your_pet");
      case ComfortPartnerCategory.toYourVehicle:
        return getString(context, "comfort_to_your_vehicle");
      case ComfortPartnerCategory.toYourCondo:
        return getString(context, "comfort_to_your_condo");
      case ComfortPartnerCategory.toYourFamily:
        return getString(context, "comfort_to_your_family");
      default:
        return getString(context, "comfort_others");
    }
  }

  String _svgPath() {
    switch (widget.category) {
      case ComfortPartnerCategory.toYou:
        return "assets/ic_comfort_to_you.svg";
      case ComfortPartnerCategory.toYourHome:
        return "assets/ic_comfort_to_your_home.svg";
      case ComfortPartnerCategory.toYourPet:
        return "assets/ic_comfort_to_your_pet.svg";
      case ComfortPartnerCategory.toYourVehicle:
        return "assets/ic_comfort_to_your_vehicle.svg";
      case ComfortPartnerCategory.toYourCondo:
        return "assets/ic_comfort_to_your_condo.svg";
      case ComfortPartnerCategory.toYourFamily:
        return "assets/ic_comfort_to_your_family.svg";
      case ComfortPartnerCategory.others:
        return "assets/ic_comfort_others.svg";
    }
  }
}
