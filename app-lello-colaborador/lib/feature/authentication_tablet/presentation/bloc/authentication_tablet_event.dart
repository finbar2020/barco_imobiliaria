import 'package:essentials/essentials.dart';

abstract class AuthenticationTabletEvent extends Equatable {
  const AuthenticationTabletEvent();

  @override
  List<Object?> get props => [];
}

class GetInfoByCondoCodeEvent extends AuthenticationTabletEvent {
  final String condoCode;

  const GetInfoByCondoCodeEvent(this.condoCode);

  @override
  List<Object?> get props => [condoCode];
}

class GetNoAuthPointsEvent extends AuthenticationTabletEvent {
  final String reference;

  const GetNoAuthPointsEvent(this.reference);

  @override
  List<Object?> get props => [reference];
}

class SendNoAuthPointsEvent extends AuthenticationTabletEvent {
  final String reference;

  const SendNoAuthPointsEvent(this.reference);

  @override
  List<Object?> get props => [reference];
}
