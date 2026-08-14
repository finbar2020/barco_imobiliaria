import 'package:essentials/enum/app_origin_enum.dart';

import 'package:flutter/material.dart';
import 'package:shared_features/feature/notifications/presentation/widgets/notification_details_widget.dart';

import '../../../../shared_features.dart';

typedef NotificationScopeLabelBuilder = String? Function(
    SingleNotification notification);

class NotificationListTile extends StatefulWidget {
  final SingleNotification notification;
  final NotificationController controller;
  final VoidCallback closeOverlay;
  final Function(SingleNotification notification) onTap;
  final bool fromHomeManager;
  final String? configurationPage;
  final VoidCallback? onConfigurationTap;
  final AppOriginEnum? appOriginEnum;
  final bool? checkRbac;
  final SharedApplicationContainer applicationContainer;
  final NotificationScopeLabelBuilder? scopeLabelBuilder;
  const NotificationListTile({
    Key? key,
    required this.notification,
    required this.controller,
    required this.closeOverlay,
    required this.onTap,
    required this.applicationContainer,
    this.appOriginEnum,
    this.checkRbac,
    this.configurationPage,
    this.onConfigurationTap,
    this.fromHomeManager = false,
    this.scopeLabelBuilder,
  }) : super(key: key);

  @override
  _NotificationListTileState createState() => _NotificationListTileState();
}

class _NotificationListTileState extends State<NotificationListTile> {
  @override
  Widget build(BuildContext context) {
    final isUnread = widget.notification.markRead == false;
    final scopeLabel =
        widget.scopeLabelBuilder?.call(widget.notification);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (isUnread) {
          setState(() {
            widget.notification.markRead = true;
          });
          widget.controller
              .loadSingleNotification(notificationId: widget.notification.id!);
        }
        if (widget.fromHomeManager == false) {
          Navigator.of(context).push(MaterialPageRoute(
            settings: RouteSettings(name: "/notification-details-from-list"),
            builder: (context) => NotificationDetailsWidget(
                notification: widget.notification,
                controller: widget.controller,
                onTap: widget.onTap,
                configurationPage: widget.configurationPage,
                onConfigurationTap: widget.onConfigurationTap,
                checkRbac: widget.checkRbac,
                appOriginEnum: widget.appOriginEnum,
                applicationContainer: widget.applicationContainer,
                scopeLabelBuilder: widget.scopeLabelBuilder,
                fromPush: false),
          ));
        } else {
          widget.closeOverlay();
          widget.onTap(widget.notification);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isUnread ? const Color(0x262F80ED) : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFFBEBEBE),
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            SizedBox(
              width: 40,
              height: 40,
              child: widget.notification
                  .iconFromModule(Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + badge row
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${widget.notification.title}',
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread) ...[
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC20332),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Não lida',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.25,
                              height: 17 / 14,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (scopeLabel != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      scopeLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                  const SizedBox(height: 5),
                  // Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.notification.dateFormatted ?? "",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: const Color(0xFF666666),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Message preview (1 line)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${widget.notification.message}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            height: 20 / 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
