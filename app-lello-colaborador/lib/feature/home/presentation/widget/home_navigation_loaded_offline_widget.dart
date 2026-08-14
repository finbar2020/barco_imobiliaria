import 'dart:developer';

import 'package:colaborador/core/navigation/application_rbac.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/home/domain/entity/home_navigation_item.dart';
import 'package:colaborador/feature/home/presentation/widget/app_bar/home_app_bar_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/home_bottom_navigation_bar_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/home_page_offline_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/digital_point_header_widget.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../core/dependency/application_container.dart';
import '../controllers/home_controller.dart';

class HomeNavigationLoadedOfflineWidget extends StatefulWidget {
  final Session session;
  final List<DigitalPointEntity> digitalPoints;
  final NotificationController notificationController;
  const HomeNavigationLoadedOfflineWidget({
    Key? key,
    required this.session,
    required this.digitalPoints,
    required this.notificationController,
  }) : super(key: key);

  @override
  State<HomeNavigationLoadedOfflineWidget> createState() =>
      _HomeNavigationLoadedOfflineWidgetState();
}

class _HomeNavigationLoadedOfflineWidgetState
    extends State<HomeNavigationLoadedOfflineWidget> {
  int _currentPage = 0;
  bool isHome = true;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    log("HomeNavigationLoadedOfflineWidget");
    _pageController = PageController(viewportFraction: 1.0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  final SessionBloc sessionBloc =
      ApplicationContainer.instance().resolve<SessionBloc>();
  final HomeController controller =
      ApplicationContainer.instance().resolve<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.getDigitalPoints,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                DigitalPointHeader(
                  notificationController: widget.notificationController,
                  isHomePage: controller.currentPage == 0,
                  callback: controller.getDigitalPoints,
                ),
                Flexible(
                  child: PageView(
                    controller: _pageController,
                    allowImplicitScrolling: false,
                    physics: const NeverScrollableScrollPhysics(),
                    pageSnapping: false,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
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
      appBar: HomeAppBar.show(context, widget.session, () {
        Navigator.of(context).pushNamed(ApplicationRoute.me);
      }),
      bottomNavigationBar: HomeBottomNavigationBarWidget(
        currentPage: _currentPage,
        changePage: (index) {
          setState(() {
            _pageController.page;
            _pageController.jumpToPage(index);
            _currentPage = index;
          });
        },
        navigationItems: _navigationItems,
      ),
    );
  }

  List<HomeNavigationItem> get _navigationItems {
    return [
      HomeNavigationItem(
        item: HomeNavigationItemEnum.home,
        child: HomePageOfflineWidget(
          digitalPoints: widget.digitalPoints,
        ),
      ),
      if (sessionBloc.checkRback(
          ApplicationRbacEnum.colaboradorDocumentos.toFormattedString()))
        HomeNavigationItem(
          item: HomeNavigationItemEnum.myDocuments,
          child: Container(),
          activated: false,
        ),
      if (sessionBloc.checkRback(
          ApplicationRbacEnum.colaboradorPontodigital.toFormattedString()))
        if (widget.session.condominium.canRegisterDigitalPointStatus)
          HomeNavigationItem(
            item: HomeNavigationItemEnum.digitalPoint,
            child: Container(),
            activated: false,
          )
    ];
  }
}
