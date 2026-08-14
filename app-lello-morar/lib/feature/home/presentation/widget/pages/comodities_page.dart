import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/feature/home/presentation/controllers/banner_feature_redirect_handler.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_location_enum.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/feature/banners/presentation/widgets/banners_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';

class ComoditiesPage extends StatefulWidget {
  const ComoditiesPage(
      {super.key,
      this.isGeneric = false,
      required void Function() closeOverlay});
  final bool isGeneric;

  @override
  State<ComoditiesPage> createState() => _ComoditiesPageState();
}

class _ComoditiesPageState extends State<ComoditiesPage> {
  static const double _contentHorizontalPadding = 5.0;
  static const double _titleLeftPadding = 10.0;
  static const double _titleBottomPadding = 8.0;
  static const double _headerTrailingWidth = 56.0;
  static const double _headerTrailingHeight = 48.0;
  static const int _maxFeaturedBanners = 10;

  late SessionBloc sessionBloc;
  CircuitBreakerController circuitBreakController =
      ApplicationContainer.instance().resolve();

  @override
  void initState() {
    super.initState();
    sessionBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: LelloTheme.palleteOf(theme).customColor(),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: _contentHorizontalPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageTitle(),
              buildComfort(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: Dimens.spacing,
        bottom: _titleBottomPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: _titleLeftPadding),
              child: Text(
                getString(context, "comfort"),
                style: LelloTextStyles.title(theme),
              ),
            ),
          ),
          const SizedBox(
            width: _headerTrailingWidth,
            height: _headerTrailingHeight,
          ),
        ],
      ),
    );
  }

  Widget buildBanners() {
    return CircuitBreakerWidget(
      reference: sessionBloc.state.session?.condominium?.reference ?? "",
      appContainer: ApplicationContainer.instance(),
      applicationRbac: ApplicationRbac.morarBanner,
      rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarBanner),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.spacing),
        child: BannersWidget(
          appContainer: ApplicationContainer.instance(),
          title: getString(context, "featured"),
          sessionBloc: sessionBloc,
          maxItems: _maxFeaturedBanners,
          showCounterIndicator: true,
          accessButtonLabel: "Acessar",
          location: BannerLocationEnum.comodidades,
          onBannerClick: (banner) {
            BannerFeatureRedirectHandler.redirect(
              context: context,
              sessionBloc: sessionBloc,
              banner: banner,
              isGeneric: widget.isGeneric,
            );
          },
        ),
      ),
    );
  }

  Widget buildComfort() {
    String reference =
        sessionBloc.state.session?.condominium?.reference.toString() ?? "";
    if (!circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarComodidades,
        reference: reference)) {
      return const SizedBox.shrink();
    }
    return CircuitBreakerWidget(
      appContainer: ApplicationContainer.instance(),
      reference: reference,
      applicationRbac: ApplicationRbac.morarComodidades,
      rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarComodidades),
      child: ComfortPage(
        appContainer: ApplicationContainer.instance(),
        appOriginEnum: AppOriginEnum.owner,
        embedded: true,
        embeddedMiddleWidget: buildBanners(),
      ),
    );
  }
}
