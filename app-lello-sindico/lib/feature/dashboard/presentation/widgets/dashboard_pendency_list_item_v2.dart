import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency_sender.dart';

class DashboardPendencyListItemV2 extends StatefulWidget {
  final Pendency entity;
  final Function(Pendency)? onTap;
  final dateFormat = DateFormat.yMd();
  final dateFormatMY = DateFormat.MMMd();
  final timeFormat = DateFormat.jm();

  DashboardPendencyListItemV2({
    Key? key,
    required this.entity,
    this.onTap,
  }) : super(key: key);

  @override
  _DashboardPendencyListItemV2State createState() =>
      _DashboardPendencyListItemV2State();
}

class _DashboardPendencyListItemV2State
    extends State<DashboardPendencyListItemV2> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // if (widget.entity.read == false) {
        //   widget.entity.read = true;
        // }
        if (widget.onTap != null) {
          widget.onTap!(widget.entity);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: Dimens.spacingMedium,
            right: Dimens.spacingMedium,
            bottom: Dimens.spacingMedium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getIcon(widget.entity.iconType),
                Text(
                  widget.entity.date == null
                      ? ""
                      : "${widget.dateFormatMY.format(widget.entity.date!)}",
                  style: TextStyle(
                    fontSize: 13,
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
              ],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        '${widget.entity.title}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    Flexible(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Text(
                          '${widget.entity.message}',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 30,
              color: LelloTheme.palleteOf(theme).grey(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getIcon(String? iconType) {
    switch (iconType) {
      case 'CIRCLE_GREEN':
        return const Icon(
          Icons.circle,
          size: 20,
          color: Colors.green,
        );
      case 'CIRCLE_RED':
        return const Icon(
          Icons.circle,
          size: 20,
          color: Colors.red,
        );
      case 'CIRCLE_ORANGE':
        return const Icon(
          Icons.circle,
          size: 20,
          color: Colors.orange,
        );
      default:
        return const Icon(
          Icons.circle,
          size: 20,
          color: Colors.green,
        );
    }
  }
}
