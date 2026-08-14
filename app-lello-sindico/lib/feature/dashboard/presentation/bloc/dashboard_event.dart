import 'package:essentials/essentials.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency.dart';

abstract class DashboardEvent {}

class DashboardLoadEvent extends DashboardEvent {
  final bool? refresh;
  DashboardLoadEvent({this.refresh});
}

class DashboardLockScrollEvent extends DashboardEvent {
  final bool? isLocked;
  DashboardLockScrollEvent({this.isLocked});
}

class DashboardNextPageEvent extends DashboardEvent {}

class DashboardReadPendencyEvent extends DashboardEvent {
  final Pendency pendency;
  DashboardReadPendencyEvent(this.pendency);
}

class DashboardSessionFailedEvent extends DashboardEvent {
  final Failure error;

  DashboardSessionFailedEvent(this.error);
}

class DashboardGetMostAccessedEvent extends DashboardEvent {}
