import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/home/presentation/widget/sliver/widget/sliver_widget.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:lello/feature/home/presentation/controllers/banner_feature_redirect_handler.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_location_enum.dart';
import 'package:shared_features/feature/banners/presentation/widgets/banners_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/shared_features.dart';

class ComoditiesPage extends StatefulWidget {
  const ComoditiesPage({super.key, this.isGeneric = false});

  final bool isGeneric;

  @override
  State<ComoditiesPage> createState() => _ComoditiesPageState();
}

class _ComoditiesPageState extends State<ComoditiesPage> {
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
    return StreamBuilder<List<CircuitItemRule>>(
        stream: circuitBreakController.ruleStream.stream,
        builder: (context, snapshot) {
          return SliverWidget(
            isGeneric: widget.isGeneric,
            children: <Widget>[
              SliverToBoxAdapter(
                child: buildGreetings(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Dimens.spacingSmall),
                  child: buildComfort(),
                ),
              ),
            ],
          );
        });
  }

  Widget buildBanners() {
    return CircuitBreakerWidget(
      reference:
          sessionBloc.state.session?.selectedCondominium?.reference ?? "",
      appContainer: ApplicationContainer.instance(),
      applicationRbac: ApplicationRbac.sindicoBanner,
      rbacEnabled: sessionBloc.checkRback(ApplicationRbac.sindicoBanner),
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
            );
          },
        ),
      ),
    );
  }

  Widget buildGreetings() {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: Dimens.spacingMedium,
        top: Dimens.spacingMedium,
        right: Dimens.spacingMedium,
      ),
      child: Text(
        getString(context, "comfort"),
        style: LelloTextStyles.title(theme),
      ),
    );
  }

  Widget buildComfort() {
    String reference =
        sessionBloc.state.session?.selectedCondominium?.reference.toString() ??
            "";
    if (!circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoComodidades,
        reference: reference)) {
      return const SizedBox.shrink();
    }
    return CircuitBreakerWidget(
      appContainer: ApplicationContainer.instance(),
      reference: reference,
      applicationRbac: ApplicationRbac.sindicoComodidades,
      rbacEnabled: sessionBloc.checkRback(ApplicationRbac.sindicoComodidades),
      child: ComfortPage(
        appContainer: ApplicationContainer.instance(),
        appOriginEnum: AppOriginEnum.manager,
        embedded: true,
        embeddedMiddleWidget: buildBanners(),
      ),
    );
  }
}
