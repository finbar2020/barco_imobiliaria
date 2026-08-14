import 'package:essentials/essentials.dart';
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';

abstract class ChangeAddressState extends Equatable {
  const ChangeAddressState();

  @override
  List<Object?> get props => [];
}

class ChangeAddressInitialState extends ChangeAddressState {
  const ChangeAddressInitialState();
}

class ChangeAddressLoadingState extends ChangeAddressState {
  const ChangeAddressLoadingState();
}

class ChangeAddressSuccessState extends ChangeAddressState {
  const ChangeAddressSuccessState();
}

class ChangeAddressLoadedState extends ChangeAddressState {
  final EasyFixUnit unit;

  const ChangeAddressLoadedState({
    required this.unit,
  });

  @override
  List<Object?> get props => [unit];
}

class ChangeAddressFailureState extends ChangeAddressState {
  final Failure failure;

  const ChangeAddressFailureState({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}
