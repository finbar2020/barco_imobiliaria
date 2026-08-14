import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/data/data_source/local/space_local_data_source.dart';
import 'package:lello/feature/space/data/data_source/remote/space_remote_data_source.dart';
import 'package:lello/feature/space/data/model/space_model.dart';
import 'package:lello/feature/space/data/repository/space_repostiory_impl.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/repository/space_repository.dart';
import 'package:lello/feature/space/registration/data/data_source/space_registartion_request_remote_data_source.dart';
import 'package:lello/feature/space/registration/data/model/space_registration_request_model.dart';
import 'package:lello/feature/space/registration/data/repository/space_registration_request_repository_impl.dart';
import 'package:lello/feature/space/registration/domain/entity/space_registration_request.dart';
import 'package:lello/feature/space/registration/domain/repository/space_registrtion_request_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  SpaceRegistrationRequestRepository repository;
  SpaceRegistrationRequestRemoteDataSource remoteDataSource;

  final _condoId = "123";
  final _data = SpaceRegistrationRequest();
  final _model = SpaceRegistrationRequestModel();
  setUp(() {
    remoteDataSource = SpaceRegistrationRequestRemoteDataSourceMock();
    repository =
        SpaceRegistrationRequestRepositoryImpl(dataSource: remoteDataSource);
  });

  group('insert', () {
    test('Should call remote data source list', () async {
      when(remoteDataSource.insert(_condoId, any))
          .thenAnswer((_) async => _model);
      await repository.insert(_condoId, _data);
      verify(remoteDataSource.insert(_condoId, any));
    });

    test('Should return success if data source succeeds', () async {
      when(remoteDataSource.insert(_condoId, any))
          .thenAnswer((_) async => _model);
      final result = await repository.insert(_condoId, _data);
      expect(result, isA<Success<SpaceRegistrationRequest>>());
    });

    test('Should return rejection if datasource throws', () async {
      when(remoteDataSource.insert(_condoId, any)).thenThrow(Exception());
      final result = await repository.insert(_condoId, _data);
      expect(
          result,
          IsAnd<Rejection<SpaceRegistrationRequest>>(
              (it) => it.get() is Failure));
    });
  });
}

class SpaceLocalDataSourceMock extends Mock implements SpaceLocalDataSource {}

class SpaceRegistrationRequestRemoteDataSourceMock extends Mock
    implements SpaceRegistrationRequestRemoteDataSource {}
