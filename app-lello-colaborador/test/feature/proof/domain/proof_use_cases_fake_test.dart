import 'package:colaborador/feature/proof/domain/entity/proof.dart';
import 'package:colaborador/feature/proof/domain/entity/proofFile.dart';
import 'package:colaborador/feature/proof/domain/repository/proof_repository.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof/get_proof.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof/get_proof_impl.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof_file/get_proof_file.dart';
import 'package:colaborador/feature/proof/domain/use_case/get_proof_file/get_proof_file_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeProofRepo extends Fake implements ProofRepository {
  Object? last;
  bool fail = false;

  @override
  Future<Try<List<ProofEntity>>> getProof(condominiumId, DateTime date) async {
    if (fail) return Rejection(UnknownFailure('proof'));
    last = condominiumId;
    return Success([
      ProofEntity(dateTimeClockIn: '10/01/2026 08:00', proofName: 'p1.pdf'),
    ]);
  }

  @override
  Future<Try<ProofFileEntity>> getProofFile(
      String condominiumId, String fileName) async {
    if (fail) return Rejection(UnknownFailure('file'));
    last = fileName;
    return Success(ProofFileEntity(contentBytes: 'xyz'));
  }
}

void main() {
  group('GetProofUseCaseImpl', () {
    test('rejeita condomínio vazio', () async {
      final result = await GetProofUseCaseImpl(repository: _FakeProofRepo())(
        GetProofParams(condominiumId: '', date: DateTime(2026, 1, 10)),
      );
      expect(result, isA<Rejection<List<ProofEntity>>>());
    });

    test('lista comprovantes', () async {
      final repo = _FakeProofRepo();
      final result = await GetProofUseCaseImpl(repository: repo)(
        GetProofParams(condominiumId: 'c1', date: DateTime(2026, 1, 10)),
      );
      expect(result, isA<Success<List<ProofEntity>>>());
      expect(repo.last, 'c1');
    });

    test('rejeita erro do repositório', () async {
      final result = await GetProofUseCaseImpl(
        repository: _FakeProofRepo()..fail = true,
      )(GetProofParams(condominiumId: 'c1', date: DateTime(2026, 1, 10)));
      expect(result, isA<Rejection<List<ProofEntity>>>());
    });
  });

  group('GetProofFileUseCaseImpl', () {
    test('rejeita condomínio vazio', () async {
      final result = await GetProofFileUseCaseImpl(
        repository: _FakeProofRepo(),
      )(GetProofFileParams(condominiumId: '', fileName: 'a.pdf'));
      expect(result, isA<Rejection<ProofFileEntity>>());
    });

    test('busca o arquivo', () async {
      final repo = _FakeProofRepo();
      final result = await GetProofFileUseCaseImpl(repository: repo)(
        GetProofFileParams(condominiumId: 'c1', fileName: 'a.pdf'),
      );
      expect(result, isA<Success<ProofFileEntity>>());
      expect(repo.last, 'a.pdf');
    });

    test('rejeita erro do repositório', () async {
      final result = await GetProofFileUseCaseImpl(
        repository: _FakeProofRepo()..fail = true,
      )(GetProofFileParams(condominiumId: 'c1', fileName: 'a.pdf'));
      expect(result, isA<Rejection<ProofFileEntity>>());
    });
  });
}
