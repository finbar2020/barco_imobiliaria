import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';

abstract class ResidentsState {}

class ResidentsLoadingState extends ResidentsState {}

class ResidentsLoadFailedState extends ResidentsState {
  final Failure failure;
  ResidentsLoadFailedState({required this.failure});
}

class ResidentsPagingState extends ResidentsState {}

class ResidentsPageFailedState extends ResidentsState {
  final Failure failure;
  ResidentsPageFailedState({required this.failure});
}

class ResidentsLoadedState extends ResidentsState {
  List<Resident>? data;
  String? query;
  List<String>? blocks = [];
  bool? donePaging;
  ResidentsLoadedState(
      {required List<Resident> this.data,
      required String this.query,
      required List<String> this.blocks,
      required this.donePaging});
}

class ResidentsSearchingState extends ResidentsState {}
