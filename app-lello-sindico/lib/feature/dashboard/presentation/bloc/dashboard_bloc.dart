import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';
import 'package:lello/feature/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:lello/feature/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:lello/feature/home/domain/entity/home_item_enum.dart';

abstract class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(DashboardState initialState) : super(initialState);

  void beginRefresh();
  void beginLoadNextPage();
  void readPendency(Pendency pendency);

  void beginLockScroll(bool isLocked);

  List<HomeItemEnum> favorites = [];
  ValueNotifier<bool> animate = ValueNotifier<bool>(true);
}
