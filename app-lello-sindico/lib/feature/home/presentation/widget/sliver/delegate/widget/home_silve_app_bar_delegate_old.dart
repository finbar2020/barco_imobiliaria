import 'dart:math';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/feature/condominium/presentation/widget/condominium_balance_widget.dart';
import 'package:lello/feature/home/presentation/bloc/home_bloc.dart';
import 'package:lello/feature/home/presentation/widget/home_app_bar_old.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';

class HomeSliverAppBarDelegateOld extends SliverPersistentHeaderDelegate {
  final bool showBalance;
  final Function? onExpanded;
  final pendencyNumber;
  final bool isGeneric;

  final radius = 8.0;

  HomeSliverAppBarDelegateOld({
    this.showBalance = true,
    this.onExpanded,
    this.pendencyNumber,
    this.isGeneric = false,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    return Wrap(children: [
      Container(
        child: Transform.translate(
          offset: _translateOffset(shrinkOffset),
          child: Container(
            color: showBalance
                ? LelloTheme.palleteOf(theme).greyDarker()
                : Colors.transparent,
            child: Stack(children: [
              _buildContent(context, shrinkOffset),
              _buildArrow(shrinkOffset, theme),
            ]),
          ),
        ),
      ),
    ]);
  }

  Widget _buildArrow(double shrinkOffset, ThemeData theme) {
    return Positioned(
      bottom: Dimens.spacing,
      left: 0,
      right: 0,
      child: Opacity(
        opacity: (min(shrinkOffset, maxExtent) / maxExtent),
        child: SvgPicture.asset(
          "assets/ic_arrow_down_red.svg",
          width: 12,
          color: theme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double shrinkOffset) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    final sessionBloc = BlocProvider.of<SessionBloc>(context);
    final CircuitBreakerController circuitBreakController =
        ApplicationContainer.instance().resolve();
    final balance = showBalance &&
            circuitBreakController.checkVisible(
                applicationRbac: ApplicationRbac.sindicoSaldo,
                reference:
                    sessionBloc.state.session?.selectedCondominium?.reference ??
                        "")
        ? const CondominiumBalanceWidget()
        : Container();
    return Opacity(
      opacity: 1 - (min(shrinkOffset, maxExtent) / maxExtent),
      child: Container(
        clipBehavior: Clip.none,
        child: Column(
          children: <Widget>[
            HomeAppBarOld(
              isGeneric: isGeneric,
              onTap: () {
                _onAppBarTapped(context);
              },
              expanded: bloc.state.showCondominumSelector,
              isHome: showBalance,
            ),
            balance,
          ],
        ),
      ),
    );
  }

  Offset _translateOffset(double shrinkOffset) {
    final offset = min(shrinkOffset, maxExtent);
    final maxOffset = maxExtent - minExtent;

    return Offset(0, 0 - min(offset, maxOffset));
  }

  @override
  double get maxExtent =>
      showBalance ? Dimens.homeAppBarHeight * 2.5 : Dimens.homeAppBarHeight;

  @override
  double get minExtent => Dimens.homeBalanceHeightCollapsed;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  void _onAppBarTapped(BuildContext context) {
    final HomeBloc bloc = BlocProvider.of<HomeBloc>(context);
    if (bloc.state.showCondominumSelector) {
      bloc.collapseCondominiumSelector();
    } else {
      bloc.showCondominiumSelector();
    }
    onExpanded!(bloc.state.showCondominumSelector);
  }
}
