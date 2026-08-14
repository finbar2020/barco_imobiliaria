import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';
import 'package:lello/feature/home/domain/entity/home_item_enum.dart';

class DashboardState {
  List<Pendency> data;
  final String? lastPendencyId;
  final bool doneLoading;
  final bool lockScroll;

  DashboardState(
      this.data, this.lastPendencyId, this.doneLoading, this.lockScroll);
  factory DashboardState.empty() => DashboardState([], null, false, false);
}

class DashboardLoadingSucceededState extends DashboardState {
  DashboardLoadingSucceededState(List<Pendency> data, String? lastPendencyId,
      bool doneLoading, bool lockScroll)
      : super(data, lastPendencyId, doneLoading, false);
}

class DashboardLoadingState extends DashboardState {
  DashboardLoadingState(List<Pendency> data) : super(data, null, false, false);
}

class DashboardLoadedState extends DashboardState {
  List<HomeItemEnum> itens;
  DashboardLoadedState(this.itens) : super([], null, false, false);
}

class DashboardScrollLockState extends DashboardState {
  DashboardScrollLockState(List<Pendency> data, bool isLocked)
      : super(data, null, false, isLocked);
}

class DashboardRefreshingState extends DashboardLoadingState {
  DashboardRefreshingState(List<Pendency> data) : super(data);
}

class DashboardPagingState extends DashboardState {
  DashboardPagingState(List<Pendency> data, String lastPendencyId)
      : super(data, lastPendencyId, false, false);
}

class DashboardFailedState extends DashboardState {
  Failure error;
  DashboardFailedState(this.error, {List<Pendency>? data})
      : super(data ?? [], null, false, false);
}

class DashboardPageFailedState extends DashboardState {
  Failure error;
  DashboardPageFailedState(
      List<Pendency> data, String lastPendencyId, this.error)
      : super(data, lastPendencyId, false, false);
}
