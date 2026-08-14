import 'package:essentials/essentials.dart';
import 'package:morar/feature/tdb/domain/entity/tdb_info.dart';

abstract class TDBEvent extends Equatable {
  const TDBEvent();

  @override
  List<Object?> get props => [];
}

class TDBLoadingEvent extends TDBEvent {
  const TDBLoadingEvent();
}

class TDBLoadedEvent extends TDBEvent {
  final TDBInfo tdbInfo;

  const TDBLoadedEvent({required this.tdbInfo});

  @override
  List<Object?> get props => [tdbInfo];
}

class TDBErroEvent extends TDBEvent {
  final String errorMessageKey;

  const TDBErroEvent({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}
