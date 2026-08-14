import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view/comfort_partner_card.dart';
import 'package:shared_features/shared_features.dart';

class ComfortPartnersListViewHorizontalScrolling extends StatefulWidget {
  final List<ComfortPartner> partners;
  final SharedApplicationContainer applicationContainer;
  final Function(ComfortPartner partner) onPressed;
  final Function() initializeAnalyticsTimer;
  final Function() stopAnalyticsTimer;
  final Function() backPressed;
  final Function(ComfortPartnerCategory category) onCategoryDispose;

  const ComfortPartnersListViewHorizontalScrolling({
    Key? key,
    required this.partners,
    required this.onPressed,
    required this.initializeAnalyticsTimer,
    required this.stopAnalyticsTimer,
    required this.backPressed,
    required this.applicationContainer,
    required this.onCategoryDispose,
  }) : super(key: key);

  @override
  State<ComfortPartnersListViewHorizontalScrolling> createState() =>
      _ComfortPartnersListViewHorizontalScrollingState();
}

class _ComfortPartnersListViewHorizontalScrollingState
    extends State<ComfortPartnersListViewHorizontalScrolling>
    with WidgetsBindingObserver {
  ComfortPartnerCategory category = ComfortPartnerCategory.others;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.initializeAnalyticsTimer();
    if (widget.partners.isNotEmpty) {
      category = widget.partners.first.category;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.onCategoryDispose(widget.partners.first.category);
    widget.stopAnalyticsTimer();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (ModalRoute.of(context)?.isCurrent == false) return;
    switch (state) {
      case AppLifecycleState.paused:
        widget.stopAnalyticsTimer();
        break;
      case AppLifecycleState.resumed:
        widget.initializeAnalyticsTimer();
        break;
      case AppLifecycleState.detached:
        widget.stopAnalyticsTimer();
        break;
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Orientation orientation = MediaQuery.of(context).orientation;

    if (widget.partners.isEmpty) {
      return Container();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(Dimens.spacingXSmall,
                          Dimens.spacingXSmall, Dimens.spacingMedium, 0),
                      child: Text(
                        getString(context, "comfort_back_to_categories"),
                        style: LelloTextStyles.subBody(theme)!.copyWith(
                          color: theme.primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: theme.primaryColor,
                        ),
                      ),
                    ),
                    onTap: () {
                      widget.backPressed();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              Dimens.spacingMedium, Dimens.spacing, Dimens.spacingMedium, 0),
          child: Text(
            _getTitle(context),
            style: LelloTextStyles.subtitleBold(theme)
                ?.copyWith(color: theme.primaryColor),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(Dimens.spacingMedium,
              Dimens.spacingXSmall, Dimens.spacingMedium, 0),
          child: Text(
            _getTitleDescription(context),
            style: LelloTextStyles.body(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 100.0),
          child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              primary: false,
              childAspectRatio: orientation == Orientation.landscape ? 2 : 0.88,
              padding: EdgeInsets.symmetric(horizontal: Dimens.spacing),
              crossAxisSpacing: Dimens.spacing,
              // mainAxisSpacing: Dimens.spacing,
              crossAxisCount: 2,
              children: List.generate(widget.partners.length, (index) {
                return ComfortPartnerCard(
                  applicationContainer: widget.applicationContainer,
                  partner: widget.partners[index],
                  onPressed: widget.onPressed,
                );
              })),
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

  String _getTitleDescription(BuildContext context) {
    switch (category) {
      case ComfortPartnerCategory.toYourHome:
        return getString(context, "comfort_to_your_home_description");
      case ComfortPartnerCategory.toYou:
        return getString(context, "comfort_to_you_description");
      case ComfortPartnerCategory.toYourPet:
        return getString(context, "comfort_to_your_pet_description");
      case ComfortPartnerCategory.toYourVehicle:
        return getString(context, "comfort_to_your_vehicle_description");
      case ComfortPartnerCategory.toYourCondo:
        return getString(context, "comfort_others_description");
      case ComfortPartnerCategory.toYourFamily:
        return getString(context, "comfort_to_your_family_description");
      default:
        return getString(context, "comfort_others_description");
    }
  }
}
