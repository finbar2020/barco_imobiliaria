import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';

abstract class UnitDetailState {
  final List<Resident> residents;

  UnitDetailState(this.residents);
}

class UnitDetailLoadingState extends UnitDetailState {
  UnitDetailLoadingState() : super([]);
}

class UnitDetailLoadFailedState extends UnitDetailState {
  final Failure error;
  UnitDetailLoadFailedState(this.error) : super([]);
}

class UnitDetailLoadedState extends UnitDetailState {
  final List<Resident> residents;
  UnitDetailLoadedState(this.residents) : super(residents);
}

class UnitDetailSendInviteSmsSuccessState extends UnitDetailState {
  final List<Resident> residents;
  final String link;
  UnitDetailSendInviteSmsSuccessState(this.residents, this.link)
      : super(residents);
}

class UnitDetailSendInviteLinkSuccessState extends UnitDetailState {
  final List<Resident> residents;
  final String link;
  UnitDetailSendInviteLinkSuccessState(this.residents, this.link)
      : super(residents);
}

class UnitDetailSendInviteFailedState extends UnitDetailState {
  final List<Resident> residents;
  final Failure error;
  UnitDetailSendInviteFailedState(this.residents, this.error)
      : super(residents);
}
