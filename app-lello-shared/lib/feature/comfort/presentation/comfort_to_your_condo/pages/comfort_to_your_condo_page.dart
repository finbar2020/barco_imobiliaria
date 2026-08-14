import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_your_condo_remote_config.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/pages/comfort_my_requests_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_partner_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view/comfort_partner_card.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/widgets/comfort_to_your_condo_onboarding.dart';
import 'package:shared_features/shared_features.dart';

class ToYourCondoPage extends StatefulWidget {
  final ComfortPartnersController comfortPartnersController;
  final SharedApplicationContainer appContainer;
  final AppOriginEnum appOriginEnum;
  final String reference;
  final String? unit;
  const ToYourCondoPage({
    Key? key,
    required this.comfortPartnersController,
    required this.appContainer,
    required this.appOriginEnum,
    required this.reference,
    this.unit,
  }) : super(key: key);

  @override
  State<ToYourCondoPage> createState() => _ToYourCondoPageState();
}

class _ToYourCondoPageState extends State<ToYourCondoPage>
    with WidgetsBindingObserver {
  List<String> partners = [];

  //TODO: Reavaliar ScrollIndicator
  bool showScrollIndicator = false;
  bool isScrollable = true;
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController = ScrollController()..addListener(_onScroll);
    widget.comfortPartnersController.comfortCategoryAnalyticsTimerStart(
        ComfortPartnerCategory.toYourCondo,
        debugEventIdentifier: "to_your_condo_init_state");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    widget.comfortPartnersController.categoriesToYourCondoExpanded
        .forEach((key, value) {
      widget.comfortPartnersController.categoriesToYourCondoExpanded[key] =
          false;
    });
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (ModalRoute.of(context)?.isCurrent == false) return;
    switch (state) {
      case AppLifecycleState.paused:
        widget.comfortPartnersController.comfortCategoryAnalyticsStopTimer();
        break;
      case AppLifecycleState.resumed:
        widget.comfortPartnersController.comfortCategoryAnalyticsTimerStart(
            ComfortPartnerCategory.toYourCondo,
            debugEventIdentifier: "to_your_condo_resumed");
        break;
      case AppLifecycleState.detached:
        widget.comfortPartnersController.comfortCategoryAnalyticsStopTimer();
        break;
      default:
        break;
    }
  }

  void onPartnerSelected(ComfortPartner partner) {
    widget.comfortPartnersController.comfortCategoryAnalyticsStopTimer();
    var comfortPageArgs = ComfortPageArgs(
      appOriginEnum: widget.appOriginEnum,
      reference: widget.reference,
      unit: widget.unit,
      accessRouteOrigin: ComfortPageOriginEnum.toYourCondoPage,
    );
    widget.comfortPartnersController
        .goToPartnerDetailsPage(partner, ComfortPageOriginEnum.toYourCondoPage);
    Navigator.pushNamed(context, SharedApplicationRoute.comfortPartner,
            arguments: ComfortPartnerPageArgs(
                applicationContainer: widget.appContainer,
                comfortPartnersController: widget.comfortPartnersController,
                reference: comfortPageArgs.reference,
                unit: comfortPageArgs.unit,
                appOriginEnum: AppOriginEnum.manager))
        .then((value) => widget.comfortPartnersController
            .comfortCategoryAnalyticsTimerStart(
                ComfortPartnerCategory.toYourCondo,
                debugEventIdentifier: "partner_details_pop"));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        widget.comfortPartnersController.comfortCategoryAnalyticsStopTimer();
        widget.comfortPartnersController.analyticsComfortCategoryPageBack(
            ComfortPartnerCategory.toYourCondo);
        return true;
      },
      child: Scaffold(
          appBar: CustomAppBar(title: "comfort"),
          body: BlocConsumer<ComfortPartnersBloc, ComfortPartnersState>(
            bloc: widget.comfortPartnersController.comfortPartnersBloc,
            listener: (context, state) {},
            builder: (context, state) {
              if (state is! LoadedComfortPartnersState) {
                return Column(
                  children: [
                    Expanded(child: LoadingWidget()),
                  ],
                );
              }

              if (state is ErrorComfortPartnersState) {
                Navigator.pop(context);
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: ErrorHandlingWidget(
                    reTryFunction: () {
                      widget.comfortPartnersController.getAllPartners(
                          ComfortPageOriginEnum.toYourCondoPage);
                    },
                    backFunction: () => Navigator.pop(context, true),
                    isProduction: true,
                  ),
                );
              }

              SchedulerBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  setState(() {
                    isScrollable =
                        _scrollController.position.maxScrollExtent != 0;
                  });
                }
              });
              return Scrollbar(
                thickness: 4,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Para seu condomínio",
                              style: LelloTextStyles.bodyBold(theme)!.copyWith(
                                color: theme.primaryColor,
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  widget.comfortPartnersController
                                      .comfortCategoryAnalyticsStopTimer();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ComfortToYourCondoOnboarding(
                                        comfortPartnersController:
                                            widget.comfortPartnersController,
                                        fromIcon: true,
                                        appContainer: widget.appContainer,
                                        appOriginEnum: widget.appOriginEnum,
                                        reference: widget.reference,
                                        unit: widget.unit,
                                      ),
                                    ),
                                  ).then((value) => widget
                                      .comfortPartnersController
                                      .comfortCategoryAnalyticsTimerStart(
                                          ComfortPartnerCategory.toYourCondo,
                                          debugEventIdentifier:
                                              "to_your_condo_onboarding_pop"));
                                },
                                child: SvgPicture.asset(
                                    "assets/ic_comfort_your_condo_informative.svg"))
                          ],
                        ),
                        SizedBox(height: Dimens.spacing),
                        RichText(
                          text: new TextSpan(
                            style: LelloTextStyles.subtitleBold(theme),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "Conheça abaixo parceiros e soluções com condições exclusivas para as áreas comuns de seu condomínio.",
                                  style: LelloTextStyles.body(theme)),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimens.spacing),
                        PrimaryButton(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    "assets/ic_comfort_my_requests.svg",
                                    height: 24),
                                SizedBox(width: Dimens.spacing),
                                Text("Minhas Solicitações",
                                    style: LelloTextStyles.bodyBold(theme)!
                                        .copyWith(color: Colors.white)),
                              ]),
                          onPressed: () {
                            widget.comfortPartnersController
                                .comfortCategoryAnalyticsStopTimer();
                            widget.comfortPartnersController
                                .analyticsRequestButton();
                            Navigator.pushNamed(context,
                                    SharedApplicationRoute.comfortMyRequests,
                                    arguments: ComfortMyRequestsPageArgs(
                                      widget.comfortPartnersController,
                                    ))
                                .then((value) => widget
                                    .comfortPartnersController
                                    .comfortCategoryAnalyticsTimerStart(
                                        ComfortPartnerCategory.toYourCondo,
                                        debugEventIdentifier:
                                            "comfort_my_requests_pop"));
                          },
                        ),
                        SizedBox(height: Dimens.spacing),
                        buildCategoriesList(theme, context),
                        if (showScrollIndicator && isScrollable)
                          Center(child: ScrollIndicator()),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  void _onScroll() {
    if (showScrollIndicator == false) return;
    if (_scrollController.position.isScrollingNotifier.value) {
      setState(() {
        showScrollIndicator = false;
      });
      return;
    }
  }

  Widget buildCategoriesList(ThemeData theme, BuildContext context) {
    var categoriesToYourCondo = (widget.comfortPartnersController
            .comfortPartnersBloc.state as LoadedComfortPartnersState)
        .categoriesToYourCondo;
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) {
          return SizedBox(height: Dimens.spacing);
        },
        itemCount: categoriesToYourCondo.length,
        itemBuilder: (context, index) {
          var loadedState = widget.comfortPartnersController.comfortPartnersBloc
              .state as LoadedComfortPartnersState;

          ComfortYourCondoRemoteConfig cat =
              loadedState.categoriesToYourCondo[index];

          var listParceiros = widget.comfortPartnersController.allPartnersList
              .where((element) =>
                  enumToString(element.partnerIntro.comfortType) == cat.type &&
                  element.category == ComfortPartnerCategory.toYourCondo)
              .toList();

          return Column(
            children: [
              Material(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0,
                              8), // Deslocamento horizontal e vertical da sombra
                          blurRadius: 16.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: CustomExpansionTile(
                            trailing: null,
                            hideTrailing: true,
                            initiallyExpanded: widget.comfortPartnersController
                                    .categoriesToYourCondoExpanded[cat.type] ??
                                false,
                            onExpansionChanged: (value) {
                              if (value)
                                widget.comfortPartnersController
                                    .analyticsSubcategorieAccessed(
                                  subcategories: cat.type,
                                  category: ComfortPartnerCategory.toYourCondo,
                                );
                              setState(() {
                                widget.comfortPartnersController
                                        .categoriesToYourCondoExpanded[
                                    cat.type] = value;
                              });
                            },
                            title: Row(
                              children: [
                                cat.getIconWithColor(theme.primaryColor),
                                SizedBox(width: Dimens.spacingSmall),
                                Text(
                                  cat.title,
                                  style: LelloTextStyles.body(theme)!
                                      .copyWith(color: theme.primaryColor),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                SizedBox(height: Dimens.spacingSmall),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.65,
                                  child: Text(
                                    cat.body,
                                    style: LelloTextStyles.body(theme),
                                  ),
                                ),
                                SizedBox(height: Dimens.spacingSmall),
                                Divider(
                                    height: 0,
                                    thickness: 0.8,
                                    color: Color(0x5C052126)),
                                Icon(
                                    widget.comfortPartnersController
                                                    .categoriesToYourCondoExpanded[
                                                cat.type] ??
                                            false
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Color(0xFF5C0521))
                              ],
                            ),
                            children: [
                              buildCondoPartersOfCategory(listParceiros),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          );
        });
  }

  ListView buildCondoPartersOfCategory(List<ComfortPartner> listParceiros) {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: Dimens.spacing),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: (listParceiros.length / 2).ceil(),
      padding: EdgeInsets.all(Dimens.spacingSmall),
      itemBuilder: (context, index) {
        int firstItemIndex = index * 2;
        int secondItemIndex = firstItemIndex + 1;
        return Container(
          height: ComfortPartnerCard.cardHeight(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              customBuildComfortPartnerCard(listParceiros[firstItemIndex]),
              if (secondItemIndex < listParceiros.length)
                customBuildComfortPartnerCard(listParceiros[secondItemIndex]),
            ],
          ),
        );
      },
    );
  }

  Widget customBuildComfortPartnerCard(ComfortPartner partner) {
    var theme = Theme.of(context);
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0), // Defina o valor do raio aqui
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () => onPartnerSelected(partner),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: ComfortPartnerCard.cardHeight() * 2 / 5,
                      width: ComfortPartnerCard.cardHeight() * 2 / 5,
                      child: CustomCachedNetworkImage(
                          padding: EdgeInsets.all(0),
                          fit: BoxFit.fill,
                          applicationContainer: widget.appContainer,
                          link: partner.partnerIntro.partnerImageLink)),
                  SizedBox(height: Dimens.spacingSmall),
                  Expanded(
                    flex: 2,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: constraints.maxWidth),
                            child: Text(
                              partner.partnerIntro.title,
                              textAlign: TextAlign.center,
                              maxLines:
                                  2, // garantindo que o texto tenha no máximo 2 linhas
                              style: LelloTextStyles.body(theme),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  // Expanded(
                  //   flex: 3,
                  //   child: FittedBox(
                  //     fit: BoxFit.scaleDown,
                  //     child: Text(
                  //       partner.getPartnerSubtitle(context),
                  //       textAlign: TextAlign.center,
                  //       style: LelloTextStyles.body(theme)
                  //           ?.copyWith(color: Color(0xFF3C3C3C)),
                  //     ),
                  //   ),
                  // ),
                  //SizedBox(height: Dimens.spacingXSmall),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      //width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: BorderSide(
                            width: 1.3,
                            color: LelloTheme.palleteOf(theme).primary(),
                          ),
                        ),
                        child: Text(
                          getString(context, "details"),
                          style: LelloTextStyles.button(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).primary()),
                        ),
                        onPressed: () {
                          onPartnerSelected(partner);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
