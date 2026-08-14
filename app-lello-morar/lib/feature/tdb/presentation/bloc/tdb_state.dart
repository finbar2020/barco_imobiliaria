import 'package:essentials/essentials.dart';
import 'package:morar/feature/tdb/domain/entity/tdb_info.dart';

abstract class TDBState extends Equatable {
  const TDBState();

  @override
  List<Object?> get props => [];
}

class LoadingTDBState extends TDBState {
  const LoadingTDBState();
}

class LoadedTDBState extends TDBState {
  final TDBInfo? tdbInfo;

  const LoadedTDBState({this.tdbInfo});

  @override
  List<Object?> get props => [tdbInfo];
}

class ErrorTDBState extends TDBState {
  final String errorMessageKey;

  const ErrorTDBState({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}
