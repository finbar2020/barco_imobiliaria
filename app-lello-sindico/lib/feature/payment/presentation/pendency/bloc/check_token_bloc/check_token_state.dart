import 'package:essentials/essentials.dart';

abstract class CheckTokenState extends Equatable {
  const CheckTokenState();

  @override
  List<Object?> get props => [];
}

class CheckTokenInitialState extends CheckTokenState {
  const CheckTokenInitialState();
}

class CheckTokenLoadingState extends CheckTokenState {
  const CheckTokenLoadingState();
}

class CheckTokenSuccessState extends CheckTokenState {
  final bool success;

  const CheckTokenSuccessState({required this.success});

  @override
  List<Object?> get props => [success];
}

class CheckTokenFailureState extends CheckTokenState {
  final Failure? failure;

  const CheckTokenFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class ResendTokenLoadingState extends CheckTokenState {
  const ResendTokenLoadingState();
}

class ResendTokenSuccessState extends CheckTokenState {
  final int id;

  const ResendTokenSuccessState({required this.id});

  @override
  List<Object?> get props => [id];
}

class ResendTokenFailureState extends CheckTokenState {
  final String? failure;

  const ResendTokenFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class SendActionReasonLoadingState extends CheckTokenState {
  const SendActionReasonLoadingState();
}

class SendActionReasonSuccessState extends CheckTokenState {
  final bool success;

  const SendActionReasonSuccessState({required this.success});

  @override
  List<Object?> get props => [success];
}

class SendActionReasonFailureState extends CheckTokenState {
  final Failure? failure;

  const SendActionReasonFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class UpdateInstallmentsLoadingState extends CheckTokenState {
  const UpdateInstallmentsLoadingState();
}

class UpdateInstallmentsSuccessState extends CheckTokenState {
  final bool success;

  const UpdateInstallmentsSuccessState({required this.success});

  @override
  List<Object?> get props => [success];
}

class UpdateInstallmentsFailureState extends CheckTokenState {
  final Failure? failure;

  const UpdateInstallmentsFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
