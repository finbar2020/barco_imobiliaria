import 'package:colaborador/feature/proof/domain/entity/proof.dart';
import 'package:colaborador/feature/proof/domain/entity/proofFile.dart';
import 'package:essentials/essentials.dart';

abstract class ProofState extends Equatable {
  const ProofState();

  @override
  List<Object?> get props => [];
}

class ProofInitialState extends ProofState {
  const ProofInitialState();
}

class ProofLoadingState extends ProofState {
  const ProofLoadingState();
}

class ProofLoadedState extends ProofState {
  final List<ProofEntity> proofs;
  final String? base64;

  const ProofLoadedState({
    required this.proofs,
    this.base64,
  });

  @override
  List<Object?> get props => [proofs, base64];
}

class ProofFailedState extends ProofState {
  final String errorDescription;
  final String errorCode;

  const ProofFailedState(
      {required this.errorDescription, required this.errorCode});

  @override
  List<Object?> get props => [errorDescription, errorCode];
}

class ProofFileLoadingState extends ProofState {
  const ProofFileLoadingState();
}

class ProofFileLoadedState extends ProofState {
  final ProofFileEntity proofFile;

  const ProofFileLoadedState({
    required this.proofFile,
  });

  @override
  List<Object?> get props => [proofFile];
}

class ProofFileFailedState extends ProofState {
  const ProofFileFailedState();
}
