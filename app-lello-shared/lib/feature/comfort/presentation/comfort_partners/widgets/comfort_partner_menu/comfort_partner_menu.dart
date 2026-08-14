import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/core/rbac/shared_application_rbac.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_menu/comfort_partner_menu_card.dart';
import 'package:shared_features/shared_features.dart';

class ComfortPartnerMenu extends StatefulWidget {
  final Function(ComfortPartnerCategory category) onTap;
  final List<ComfortPartnerCategory> categories;
  final AppOriginEnum appOriginEnum;
  final ComfortPartnersController comfortPartnersController;
  final SharedApplicationContainer appContainer;
  const ComfortPartnerMenu({
    Key? key,
    required this.onTap,
    required this.categories,
    required this.appOriginEnum,
    required this.comfortPartnersController,
    required this.appContainer,
  }) : super(key: key);

  @override
  State<ComfortPartnerMenu> createState() => _ComfortPartnerMenuState();
}

class _ComfortPartnerMenuState extends State<ComfortPartnerMenu> {
  static const double _menuCardSpacing = 12.0;

  late CircuitBreakerController circuitBreakController;
  @override
  Widget build(BuildContext context) {
    circuitBreakController =
        widget.appContainer.resolve<CircuitBreakerController>();
    // Filtrando categorias baseado no circuit break.
    final visibleCategories = widget.categories
        .where((category) => _categoryIsVisible(category))
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimens.spacing),
        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: Dimens.spacing),
            itemCount: visibleCategories.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: _menuCardSpacing),
            itemBuilder: (context, index) {
              final category = visibleCategories[index];
              return widget.appOriginEnum == AppOriginEnum.owner
                  ? _buildOwnerItem(category)
                  : ComfortMenuItem(
                      category: category,
                      onTap: () => widget.onTap(category),
                    );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerItem(ComfortPartnerCategory category) {
    var session = widget.comfortPartnersController.getSessionBloc();
    String reference =
        session.state.session?.condominium?.reference.toString() ?? "";
    String rbac = _getRbacForCategory(category) ?? "";
    return CircuitBreakerWidget(
      child: ComfortMenuItem(
        category: category,
        onTap: () => widget.onTap(category),
      ),
      applicationRbac: rbac,
      reference: reference,
      appContainer: widget.appContainer,
      rbacEnabled: session.checkRback(rbac),
    );
  }

  bool _categoryIsVisible(ComfortPartnerCategory category) {
    //Valida se é o App Moradores para aplicar regras de rbac
    if (widget.appOriginEnum == AppOriginEnum.owner) {
      var session = widget.comfortPartnersController.getSessionBloc();

      String reference =
          session.state.session?.condominium?.reference.toString() ?? "";
      String rbac = _getRbacForCategory(category) ?? "";

      return circuitBreakController.checkVisible(
        applicationRbac: rbac,
        reference: reference,
      );
    }
    return true;
  }

  String? _getRbacForCategory(ComfortPartnerCategory category) {
    switch (category) {
      case ComfortPartnerCategory.toYourHome:
        return SharedApplicationRbac.morarComodidadesCasa;
      case ComfortPartnerCategory.toYou:
        return SharedApplicationRbac.morarComodidadesVoce;
      case ComfortPartnerCategory.toYourPet:
        return SharedApplicationRbac.morarComodidadesPet;
      case ComfortPartnerCategory.toYourVehicle:
        return SharedApplicationRbac.morarComodidadesVeiculo;
      case ComfortPartnerCategory.others:
      case ComfortPartnerCategory.toYourFamily:
        return SharedApplicationRbac.morarComodidadesOutros;
      default:
        return null;
    }
  }
}
