import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';

abstract class UnitDetailState extends Equatable {
  final List<Resident> residents;

  const UnitDetailState(this.residents);

  @override
  List<Object?> get props => [residents];
}

class UnitDetailLoadingState extends UnitDetailState {
  const UnitDetailLoadingState() : super(const []);
}

class UnitDetailLoadFailedState extends UnitDetailState {
  final Failure error;

  const UnitDetailLoadFailedState(this.error) : super(const []);

  @override
  List<Object?> get props => [residents, error];
}

class UnitDetailLoadedState extends UnitDetailState {
  const UnitDetailLoadedState(super.residents);
}

class UnitDetailSendInviteSmsSuccessState extends UnitDetailState {
  final String link;

  const UnitDetailSendInviteSmsSuccessState(super.residents, this.link);

  @override
  List<Object?> get props => [residents, link];
}

class UnitDetailSendInviteLinkSuccessState extends UnitDetailState {
  final String link;

  const UnitDetailSendInviteLinkSuccessState(super.residents, this.link);

  @override
  List<Object?> get props => [residents, link];
}

class UnitDetailSendInviteFailedState extends UnitDetailState {
  final Failure error;

  const UnitDetailSendInviteFailedState(super.residents, this.error);

  @override
  List<Object?> get props => [residents, error];
}
