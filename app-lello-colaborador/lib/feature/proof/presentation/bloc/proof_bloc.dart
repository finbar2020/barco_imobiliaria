import 'package:colaborador/feature/proof/domain/entity/proof.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof/get_proof.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof_file/get_proof_file.dart';
import 'package:colaborador/feature/proof/presentation/bloc/proof_event.dart';
import 'package:colaborador/feature/proof/presentation/bloc/proof_state.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProofBloc extends Bloc<ProofEvent, ProofState> {
  final GetProofUseCase getProofUseCase;
  final GetProofFileUseCase getProofFileUseCase;

  final SessionBloc sessionBloc;
  List<ProofEntity> proofs = [];

  ProofBloc({
    required this.getProofUseCase,
    required this.getProofFileUseCase,
    required this.sessionBloc,
  }) : super(const ProofInitialState()) {
    on<GetProofEvent>(_mapGetProof);
    on<GetProofFileEvent>(_mapGetProofFile);
    showMyProofs(date: DateTime.now());
  }

  Future<void> _mapGetProof(
    GetProofEvent event,
    Emitter<ProofState> emit,
  ) async {
    emit(const ProofLoadingState());
    String condoId = sessionBloc.getSession?.condominium.id ?? "";

    final result = await getProofUseCase.call(GetProofParams(
      condominiumId: condoId,
      date: event.date,
    ));

    ProofState response = result.fold(
      (err) => ProofFailedState(
        errorDescription: err.error ?? "",
        errorCode: err.code.toString(),
      ),
      (res) {
        proofs = res;
        return ProofLoadedState(proofs: res);
      },
    );

    emit(response);
  }

  Future<void> _mapGetProofFile(
    GetProofFileEvent event,
    Emitter<ProofState> emit,
  ) async {
    emit(const ProofLoadingState());
    String condoId = sessionBloc.getSession?.condominium.id ?? "";

    final result = await getProofFileUseCase.call(GetProofFileParams(
      condominiumId: condoId,
      fileName: event.fileName,
    ));

    ProofState response = result.fold(
      (err) => const ProofFileFailedState(),
      (res) => ProofLoadedState(proofs: proofs, base64: res.contentBytes),
    );

    emit(response);
  }

  void showMyProofs({required DateTime date}) {
    add(GetProofEvent(date: date));
  }

  void showMyProofFile({required String fileName}) {
    add(GetProofFileEvent(fileName: fileName));
  }
}
