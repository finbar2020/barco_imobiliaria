import 'dart:ui' as ui;

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view/comfort_partner_list_card.dart';
import 'package:shared_features/shared_features.dart';

class ComfortPartnersListViewVerticalScrolling extends StatefulWidget {
  final List<ComfortPartner> partners;
  final Function(ComfortPartner partner) onPressed;
  final SharedApplicationContainer applicationContainer;

  const ComfortPartnersListViewVerticalScrolling({
    Key? key,
    required this.partners,
    required this.onPressed,
    required this.applicationContainer,
  }) : super(key: key);

  @override
  State<ComfortPartnersListViewVerticalScrolling> createState() =>
      _ComfortPartnersListViewVerticalScrollingState();
}

class _ComfortPartnersListViewVerticalScrollingState
    extends State<ComfortPartnersListViewVerticalScrolling> {
  static const double _partnerCardSpacing = 12.0;
  static const double _categoryTitleFontSize = 15.0;

  ComfortPartnerCategory category = ComfortPartnerCategory.others;

  @override
  void initState() {
    super.initState();
    if (widget.partners.isNotEmpty) {
      category = widget.partners.first.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (widget.partners.isEmpty) {
      return Container();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              Dimens.spacing, Dimens.spacing, Dimens.spacing, Dimens.spacing),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                _svgPath(),
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  theme.primaryColor,
                  ui.BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8),
              Text(
                _getTitle(context),
                style:
                    (LelloTextStyles.body(theme) ?? const TextStyle()).copyWith(
                  fontSize: _categoryTitleFontSize,
                  fontWeight: FontWeight.w600,
                  color: LelloTheme.palleteOf(theme).grey(),
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
        Container(
          height: ComfortPartnerListCard.cardHeight(),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: Dimens.spacing),
            itemCount: widget.partners.length,
            itemBuilder: (context, index) {
              return ComfortPartnerListCard(
                applicationContainer: widget.applicationContainer,
                partner: widget.partners[index],
                onPressed: widget.onPressed,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: _partnerCardSpacing);
            },
          ),
        ),
      ],
    );
  }

  String _getTitle(BuildContext context) {
    switch (category) {
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
    switch (category) {
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
