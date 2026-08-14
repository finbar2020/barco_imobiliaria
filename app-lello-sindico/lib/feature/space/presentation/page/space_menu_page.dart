import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_change_rules_page.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_history_calendar_page.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class SpaceMenuPageArgs {
  String? reserveNotificationContext;
  SpaceMenuPageArgs({this.reserveNotificationContext});
}

class SpaceMenuPage extends StatefulWidget {
  const SpaceMenuPage({Key? key}) : super(key: key);

  @override
  State<SpaceMenuPage> createState() => _SpaceMenuPageState();
}

class _SpaceMenuPageState extends State<SpaceMenuPage> {
  late SessionBloc sessionBloc;

  @override
  void initState() {
    super.initState();
    sessionBloc = BlocProvider.of(context);
  }

  SpaceMenuPageArgs? arguments;
  bool redirect = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    arguments =
        ModalRoute.of(context)!.settings.arguments as SpaceMenuPageArgs?;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (arguments?.reserveNotificationContext?.isNotEmpty == true &&
          redirect == false) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ReservationHistoryCalendarPage(
              spaceNotificationContext: arguments!.reserveNotificationContext);
        }));
        redirect = true;
      }
    });

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            iconColor: theme.primaryColor,
            theme: theme,
            title: getString(context, "condominium_hub_manage_space")),
        body: _buildList(context, theme),
      ),
    );
  }

  Widget _buildList(BuildContext context, ThemeData theme) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    return ListView(
      children: [
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoReservasWrite,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoReservasWrite),
          child: Column(
            children: [
              _buildListItem(getString(context, "space_reserve_space_moving"),
                  "assets/ic_reserve.svg", theme, onTap: () {
                Navigator.of(context).pushNamed(
                    ApplicationRoute.spaceReservationRegistrationSpace);
              }),
              const Divider(),
            ],
          ),
        ),
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoReservasRead,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoReservasRead),
          child: Column(
            children: [
              _buildListItem(getString(context, "space_reservation_control"),
                  "assets/ic_reservation_control.svg", theme, onTap: () {
                Navigator.pushNamed(
                    context, ApplicationRoute.spaceReservationCalendarHistory);
              }),
              const Divider(),
            ],
          ),
        ),
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoReservasMudancas,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoReservasMudancas),
          child: Column(
            children: [
              _buildListItem(getString(context, "space_change_rules"),
                  "assets/ic_mudanca.svg", theme,
                  onTap: sessionBloc.checkConfig("moving_reference")
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return const ReservationChangeRulesPage();
                          }));
                        }
                      : null),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildListItem(String title, String asset, ThemeData theme,
      {VoidCallback? onTap}) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.only(
            left: Dimens.spacingLarge,
            right: Dimens.spacingLarge,
            top: Dimens.spacingSmall,
            bottom: Dimens.spacingSmall),
        leading: SvgPicture.asset(asset, width: 24),
        title: Text(title, style: LelloTextStyles.bodyBold(theme)),
        trailing: onTap == null
            ? SvgPicture.asset("assets/ic_coming_soon.svg")
            : null,
      ),
    );
  }
}
