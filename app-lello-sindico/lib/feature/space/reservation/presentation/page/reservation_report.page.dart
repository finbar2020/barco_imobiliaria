import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_filter.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_filter_widget.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_list_item.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_list_widget.dart';

class ReservationReportPage extends StatefulWidget {
  @override
  _ReservationReportPageState createState() => _ReservationReportPageState();
}

class _ReservationReportPageState extends State<ReservationReportPage> {
  late ReservationFilter filter;
  final currencyFormat = new NumberFormat.currency(symbol: "R\$");
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var balance = 0.0;

  @override
  void initState() {
    final now = DateTime.now();
    filter = ReservationFilter()
      ..from = DateTime(now.year, now.month, 1)
      ..to = DateTime(now.year, now.month + 1, 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        key: scaffoldKey,
        appBar: PrimaryAppBar(
            title: "Relatório de reservas",
            theme: theme,
            actions: [
              IconButton(
                onPressed: () {
                  scaffoldKey.currentState!.openEndDrawer();
                },
                icon: SvgPicture.asset("assets/ic_filter.svg"),
              )
            ]),
        body: _buildBody(theme),
        endDrawer: Container(
            width: MediaQuery.of(context).size.width,
            child: _buildFilterDrawer()),
      ),
    );
  }

  Widget _buildFilterDrawer() {
    return Drawer(
      child: Container(
        color: LelloTheme.palleteOf(LelloTheme.dark).background(),
        child: ListView(
            padding: EdgeInsets.only(top: Dimens.spacingMedium)
                .copyWith(top: Dimens.spacingXLarge),
            children: [
              ListTile(
                  title: Text(getString(context, "payment_filter_title"),
                      style: LelloTextStyles.title(LelloTheme.dark)),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: SvgPicture.asset("assets/ic_close_white.svg"),
                  )),
              ReservationFilterWidget(
                  entity: filter,
                  onApply: (filter) {
                    setState(() {
                      this.filter = filter.copy();
                    });
                    Navigator.of(context).pop();
                  },
                  onClose: () {
                    Navigator.of(context).pop();
                  }),
            ]),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ReservationListWidget(
            onDataChanged: (data) => _updateBalance(data),
            filter: filter,
            headerType: ReservationItemHeader.SHOW_DAY,
          ),
        ),
        _buildSummary(theme)
      ],
    );
  }

  Widget _buildSummary(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(8.0), topLeft: Radius.circular(8.0)),
        color: LelloTheme.palleteOf(theme).separator(),
      ),
      child: Row(
        children: [
          Text(getString(context, "accountability_balance"),
              style: LelloTextStyles.bodyBold(theme)),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(Dimens.spacing).copyWith(top: 0, bottom: 0),
            child: Divider(),
          )),
          Text(currencyFormat.format(balance),
              style: LelloTextStyles.subBody(theme))
        ],
      ),
    );
  }

  void _updateBalance(List<Reservation> data) {
    setState(() {
      balance = 0.0;
      data.forEach((e) => balance += e.price ?? 0.0);
    });
  }
}
