import 'package:essentials/essentials.dart';

abstract class HomeSliverAppBarEvent extends Equatable {
  const HomeSliverAppBarEvent();

  @override
  List<Object?> get props => [];
}

class HomeSliverAppBarLockScrollEvent extends HomeSliverAppBarEvent {
  final bool isLocked;

  const HomeSliverAppBarLockScrollEvent({required this.isLocked});

  @override
  List<Object?> get props => [isLocked];
}
