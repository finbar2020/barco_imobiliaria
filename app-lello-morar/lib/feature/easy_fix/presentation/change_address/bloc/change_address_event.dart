import 'package:essentials/essentials.dart';
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';

abstract class ChangeAddressEvent extends Equatable {
  const ChangeAddressEvent();

  @override
  List<Object?> get props => [];
}

class ChangeAddressEmptyEvent extends ChangeAddressEvent {
  const ChangeAddressEmptyEvent();
}

class ChangeAddressLoadingEvent extends ChangeAddressEvent {
  const ChangeAddressLoadingEvent();
}

class ChangeAddressSuccessEvent extends ChangeAddressEvent {
  const ChangeAddressSuccessEvent();
}

class ChangeAddressLoadedEvent extends ChangeAddressEvent {
  final EasyFixUnit unit;

  const ChangeAddressLoadedEvent({
    required this.unit,
  });

  @override
  List<Object?> get props => [unit];
}

class ChangeAddressFailureEvent extends ChangeAddressEvent {
  final Failure failure;

  const ChangeAddressFailureEvent({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}
