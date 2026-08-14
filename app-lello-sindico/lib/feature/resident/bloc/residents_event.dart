import 'package:essentials/essentials.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';

abstract class ResidentsEvent {}

class ResidentsLoadingEvent extends ResidentsEvent {}

class ResidentsLoadFailedEvent extends ResidentsEvent {
  final Failure failure;
  ResidentsLoadFailedEvent({required this.failure});
}

class ResidentsPagingEvent extends ResidentsEvent {}

class ResidentsPageFailedEvent extends ResidentsEvent {
  final Failure failure;
  ResidentsPageFailedEvent({required this.failure});
}

class ResidentsLoadedEvent extends ResidentsEvent {
  List<Resident>? data;
  String? query;
  List<String>? blocks = [];
  bool? donePaging;
  ResidentsLoadedEvent(
      {required List<Resident> this.data,
      required String this.query,
      required List<String> this.blocks,
      this.donePaging});
}

class ResidentsSearchingEvent extends ResidentsEvent {}
