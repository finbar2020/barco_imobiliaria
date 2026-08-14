import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';

abstract class AccessControlEvent extends Equatable {
  const AccessControlEvent();

  @override
  List<Object?> get props => [];
}

class AccessControlLoadingEvent extends AccessControlEvent {
  const AccessControlLoadingEvent();
}

class AccessControlLoadedEvent extends AccessControlEvent {
  final List<AccessControl> visitants;
  final List<AccessControl> providers;

  const AccessControlLoadedEvent({
    required this.visitants,
    required this.providers,
  });

  @override
  List<Object?> get props => [visitants, providers];
}

class AccessControlFailureEvent extends AccessControlEvent {
  const AccessControlFailureEvent();
}

class EditVisitantEvent extends AccessControlEvent {
  final AccessControl visitant;
  final AccessControlAuthorizations model;
  final List<AccessControl> providers;
  final List<AccessControl> visitants;

  const EditVisitantEvent({
    required this.visitant,
    required this.providers,
    required this.model,
    required this.visitants,
  });

  @override
  List<Object?> get props => [visitant, model, providers, visitants];
}

class SaveVisitantLoadedEvent extends AccessControlEvent {
  final List<AccessControl> visitants;
  final List<AccessControl> providers;
  final bool useFacial;
  final bool isVisitant;
  final String? link;
  final bool newVisit;
  final bool edit;
  final bool sendInvite;

  const SaveVisitantLoadedEvent({
    required this.visitants,
    required this.providers,
    required this.useFacial,
    required this.isVisitant,
    this.link,
    this.newVisit = false,
    this.edit = false,
    this.sendInvite = false,
  });

  @override
  List<Object?> get props =>
      [visitants, providers, useFacial, isVisitant, link, newVisit, edit, sendInvite];
}

class SaveVisitantFailureEvent extends AccessControlEvent {
  final List<AccessControl> visitants;
  final List<AccessControl> providers;
  final AccessControl visitant;
  final AccessControlAuthorizations model;
  final bool failureInvite;
  final bool deletVisitant;

  const SaveVisitantFailureEvent({
    required this.visitants,
    required this.providers,
    required this.visitant,
    required this.model,
    required this.failureInvite,
    this.deletVisitant = false,
  });

  @override
  List<Object?> get props =>
      [visitants, providers, visitant, model, failureInvite, deletVisitant];
}

class DeleteVisitantEvent extends AccessControlEvent {
  final List<AccessControl> visitants;
  final List<AccessControl> providers;
  final AccessControl visitant;

  const DeleteVisitantEvent({
    required this.visitants,
    required this.providers,
    required this.visitant,
  });

  @override
  List<Object?> get props => [visitants, providers, visitant];
}

class EditVisitEvent extends AccessControlEvent {
  final List<AccessControl> visitants;
  final List<AccessControl> providers;
  final AccessControlAuthorizations model;

  const EditVisitEvent({
    required this.visitants,
    required this.providers,
    required this.model,
  });

  @override
  List<Object?> get props => [visitants, providers, model];
}

class DeleteVisitEvent extends AccessControlEvent {
  final bool isVisitant;

  const DeleteVisitEvent({required this.isVisitant});

  @override
  List<Object?> get props => [isVisitant];
}

class DeleteFailureVisitEvent extends AccessControlEvent {
  final List<AccessControl> visitants;
  final List<AccessControl> providers;
  final AccessControl visitant;
  final AccessControlAuthorizations model;

  const DeleteFailureVisitEvent({
    required this.visitants,
    required this.providers,
    required this.visitant,
    required this.model,
  });

  @override
  List<Object?> get props => [visitants, providers, visitant, model];
}

class SearchingVisitantEvent extends AccessControlEvent {
  final List<AccessControl> visitants;
  final List<AccessControl> providers;

  const SearchingVisitantEvent({
    required this.visitants,
    required this.providers,
  });

  @override
  List<Object?> get props => [visitants, providers];
}

class SearchingProviderEvent extends AccessControlEvent {
  final List<AccessControl> visitants;
  final List<AccessControl> providers;

  const SearchingProviderEvent({
    required this.visitants,
    required this.providers,
  });

  @override
  List<Object?> get props => [visitants, providers];
}

class AccessControlOnBoardingEvent extends AccessControlEvent {
  const AccessControlOnBoardingEvent();
}
