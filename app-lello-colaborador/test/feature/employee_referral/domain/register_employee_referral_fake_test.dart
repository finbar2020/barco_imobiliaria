import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:colaborador/feature/employee_referral/domain/repository/employee_referral_repository.dart';
import 'package:colaborador/feature/employee_referral/domain/use_case/register_employee_referral/employee_referral.dart';
import 'package:colaborador/feature/employee_referral/domain/use_case/register_employee_referral/employee_referral_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart';

import '../../../helpers/fixtures.dart';

class _FakeRepo extends Fake implements EmployeeReferralRepository {
  EmployeeReferralEntity? last;

  @override
  Future<Try<EmployeeReferralEntity>> registerEmployeeReferral(
    EmployeeReferralEntity entity,
    String condoId,
    String employeeId,
  ) async {
    last = entity;
    return Success(entity);
  }
}

class _FakeAws extends Fake implements AwsUploadFileUsecase {
  bool fail = false;

  @override
  Future<Try<UrlUploadS3>> call(AwsUploadFileParam params) async {
    if (fail) return Rejection(UnknownFailure('upload'));
    return Success(UrlUploadS3(fileName: 'hash.png', url: 'http://s3'));
  }
}

void main() {
  group('EmployeeReferralEntity', () {
    test('isValid exige descrição, cidade e arquivo', () {
      expect(EmployeeReferralEntity().isValid, isFalse);
      expect(
        EmployeeReferralEntity(description: 'vaga', city: 'SP').isValid,
        isFalse,
      );
      expect(
        EmployeeReferralEntity(
          description: 'vaga',
          city: 'SP',
          file: testTempFile(),
        ).isValid,
        isTrue,
      );
    });

    test('isRegionValid respeita hasRegion', () {
      expect(EmployeeReferralEntity(hasRegion: true).isRegionValid, isFalse);
      expect(
        EmployeeReferralEntity(hasRegion: true, region: 'zona sul').isRegionValid,
        isTrue,
      );
      expect(
        EmployeeReferralEntity(hasRegion: false, region: 'zona sul').isRegionValid,
        isFalse,
      );
      expect(EmployeeReferralEntity().isRegionValid, isTrue);
    });
  });

  group('RegisterEmployeeReferralUsecaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        RegisterEmployeeReferralUsecaseImpl(
          repository: _FakeRepo(),
          awsUploadFileUsecase: _FakeAws(),
        ).validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita sem arquivo', () async {
      final result = await RegisterEmployeeReferralUsecaseImpl(
        repository: _FakeRepo(),
        awsUploadFileUsecase: _FakeAws(),
      )(RegisterEmployeeReferralParam(
        condoId: 'c1',
        employeeId: 'm1',
        employeeReferralEntity: EmployeeReferralEntity(
          description: 'vaga',
          city: 'SP',
        ),
      ));
      expect(result, isA<Rejection<EmployeeReferralEntity>>());
    });

    test('rejeita falha de upload', () async {
      final result = await RegisterEmployeeReferralUsecaseImpl(
        repository: _FakeRepo(),
        awsUploadFileUsecase: _FakeAws()..fail = true,
      )(RegisterEmployeeReferralParam(
        condoId: 'c1',
        employeeId: 'm1',
        employeeReferralEntity: EmployeeReferralEntity(
          description: 'vaga',
          city: 'SP',
          file: testTempFile(),
        ),
      ));
      expect(result, isA<Rejection<EmployeeReferralEntity>>());
    });

    test('registra após upload', () async {
      final repo = _FakeRepo();
      final entity = EmployeeReferralEntity(
        description: 'vaga',
        city: 'SP',
        file: testTempFile(),
      );
      final result = await RegisterEmployeeReferralUsecaseImpl(
        repository: repo,
        awsUploadFileUsecase: _FakeAws(),
      )(RegisterEmployeeReferralParam(
        condoId: 'c1',
        employeeId: 'm1',
        employeeReferralEntity: entity,
      ));
      expect(result, isA<Success<EmployeeReferralEntity>>());
      expect(entity.fileTempHash, 'hash.png');
      expect(repo.last, entity);
    });
  });
}
