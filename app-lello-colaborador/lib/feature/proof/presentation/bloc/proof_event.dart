import 'package:essentials/essentials.dart';

abstract class ProofEvent extends Equatable {
  const ProofEvent();

  @override
  List<Object?> get props => [];
}

class GetProofEvent extends ProofEvent {
  final DateTime date;
  const GetProofEvent({required this.date});

  @override
  List<Object?> get props => [date];
}

class GetProofFileEvent extends ProofEvent {
  final String fileName;
  const GetProofFileEvent({required this.fileName});

  @override
  List<Object?> get props => [fileName];
}
