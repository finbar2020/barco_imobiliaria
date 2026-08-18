import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_filter.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_list/reservation_list_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_list/reservation_list_state.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_list_item.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class ReservationListWidget extends StatefulWidget {
  final ReservationType? type;
  final ReservationItemHeader? headerType;
  final ReservationFilter? filter;
  final Function(List<Reservation>)? onDataChanged;
  final DateTime? date;
  final String? spaceId;
  final Widget? header;

  const ReservationListWidget(
      {Key? key,
      this.type,
      this.date,
      this.headerType,
      this.spaceId,
      this.filter,
      this.onDataChanged,
      this.header})
      : super(key: key);

  @override
  _ReservationListWidgetState createState() => _ReservationListWidgetState();
}

class _ReservationListWidgetState extends State<ReservationListWidget> {
  final ReservationListBloc bloc = ApplicationContainer.instance().resolve();
  Completer<void> _completer = Completer<void>();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  late ScrollController controller;
  var loaded = false;
  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  final dateFormat = DateFormat.yMMMMd();
  final weekDayFormat = DateFormat.EEEE();

  @override
  Widget build(BuildContext context) {
    if (widget.type != bloc.state.type ||
        widget.filter != bloc.state.filter ||
        !loaded) {
      bloc.beginLoad(widget.date!, widget.spaceId!);
      loaded = true;
    }

    final theme = Theme.of(context);
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: () async {
        bloc.beginRefresh();
        return _completer.future;
      },
      child: BlocConsumer<ReservationListBloc, ReservationListState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is ReservationListLoadingState) {
              _refreshKey.currentState!.show();
            } else {
              if (widget.onDataChanged != null) _completer.complete();
              _completer = Completer<void>();
            }
          },
          builder: (context, state) {
            print("a");
            if (state.data.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    contentPadding:
                        EdgeInsets.all(Dimens.spacing).copyWith(bottom: 0),
                    title: Text(
                        widget.date != null
                            ? dateFormat.format(widget.date!)
                            : "-",
                        style: LelloTextStyles.title(theme)),
                    subtitle: Text(
                        widget.date != null
                            ? weekDayFormat.format(widget.date!)
                            : "-",
                        style: LelloTextStyles.subBody(theme)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: Dimens.spacing, right: Dimens.spacingMedium),
                    child: Text(
                        "Ops, parece que não tem nenhuma reserva para este dia",
                        style: LelloTextStyles.error(theme)),
                  )
                ],
              );
            }
            return ListView.separated(
                controller: controller,
                itemBuilder: (context, index) {
                  var i = index - (widget.header != null ? 1 : 0);
                  if (index == 0 && widget.header != null) {
                    return widget.header!;
                  }
                  if (i >= state.data.length &&
                      state is ReservationListPagingState) {
                    return const Center(child: LoadingWidget());
                  }
                  return ReservationListItem(
                      headerType:
                          widget.headerType ?? ReservationItemHeader.SHOW_DAY,
                      reservation: Reservation(),
                      onRefreshRequested: () {
                        bloc.beginRefresh();
                      });
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: (state.data.length) +
                    (widget.header != null ? 1 : 0) +
                    (state is ReservationListPagingState ? 1 : 0));
          }),
    );
  }

  void _scrollListener() {
    final delta = Dimens.spacingXLarge;
    if (bloc.state is! ReservationListPagingState &&
        (controller.offset + delta) >= controller.position.maxScrollExtent) {
      bloc.beginLoadNextPage();
    }
  }
}
