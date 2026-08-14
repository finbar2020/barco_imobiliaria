import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart' hide Badge;

import 'package:shared_features/shared_features.dart';

class NotificationIcon extends StatefulWidget {
  final NotificationListBloc notificationListBloc;
  const NotificationIcon({
    Key? key,
    required this.notificationListBloc,
  }) : super(key: key);

  @override
  NotificationIconState createState() => NotificationIconState();
}

class NotificationIconState extends State<NotificationIcon> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder(
      bloc: widget.notificationListBloc,
      builder: (context, state) {
        if (state is NotificationListPageState) {
          int notifications = state.notificationsNotRead;
          if (notifications != 0) {
            return Badge(
              stackFit: StackFit.passthrough,
              badgeAnimation: const BadgeAnimation.fade(
                animationDuration: Duration(milliseconds: 300),
              ),
              badgeStyle: BadgeStyle(
                badgeColor: LelloTheme.palleteOf(theme).primary(),
              ),
              position: BadgePosition.topEnd(end: 15.0, top: -10),
              ignorePointer: true,
              badgeContent: Text(
                notifications > 99 ? "99+" : notifications.toString(),
                style: LelloTextStyles.caption(theme)!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 8,
                ),
              ),
              child: SvgPicture.asset(
                "assets/ic_notification.svg",
              ),
            );
          }
          return SvgPicture.asset(
            "assets/ic_notification.svg",
          );
        }
        return SvgPicture.asset(
          "assets/ic_notification.svg",
        );
      },
    );
  }
}
