import 'dart:developer';

import 'package:essentials/analytics/analytics_timer.dart';
import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/home/data/home_item_weight_cache.dart';
import 'package:morar/feature/home/domain/entity/home_item_enum.dart';
import 'package:morar/feature/home/presentation/bloc/home_bloc.dart';
import 'package:morar/feature/home/presentation/bloc/home_state.dart';
import 'package:morar/feature/home/presentation/controllers/banner_feature_redirect_handler.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_location_enum.dart';
import 'package:morar/feature/home/presentation/widget/bella_intro_modal.dart';
import 'package:morar/feature/home/presentation/widget/bella_search_component.dart';
import 'package:morar/feature/home/presentation/widget/dashboard_item.dart';
import 'package:morar/feature/home/presentation/widget/empty_state_widget.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/feature/banners/presentation/widgets/banners_widget.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../session/presentation/bloc/session_state.dart';
import '../../../../sub_user/presentation/pages/edit/send_access_renew_request_success_page.dart';
import '../agreements_dialog.dart';
import '../expiration_dialog.dart';

class HomePage extends StatefulWidget {
  final VoidCallback closeOverlay;
  final bool isGeneric;
  final VoidCallback pictureOnTap;
  final VoidCallback? onNavigateToComodidades;

  const HomePage({
    Key? key,
    required this.closeOverlay,
    required this.pictureOnTap,
    this.isGeneric = false,
    this.onNavigateToComodidades,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  HomeBloc bloc = ApplicationContainer.instance().resolve();
  CarouselSliderController buttonCarouselController =
      CarouselSliderController();
  GetToken getToken = ApplicationContainer.instance().resolve();
  late AnalyticsTimer homeStartAnalyticsTimer;

  late SessionBloc sessionBloc;
  bool activeManager = false;
  bool showExpirationDialog = true;
  CircuitBreakerController circuitBreakController =
      ApplicationContainer.instance().resolve();

  List<HomeItemEnum> itens = [
    HomeItemEnum.iaBella,
    HomeItemEnum.comfort,
    HomeItemEnum.reserves,
    HomeItemEnum.billets,
    HomeItemEnum.insurance,
    HomeItemEnum.agreements,
    HomeItemEnum.accessControl,
    HomeItemEnum.tdb,
    HomeItemEnum.horta,
  ];

  SharedPreferences? sharedPreferences;

  List<HomeItemEnum> mainDashboardItems = [
    HomeItemEnum.billets,
    HomeItemEnum.changeOwnership,
    HomeItemEnum.agreements,
  ];

  @override
  void initState() {
    bloc.getCards();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final canShowAgreements =
          await AgreementsDialog.canShowAgreementsDialog();
      if (canShowAgreements) {
        await AgreementsDialog.show(context: context);
        if (sessionBloc.state is SessionLoadedState) {
          bloc.checkExpiration().then((isUnder30days) async {
            sharedPreferences = await SharedPreferences.getInstance();
            final show = sharedPreferences?.getBool('show_expiration_dialog');
            if (isUnder30days && (show == null || show == true)) {
              if (showExpirationDialog) {
                final isOwner = bloc.isOwner;
                await _showExpirationDialog(context, isOwner);
              }
            }
          });
        }
      } else {
        if (sessionBloc.state is SessionLoadedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            bloc.checkExpiration().then((isUnder30days) async {
              sharedPreferences = await SharedPreferences.getInstance();
              final show = sharedPreferences?.getBool('show_expiration_dialog');
              if (isUnder30days && (show == null || show == true)) {
                if (showExpirationDialog) {
                  final isOwner = bloc.isOwner;
                  await _showExpirationDialog(context, isOwner);
                }
              }
            });
          });
        }
      }
    });
    super.initState();
    startHomeAnalyticsTimer();
    sessionBloc = BlocProvider.of(context);
    activeManager =
        sessionBloc.state.session?.condominium?.active_manager ?? false;
  }

  @override
  void dispose() {
    bloc.favorites = [];
    stopHomeAnalyticsTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (ModalRoute.of(context)?.isCurrent == false) return;
    switch (state) {
      case AppLifecycleState.resumed:
        startHomeAnalyticsTimer();
        break;
      case AppLifecycleState.paused:
        stopHomeAnalyticsTimer();
        break;
      case AppLifecycleState.detached:
        stopHomeAnalyticsTimer();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: LelloTheme.palleteOf(theme).customColor(),
      child: BlocProvider.value(
        value: bloc,
        child: BlocBuilder(
          bloc: bloc,
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(5.0),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(sessionBloc, context, theme),
                  StreamBuilder<List<CircuitItemRule>>(
                      stream: circuitBreakController.ruleStream.stream,
                      builder: (context, snapshot) {
                        return _buildBody(
                            sessionBloc, context, state as HomeState, theme);
                      }),
                ],
              )),
            );
          },
        ),
      ),
    );
  }

  Padding _buildUserInfo(
      SessionBloc sessionBloc, BuildContext context, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(top: Dimens.spacing),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: buildGreetings(sessionBloc.state.session?.me, context),
          ),
          Visibility(
            visible: sessionBloc.iSPreferencesPersonalizationActive,
            child: InkWell(
              onTap: () {
                bloc.animate.value = false;
                Navigator.pushNamed(context, ApplicationRoute.preferencesHome);
              },
              child: ValueListenableBuilder<bool>(
                valueListenable: bloc.animate,
                builder: (BuildContext context, bool value, child) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0, top: 10),
                    child: AvatarGlow(
                      animate: value,
                      glowColor: value ? theme.primaryColor : Colors.white,
                      glowRadiusFactor: 0.5,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          Icon(
                            Icons.star_border_outlined,
                            size: 30.0,
                            color: LelloTheme.palleteOf(theme).grey(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool hasAnyHomeAccess(SessionBloc sessionBloc,
      CircuitBreakerController circuitBreakController) {
    final defaultItems = HomeItemEnumUtils.homePageItems;
    final hasDashboardAccess = defaultItems.any((item) =>
        sessionBloc.checkRback(item.rbac(sessionBloc)) &&
        circuitBreakController.checkVisible(
          applicationRbac: item.rbac(sessionBloc),
          reference:
              sessionBloc.state.session?.condominium?.reference.toString() ??
                  '',
        ));
    final hasBellaAccess = sessionBloc.checkRback(ApplicationRbac.morarIaBella);
    final hasBannerAccess =
        sessionBloc.checkRback(ApplicationRbac.morarBanner) &&
            circuitBreakController.checkVisible(
              applicationRbac: ApplicationRbac.morarBanner,
              reference: sessionBloc.state.session?.condominium?.reference
                      .toString() ??
                  '',
            );
    return hasDashboardAccess || hasBellaAccess || hasBannerAccess;
  }

  Widget _buildBody(SessionBloc sessionBloc, BuildContext context,
      HomeState state, ThemeData theme) {
    final hasAnyAccess = hasAnyHomeAccess(sessionBloc, circuitBreakController);
    if (!hasAnyAccess) {
      return Center(
        child: EmptyStateWidget(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircuitBreakerWidget(
            reference: sessionBloc.state.session?.condominium?.reference ?? "",
            appContainer: ApplicationContainer.instance(),
            applicationRbac: ApplicationRbac.morarIaBella,
            rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarIaBella),
            child: BellaSearchComponent()),
        Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Text(
            "Acessos recentes",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: LelloTheme.palleteOf(theme).textOpaque(),
            ),
          ),
        ),
        FutureBuilder<List<Widget>>(
          future: _buildDashboard(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final items = snapshot.data ?? [];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: items,
            );
          },
        ),
        CircuitBreakerWidget(
          reference: sessionBloc.state.session?.condominium?.reference ?? "",
          appContainer: ApplicationContainer.instance(),
          applicationRbac: ApplicationRbac.morarBanner,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarBanner),
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingSmall),
            child: BannersWidget(
              appContainer: ApplicationContainer.instance(),
              sessionBloc: sessionBloc,
              location: BannerLocationEnum.home,
              maxItems: 3,
              showCounterIndicator: true,
              compact: true,
              stacked: true,
              onBannerClick: (banner) {
                BannerFeatureRedirectHandler.redirect(
                  context: context,
                  sessionBloc: sessionBloc,
                  banner: banner,
                  isGeneric: widget.isGeneric,
                  onNavigateToComodities: widget.onNavigateToComodidades,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePicture(BuildContext context, Me? me) {
    ThemeData theme = Theme.of(context);
    return Container(
        width: 50.0,
        height: 50.0,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.width / 25,
        ),
        //padding: EdgeInsets.all(3.0),
        child: InkWell(
          onTap: () {
            log("pictureOnTap");
            stopHomeAnalyticsTimer();
            widget.pictureOnTap();
          },
          child: (me != null)
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10000.0),
                    child: CustomCachedNetworkImage(
                      link: me.pictureLink,
                      errorImageAssetsPath: "assets/user_placeholder.svg",
                      applicationContainer:
                          ApplicationContainer.instance().resolve(),
                    ),
                  ),
                )
              : SvgPicture.asset("assets/user_placeholder.svg", width: 32),
        ),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: LelloTheme.palleteOf(theme).customColor(), width: 2),
        ));
  }

  Widget buildGreetings(Me? me, BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 8.0),
      child: Text(
        me != null ? me.getGreetings(context, me) : "",
        style: LelloTextStyles.title(theme),
      ),
    );
  }

  Future<List<Widget>> _buildDashboard(BuildContext context) async {
    final defaultItems = HomeItemEnumUtils.defaultDashboardOrder;
    final lruOrder =
        await HomeItemWeightCache.getOrder(defaultItems, sessionBloc);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 20) / 3;
    return List.generate(
      lruOrder.length,
      (index) => SizedBox(
        width: cardWidth,
        child: CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.condominium?.reference.toString() ??
                  "",
          applicationRbac: lruOrder[index].rbac(sessionBloc),
          rbacEnabled:
              sessionBloc.checkRback(lruOrder[index].rbac(sessionBloc)),
          child: DashboardItem(
            imagePath: lruOrder[index].imagePath(widget.isGeneric),
            text: lruOrder[index].text(),
            canHyphenateText: true,
            route: lruOrder[index].routes(),
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(lruOrder[index]);
              setState(() {});
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
            startAnalyticsTimer: startHomeAnalyticsTimer,
            stopAnalyticsTimer: stopHomeAnalyticsTimer,
            isHighlighted: lruOrder[index].isHighlighted(),
            onComfortTap: lruOrder[index] == HomeItemEnum.comfort
                ? widget.onNavigateToComodidades
                : null,
          ),
        ),
      ),
    );
  }

  String addSoftHyphens(String text, {int interval = 6}) {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      // Insere soft hyphen após cada [interval] caracteres
      if ((i + 1) % interval == 0 && i != text.length - 1) {
        buffer.write('\u00AD');
      }
    }
    return buffer.toString();
  }

  List<HomeItemEnum> getFavoritesCards(
      List<HomeItemEnum> cards, List<HomeItemEnum> itens) {
    if (cards.isEmpty) {
      return itens;
    } else {
      return cards;
    }
  }

  Future<AccessToken?> get _getAccessToken async {
    final token = await getToken.call(GetTokenParams(role: null));
    return token.getOrElse(() => null);
  }

  Future<String> get _getUserType async {
    final token = await _getAccessToken;
    return token?.selectedRole ?? "";
  }

  String hyphenateText(String text, {int maxSegmentLength = 9}) {
    if (text.trim().contains(' ')) return text;

    if (text.length <= maxSegmentLength) return text;

    final buffer = StringBuffer();
    int count = 0;

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      count++;
      if (count >= maxSegmentLength && i != text.length - 1) {
        buffer.write('-\u200B');
        count = 0;
      }
    }

    return buffer.toString();
  }

  void startHomeAnalyticsTimer() async {
    homeStartAnalyticsTimer = AnalyticsTimer(
      userType: await _getUserType,
      unitValue: sessionBloc.state.session!.unity?.title?.toString() ?? "",
      userId: sessionBloc.state.session?.me?.id ?? "",
      event: AnalyticsEventsOwner.morarHomeTemporizador(),
      referenceValue:
          sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
      appOrigin: AppOriginEnum.owner,
    );
  }

  void stopHomeAnalyticsTimer() {
    homeStartAnalyticsTimer.stopTimer();
  }

  Future _showExpirationDialog(
    BuildContext context,
    bool isOwner,
  ) {
    showExpirationDialog = false;
    return showDialog(
      context: context,
      builder: (ctx) => Center(
        child: Dialog(
          child: ExpirationDialog(
            onRenewalRequestPressed: () async {
              final success = await bloc.requestAccessRenewal();
              if (success) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const SendAccessRenewRequestSuccessPage(),
                  ),
                );
              }
            },
            isOwner: isOwner,
            onChecked: (notShowAgain) {
              sharedPreferences?.setBool(
                  'show_expiration_dialog', !notShowAgain);
            },
          ),
        ),
      ),
    );
  }
}
