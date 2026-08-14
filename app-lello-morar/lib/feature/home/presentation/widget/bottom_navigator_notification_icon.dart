import 'package:badges/badges.dart' as badges;
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/widgets/hex_color.dart';
import 'package:shared_features/shared_features.dart';

class BottomNavigatorNotificationIcon extends StatefulWidget {
  final NotificationListBloc notificationListBloc;
  const BottomNavigatorNotificationIcon({
    Key? key,
    required this.notificationListBloc,
  }) : super(key: key);

  @override
  _BottomNavigatorNotificationIconState createState() =>
      _BottomNavigatorNotificationIconState();
}

class _BottomNavigatorNotificationIconState
    extends State<BottomNavigatorNotificationIcon> {
  Widget _notificationIcon = SvgPicture.asset(
    "assets/ic_active_notificacao.svg",
  );

  NotificationListBloc bloc =
      ApplicationContainer.instance().resolve<NotificationListBloc>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer(
      bloc: widget.notificationListBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is NotificationListPageState) {
          int notifications = state.notificationsNotRead;
          if (notifications > 0) {
            return Container(
              child: badges.Badge(
                badgeAnimation: badges.BadgeAnimation.fade(
                  animationDuration: Duration(milliseconds: 300),
                ),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: HexColor("#F22200"),
                  shape: badges.BadgeShape.circle,
                  borderSide: BorderSide(color: Colors.white),
                ),
                position: badges.BadgePosition.topEnd(end: -15.0, top: -5.0),
                badgeContent: Text(
                  notifications > 99 ? "99+" : notifications.toString(),
                  style: LelloTextStyles.caption(theme)!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                child: SvgPicture.asset(
                  "assets/ic_active_notificacao.svg",
                ),
              ),
            );
          } else {
            return _notificationIcon;
          }
        } else {
          return _notificationIcon;
        }
      },
    );
  }
}
