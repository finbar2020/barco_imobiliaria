import 'package:essentials/essentials.dart';
import 'package:morar/feature/access_control/domain/entity/access_control.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_authorizations.dart';

abstract class AccessControlState extends Equatable {
  final List<AccessControl> visitants;
  final List<AccessControl> providers;

  const AccessControlState({
    this.visitants = const [],
    this.providers = const [],
  });

  @override
  List<Object?> get props => [visitants, providers];
}

class AccessControlLoadingState extends AccessControlState {
  const AccessControlLoadingState();
}

class AccessControlLoadedState extends AccessControlState {
  const AccessControlLoadedState({
    required List<AccessControl> visitants,
    required List<AccessControl> providers,
  }) : super(visitants: visitants, providers: providers);
}

class AccessControlFailureState extends AccessControlState {
  const AccessControlFailureState();
}

class EditVisitantState extends AccessControlState {
  final AccessControl visitant;
  final AccessControlAuthorizations model;

  const EditVisitantState({
    required this.visitant,
    required List<AccessControl> providers,
    required this.model,
    required List<AccessControl> visitants,
  }) : super(visitants: visitants, providers: providers);

  @override
  List<Object?> get props => [visitant, model, visitants, providers];
}

class SaveVisitantLoadedState extends AccessControlState {
  final bool useFacial;
  final bool isVisitant;
  final String? link;
  final bool newVisit;
  final bool edit;
  final bool sendInvite;

  const SaveVisitantLoadedState({
    required List<AccessControl> visitants,
    required List<AccessControl> providers,
    required this.useFacial,
    required this.isVisitant,
    this.link,
    this.newVisit = false,
    this.edit = false,
    this.sendInvite = false,
  }) : super(visitants: visitants, providers: providers);

  @override
  List<Object?> get props =>
      [visitants, providers, useFacial, isVisitant, link, newVisit, edit, sendInvite];
}

class SaveVisitantFailureState extends AccessControlState {
  final AccessControl visitant;
  final AccessControlAuthorizations model;
  final bool failureInvite;
  final bool deletVisitant;

  const SaveVisitantFailureState({
    required List<AccessControl> visitants,
    required List<AccessControl> providers,
    required this.visitant,
    required this.model,
    required this.failureInvite,
    this.deletVisitant = false,
  }) : super(visitants: visitants, providers: providers);

  @override
  List<Object?> get props =>
      [visitants, providers, visitant, model, failureInvite, deletVisitant];
}

class DeleteVisitantState extends AccessControlState {
  final AccessControl visitant;

  const DeleteVisitantState({
    required List<AccessControl> visitants,
    required List<AccessControl> providers,
    required this.visitant,
  }) : super(visitants: visitants, providers: providers);

  @override
  List<Object?> get props => [visitants, providers, visitant];
}

class EditVisitState extends AccessControlState {
  final AccessControlAuthorizations model;

  const EditVisitState({
    required List<AccessControl> visitants,
    required List<AccessControl> providers,
    required this.model,
  }) : super(visitants: visitants, providers: providers);

  @override
  List<Object?> get props => [visitants, providers, model];
}

class DeleteVisitState extends AccessControlState {
  final bool isVisitant;

  const DeleteVisitState({required this.isVisitant});

  @override
  List<Object?> get props => [isVisitant];
}

class DeleteFailureVisitState extends AccessControlState {
  final AccessControl visitant;
  final AccessControlAuthorizations model;

  const DeleteFailureVisitState({
    required List<AccessControl> visitants,
    required List<AccessControl> providers,
    required this.visitant,
    required this.model,
  }) : super(visitants: visitants, providers: providers);

  @override
  List<Object?> get props => [visitants, providers, visitant, model];
}

class SearchingVisitantState extends AccessControlState {
  const SearchingVisitantState({
    required List<AccessControl> visitants,
    required List<AccessControl> providers,
  }) : super(visitants: visitants, providers: providers);
}

class SearchingProviderState extends AccessControlState {
  const SearchingProviderState({
    required List<AccessControl> visitants,
    required List<AccessControl> providers,
  }) : super(visitants: visitants, providers: providers);
}

class AccessControlOnBoardingState extends AccessControlState {
  const AccessControlOnBoardingState();
}
