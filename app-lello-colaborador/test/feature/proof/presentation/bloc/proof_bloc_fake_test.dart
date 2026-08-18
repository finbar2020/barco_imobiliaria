import 'package:colaborador/feature/proof/domain/entity/proof.dart';
import 'package:colaborador/feature/proof/domain/entity/proofFile.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof/get_proof.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof_file/get_proof_file.dart';
import 'package:colaborador/feature/proof/presentation/bloc/proof_bloc.dart';
import 'package:colaborador/feature/proof/presentation/bloc/proof_state.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';

class _FakeGetProof extends Fake implements GetProofUseCase {
  bool fail = false;

  @override
  Future<Try<List<ProofEntity>>> call(GetProofParams params) async {
    if (fail) return Rejection(KnownFailure('500', 'erro'));
    return Success([
      ProofEntity(nsr: 1, dateTimeClockIn: '10/01/2026 08:00', proofName: 'p1'),
    ]);
  }
}

class _FakeGetFile extends Fake implements GetProofFileUseCase {
  bool fail = false;

  @override
  Future<Try<ProofFileEntity>> call(GetProofFileParams params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(ProofFileEntity(contentBytes: 'abc'));
  }
}

void main() {
  group('ProofBloc', () {
    test('carrega comprovantes no construtor', () async {
      final bloc = ProofBloc(
        getProofUseCase: _FakeGetProof(),
        getProofFileUseCase: _FakeGetFile(),
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      final state = await bloc.stream.firstWhere(
        (s) => s is ProofLoadedState || s is ProofFailedState,
      );
      expect(state, isA<ProofLoadedState>());
      expect((state as ProofLoadedState).proofs, hasLength(1));
    });

    test('emite failed quando a lista rejeita', () async {
      final bloc = ProofBloc(
        getProofUseCase: _FakeGetProof()..fail = true,
        getProofFileUseCase: _FakeGetFile(),
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      final state = await bloc.stream.firstWhere(
        (s) => s is ProofLoadedState || s is ProofFailedState,
      );
      expect(state, isA<ProofFailedState>());
    });

    test('anexa base64 ao carregar o arquivo', () async {
      final bloc = ProofBloc(
        getProofUseCase: _FakeGetProof(),
        getProofFileUseCase: _FakeGetFile(),
        sessionBloc: FakeSessionBloc(),
      );
      addTearDown(bloc.close);
      await bloc.stream.firstWhere(
        (s) => s is ProofLoadedState || s is ProofFailedState,
      );
      bloc.showMyProofFile(fileName: 'p1.pdf');
      final state = await bloc.stream.firstWhere(
        (s) => s is ProofLoadedState && s.base64 != null,
      );
      expect((state as ProofLoadedState).base64, 'abc');
    });
  });
}
