import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_menu/comfort_partner_menu.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view/comfort_partners_list_view_horizontal_scrolling.dart';
import 'package:shared_features/shared_features.dart';

class ComfortPartnerViewWidget extends StatefulWidget {
  final ComfortPartnersController comfortPartnersController;
  final List<ComfortPartnerCategory> categories;
  final Function(ComfortPartnerCategory category) onTap;
  final Function(ComfortPartner partner) onPartnerSelected;
  final Function() backPressed;
  final SharedApplicationContainer applicationContainer;
  final bool checkYourCondo;
  final AppOriginEnum appOriginEnum;
  final SharedApplicationContainer appContainer;

  const ComfortPartnerViewWidget({
    Key? key,
    required this.comfortPartnersController,
    required this.categories,
    required this.onTap,
    required this.onPartnerSelected,
    required this.backPressed,
    required this.applicationContainer,
    required this.checkYourCondo,
    required this.appOriginEnum,
    required this.appContainer,
  }) : super(key: key);

  @override
  State<ComfortPartnerViewWidget> createState() =>
      _ComfortPartnerViewWidgetState();
}

class _ComfortPartnerViewWidgetState extends State<ComfortPartnerViewWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.checkYourCondo == false &&
        widget.categories.contains(ComfortPartnerCategory.toYourCondo))
      widget.categories.remove(ComfortPartnerCategory.toYourCondo);
    if (widget.comfortPartnersController.currentCategory == null) {
      return ComfortPartnerMenu(
        categories: widget.categories,
        onTap: widget.onTap,
        appOriginEnum: widget.appOriginEnum,
        comfortPartnersController: widget.comfortPartnersController,
        appContainer: widget.appContainer,
      );
    }
    return ComfortPartnersListViewHorizontalScrolling(
      applicationContainer: widget.applicationContainer,
      partners: widget.comfortPartnersController.partnersList(
          category: widget.comfortPartnersController.currentCategory),
      onPressed: widget.onPartnerSelected,
      backPressed: widget.backPressed,
      initializeAnalyticsTimer: () => widget.comfortPartnersController
          .comfortCategoryAnalyticsTimerStart(
              widget.comfortPartnersController.currentCategory ??
                  ComfortPartnerCategory.others,
              debugEventIdentifier: "comfort_partner_view_widget"),
      stopAnalyticsTimer: () =>
          widget.comfortPartnersController.comfortCategoryAnalyticsStopTimer(),
      onCategoryDispose: (category) => widget.comfortPartnersController
          .analyticsComfortCategoryPageBack(category),
    );
  }

  void updateStep(ComfortPartnerCategory? category) {
    setState(() {
      widget.comfortPartnersController.changeCategory(category);
    });
  }
}
