
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_rbac.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/home/domain/entity/home_navigation_item.dart';
import 'package:colaborador/feature/home/presentation/controllers/home_controller.dart';
import 'package:colaborador/feature/home/presentation/controllers/register_point_controller.dart';
import 'package:colaborador/feature/home/presentation/widget/app_bar/home_app_bar_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/home_bottom_navigation_bar_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/benefits/benefits_page_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/digital_point/digital_point_page_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/documents/documents_page_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/home_page_online_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/digital_point_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

class HomeNavigationLoadedOnlineWidget extends StatefulWidget {
  final HomeController controller;
  final RegisterPointController registerController;
  final List<DigitalPointEntity> digitalPoints;
  final NotificationController notificationController;
  const HomeNavigationLoadedOnlineWidget({
    Key? key,
    required this.controller,
    required this.registerController,
    required this.digitalPoints,
    required this.notificationController,
  }) : super(key: key);

  @override
  State<HomeNavigationLoadedOnlineWidget> createState() =>
      _HomeNavigationLoadedOnlineWidgetState();
}

class _HomeNavigationLoadedOnlineWidgetState
    extends State<HomeNavigationLoadedOnlineWidget>
    with WidgetsBindingObserver {
  final HomeController controller =
      ApplicationContainer.instance().resolve<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller.pageController = PageController(viewportFraction: 1.0);
    controller.pageController!.addListener(_pageListener);
  }

  @override
  void dispose() {
    controller.pageController!.removeListener(_pageListener);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!ModalRoute.of(context)!.isCurrent) return;
    switch (state) {
      case AppLifecycleState.paused:
        controller.colaboradorHomeTimerStop();
        controller.pageController!.removeListener(_pageListener);
        break;
      case AppLifecycleState.detached:
        controller.colaboradorHomeTimerStop();
        controller.pageController!.removeListener(_pageListener);
        break;
      case AppLifecycleState.resumed:
        controller.colaboradorHomeTimerStart();
        controller.pageController!.addListener(_pageListener);
        break;
      default:
        break;
    }
  }

  void _pageListener() {
    if (controller.pageController!.page == 0) {
      controller.colaboradorHomeTimerStart();
    } else if (controller.previousPage == 0 &&
        controller.pageController!.page != 0) {
      controller.colaboradorHomeTimerStop();
    }
    controller.previousPage = controller.pageController!.page!.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: controller.getDigitalPoints,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GestureDetector(
                onHorizontalDragEnd: (dragDetail) {
                  if (dragDetail.primaryVelocity! < 0) {
                    controller.pageController!.animateToPage(
                      controller.currentPage + 1,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.ease,
                    );
                    controller.currentPage = controller.currentPage + 1;
                  }
                  if (dragDetail.primaryVelocity! > 0) {
                    controller.pageController!.animateToPage(
                      controller.currentPage - 1,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.ease,
                    );
                    controller.currentPage = controller.currentPage - 1;
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DigitalPointHeader(
                      notificationController: widget.notificationController,
                      isHomePage: controller.currentPage == 0,
                      callback: controller.getDigitalPoints,
                    ),
                    Flexible(
                      child: PageView(
                        controller: controller.pageController,
                        allowImplicitScrolling: false,
                        physics: const NeverScrollableScrollPhysics(),
                        pageSnapping: false,
                        onPageChanged: (index) {
                          setState(() {
                            controller.currentPage = index;
                          });
                        },
                        children: _navigationItems.map((e) => e.child).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        appBar: HomeAppBar.show(context, widget.controller.session!, () {
          if (controller.pageController!.page == 0) {
            controller.colaboradorHomeTimerStop();
          }
          Navigator.of(context).pushNamed(ApplicationRoute.me).then((value) {
            if (controller.pageController!.page == 0) {
              controller.colaboradorHomeTimerStart();
            }
          });
        }),
        bottomNavigationBar: HomeBottomNavigationBarWidget(
          currentPage: controller.currentPage,
          changePage: (index) {
            setState(() {
              controller.pageController!.jumpToPage(index);
              controller.currentPage = index;
            });
          },
          navigationItems: _navigationItems,
        ),
      ),
    );
  }

  List<HomeNavigationItem> get _navigationItems {
    return [
      HomeNavigationItem(
        item: HomeNavigationItemEnum.home,
        child: HomePageOnlineWidget(
          registerController: widget.registerController,
          controller: widget.controller,
        ),
      ),
      if (widget.controller.sessionBloc.checkRback(
          ApplicationRbacEnum.colaboradorDocumentos.toFormattedString()))
        HomeNavigationItem(
          item: HomeNavigationItemEnum.myDocuments,
          child: const DocumentsPageWidget(),
        ),
      if (widget.controller.sessionBloc.checkRback(ApplicationRbacEnum
          .colaboradorDocumentosBeneficios
          .toFormattedString()))
        HomeNavigationItem(
          item: HomeNavigationItemEnum.benefits,
          child: const BenefitsPageWidget(),
        ),
      if (widget.controller.sessionBloc.checkRback(ApplicationRbacEnum
          .colaboradorPontodigitalMarcarPonto
          .toFormattedString()))
        if (widget
            .controller.session!.condominium.canRegisterDigitalPointStatus)
          HomeNavigationItem(
            item: HomeNavigationItemEnum.digitalPoint,
            child: DigitalPointPageWidget(
              registerController: widget.registerController,
            ),
          )
    ];
  }

  Size _preferredSize() {
    if (MediaQuery.of(context).size.aspectRatio < 1) {
      return Size(MediaQuery.of(context).size.width, 150);
    } else {
      return Size(MediaQuery.of(context).size.width, 200);
    }
  }
}
