import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_list_item.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_list_widget.dart';

class ReservationListPage extends StatefulWidget {
  final DateTime? day;
  final Space? space;

  ReservationListPage({this.day, this.space});

  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  final dateFormat = DateFormat.yMMMMd();
  final weekDayFormat = DateFormat.EEEE();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
          appBar: PrimaryAppBar(
            iconColor: theme.primaryColor,
            title: getString(context, "space_reservation_agenda"),
            theme: theme,
          ),
          body: ReservationListWidget(
            headerType: ReservationItemHeader.SHOW_TYPE,
            date: widget.day!,
            spaceId: widget.space!.id!,
            header: ListTile(
              contentPadding:
                  EdgeInsets.all(Dimens.spacing).copyWith(bottom: 0),
              title: Text(
                  widget.day != null ? dateFormat.format(widget.day!) : "-",
                  style: LelloTextStyles.title(theme)),
              subtitle: Text(
                  widget.day != null ? weekDayFormat.format(widget.day!) : "-",
                  style: LelloTextStyles.subBody(theme)),
            ),
          )),
    );
  }
}
