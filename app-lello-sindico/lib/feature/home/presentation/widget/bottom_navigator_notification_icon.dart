import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart' hide Badge;

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
  final Widget _notificationIcon = SvgPicture.asset(
    "assets/ic_active_notificacao.svg",
  );

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
            return Badge(
              badgeAnimation: const BadgeAnimation.fade(
                animationDuration: Duration(milliseconds: 300),
              ),
              badgeStyle: const BadgeStyle(
                badgeColor: Color(0xFFF22200),
                shape: BadgeShape.circle,
                borderSide: BorderSide(color: Colors.white),
              ),
              position: BadgePosition.topEnd(end: -15.0, top: -5.0),
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
