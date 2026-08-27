import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/core/uploader/uploader.dart';
import 'package:morar/feature/access_control/data/model/url_upload_s3_model.dart';
import 'package:morar/feature/change_ownership/data/data_source/change_ownership_api.dart';
import 'package:morar/feature/change_ownership/data/data_source/change_ownership_data_source.dart';
import 'package:morar/feature/change_ownership/data/data_source/change_ownership_data_source_impl.dart';
import 'package:morar/feature/change_ownership/data/model/aws_payload_model.dart';
import 'package:morar/feature/change_ownership/data/model/can_change_model.dart';
import 'package:morar/feature/change_ownership/data/model/change_ownership_model.dart';
import 'package:morar/feature/change_ownership/data/repository/change_ownership_repository_impl.dart';
import 'package:morar/feature/change_ownership/domain/entity/aws_payload_entity.dart';
import 'package:morar/feature/change_ownership/domain/entity/can_change_entity.dart';
import 'package:morar/feature/change_ownership/domain/entity/ownership_entity.dart';
import 'package:morar/feature/change_ownership/domain/repository/change_ownership_repository.dart';
import 'package:morar/feature/change_ownership/domain/use_case/can_change/can_change.dart';
import 'package:morar/feature/change_ownership/domain/use_case/can_change/can_change_impl.dart';
import 'package:morar/feature/change_ownership/domain/use_case/post_change/post_change.dart';
import 'package:morar/feature/change_ownership/domain/use_case/post_change/post_change_impl.dart';
import 'package:morar/feature/change_ownership/presentation/bloc/change_ownership_bloc.dart';
import 'package:morar/feature/change_ownership/presentation/bloc/change_ownership_event.dart';
import 'package:morar/feature/change_ownership/presentation/bloc/change_ownership_state.dart';
import 'package:morar/feature/change_ownership/presentation/controller/ownership_controller.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';

class MockApi extends Mock implements ChangeOwnershipApi {}

File _tempFile() {
  final file = File('${Directory.systemTemp.path}/morar_ownership_test.pdf');
  file.writeAsStringSync('x');
  return file;
}

OwnershipEntity _validEntity() => OwnershipEntity(
      personType: 'F',
      document: '123.456.789-01',
      registration: 'r',
      name: 'n',
      email: 'e',
      phone: '(11) 3333-4444',
      cellphone: '(11) 99999-8888',
      rg: '12.345-6',
      attachment: _tempFile(),
    );

class _FakeDataSource extends Fake implements ChangeOwnershipRemoteDataSource {
  _FakeDataSource({this.fail = false});
  final bool fail;
  ChangeOwnershipModel? posted;

  @override
  Future<UrlUploadS3Model> getAws(String condoId) async {
    if (fail) throw Exception('x');
    return UrlUploadS3Model(fileName: 'f.pdf', url: 'https://s3/$condoId');
  }

  @override
  Future<String> postChange(String condoId, ChangeOwnershipModel model) async {
    if (fail) throw Exception('x');
    posted = model;
    return '';
  }

  @override
  Future<CanChangeModel> getCanChange(String condoId) async {
    if (fail) throw Exception('x');
    return CanChangeModel(canChange: true, message: 'ok');
  }
}

class _FakeUploader extends Fake implements Uploader {
  _FakeUploader({this.fail = false, this.throws = false});
  final bool fail;
  final bool throws;

  @override
  Future<String> uploadS3(String url, File file,
      {required Function(String) onComplete,
      required Function(Exception) onError}) async {
    if (throws) throw Exception('boom');
    if (fail) {
      onError(Exception('upload'));
    } else {
      onComplete('Sended');
    }
    return 'Sending';
  }
}

class _FakeRepository extends Fake implements ChangeOwnershipRepository {
  _FakeRepository({this.failCanChange = false});
  final bool failCanChange;
  final calls = <String>[];

  @override
  Future<Try<CanChangeEntity>> getCanChange(String condoId) async {
    calls.add('can:$condoId');
    if (failCanChange) return Rejection(UnknownFailure('x'));
    return Success(CanChangeEntity(canChange: false, message: 'não'));
  }

  @override
  Future<Try<UrlUploadS3>> getAws(String reference, OwnershipEntity entity) async {
    calls.add('aws:$reference');
    return Success(UrlUploadS3(fileName: 'f', url: 'u'));
  }

  @override
  Future<Try<String>> uploadImageToAws(File file, String url) async {
    calls.add('upload:$url');
    return Success('ok');
  }

  @override
  Future<Try<String>> postChange(String condoId, OwnershipEntity entity) async {
    calls.add('post:$condoId');
    return Success('');
  }
}

class _FakeAwsUpload extends Fake implements AwsUploadFileUsecase {
  _FakeAwsUpload({this.fail = false});
  final bool fail;
  @override
  Future<Try<UrlUploadS3>> call(AwsUploadFileParam params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    final url = await params.getUrlUploadS3();
    return url.fold(
      (f) => Rejection(f),
      (u) async => (await params.uploadFileToS3(params.file, u.url))
          .fold((f) => Rejection(f), (_) => Success(u)),
    );
  }
}

class _FakeCanChange extends Fake implements CanChangeUseCase {
  _FakeCanChange({this.fail = false});
  final bool fail;
  @override
  Future<Try<CanChangeEntity>> call(CanChangeParams params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success(CanChangeEntity(canChange: true));
  }
}

class _FakePostChange extends Fake implements PostChangeUseCase {
  _FakePostChange({this.fail = false});
  final bool fail;
  @override
  Future<Try<String>> call(PostChangeParams params) async {
    if (fail) return Rejection(UnknownFailure('x'));
    return Success('');
  }
}

Future<List<dynamic>> _collect(
    ChangeOwnershipBloc bloc, Future<void> Function() run) async {
  final states = <dynamic>[];
  final sub = bloc.stream.listen(states.add);
  await run();
  await Future<void>.delayed(Duration.zero);
  await sub.cancel();
  return states;
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  test('models', () {
    final aws = AwsPayloadModel.fromEntity(AwsPayloadEntity(fileName: 'f', bucket: 'b', httpMethod: 'PUT', url: 'u'));
    expect(aws.toJson()['http_method'], 'PUT');
    expect(AwsPayloadModel.fromJson(aws.toJson()).toEntity().bucket, 'b');

    expect(CanChangeModel.fromJson({'can_change': null}).toEntity().canChange, isFalse);
    expect(CanChangeModel.fromEntity(CanChangeEntity(canChange: true, message: 'm')).toJson(),
        {'can_change': true, 'message': 'm'});

    final entity = _validEntity();
    final model = ChangeOwnershipModel.fromEntity(entity);
    final json = jsonDecode(jsonEncode(model.toJson())) as Map<String, dynamic>;
    expect(json['person_type'], 'F');
    expect(json['archives'], isEmpty);
    final back = ChangeOwnershipModel.fromJson(json).toEntity();
    expect(back.email, 'e');
    expect(back.archives, isEmpty);
    expect(ChangeOwnershipModel().toEntity().archives, isEmpty);
  });

  test('CanChangeUseCaseImpl', () async {
    final repo = _FakeRepository();
    final useCase = CanChangeUseCaseImpl(repository: repo);
    expect((await useCase(CanChangeParams(condoId: ''))).fold((f) => f, (_) => null),
        isA<InvalidParamFailure>());
    final ok = await useCase(CanChangeParams(condoId: 'c'));
    expect(ok.fold((_) => null, (e) => e.message), 'não');
  });

  group('PostChangeUseCaseImpl', () {
    test('valida os campos obrigatórios', () async {
      final useCase = PostChangeUseCaseImpl(
        repository: _FakeRepository(),
        awsUploadFileUsecase: _FakeAwsUpload(),
      );
      Future<Failure?> run(OwnershipEntity e, [String condo = 'c']) async =>
          (await useCase(PostChangeParams(condoId: condo, entity: e)))
              .fold((f) => f, (_) => null);

      expect(await run(_validEntity(), ''), isA<InvalidParamFailure>());
      expect(await run(_validEntity()..personType = ''), isA<InvalidParamFailure>());
      expect(await run(_validEntity()..registration = ''), isA<InvalidParamFailure>());
      expect(await run(_validEntity()..name = ''), isA<InvalidParamFailure>());
      expect(await run(_validEntity()..email = ''), isA<InvalidParamFailure>());
      expect(await run(_validEntity()..phone = ''), isA<InvalidParamFailure>());
      expect(await run(_validEntity()..cellphone = ''), isA<InvalidParamFailure>());
      expect(await run(_validEntity()..attachment = null), isA<InvalidParamFailure>());
    });

    test('faz upload e envia a troca', () async {
      final repo = _FakeRepository();
      final useCase = PostChangeUseCaseImpl(
        repository: repo,
        awsUploadFileUsecase: _FakeAwsUpload(),
      );
      final result = await useCase(PostChangeParams(condoId: 'c', entity: _validEntity()));
      expect(result.fold((_) => null, (r) => r), '');
      expect(repo.calls, ['aws:c', 'upload:u', 'post:c']);
    });

    test('falha no upload rejeita com KnownFailure', () async {
      final useCase = PostChangeUseCaseImpl(
        repository: _FakeRepository(),
        awsUploadFileUsecase: _FakeAwsUpload(fail: true),
      );
      final result = await useCase(PostChangeParams(condoId: 'c', entity: _validEntity()));
      final failure = result.fold((f) => f, (_) => null) as KnownFailure;
      expect(failure.code, '500');
      expect(failure.error, 'upload_file_error');
    });
  });

  group('ChangeOwnershipRepositoryImpl', () {
    test('getAws preenche archives', () async {
      final entity = _validEntity();
      final repo = ChangeOwnershipRepositoryImpl(dataSource: _FakeDataSource(), uploader: _FakeUploader());
      final result = await repo.getAws('c', entity);
      expect(result.fold((_) => null, (u) => u.url), 'https://s3/c');
      expect(entity.archives, ['f.pdf']);
    });

    test('postChange limpa máscaras', () async {
      final ds = _FakeDataSource();
      final repo = ChangeOwnershipRepositoryImpl(dataSource: ds, uploader: _FakeUploader());
      final result = await repo.postChange('c', _validEntity());
      expect(result.fold((_) => null, (r) => r), '');
      expect(ds.posted!.document, '12345678901');
      expect(ds.posted!.rg, '123456');
      expect(ds.posted!.phone, '1133334444');
      expect(ds.posted!.cellphone, '11999998888');
    });

    test('uploadImageToAws e getCanChange', () async {
      final repo = ChangeOwnershipRepositoryImpl(dataSource: _FakeDataSource(), uploader: _FakeUploader());
      expect((await repo.uploadImageToAws(_tempFile(), 'u')).fold((_) => null, (r) => r), 'Sended');
      expect((await repo.getCanChange('c')).fold((_) => null, (e) => e.canChange), isTrue);

      final failing = ChangeOwnershipRepositoryImpl(dataSource: _FakeDataSource(), uploader: _FakeUploader(fail: true));
      expect((await failing.uploadImageToAws(_tempFile(), 'u')).fold((f) => f, (_) => null),
          isA<UnknownFailure>());
      final throwing = ChangeOwnershipRepositoryImpl(dataSource: _FakeDataSource(), uploader: _FakeUploader(throws: true));
      expect((await throwing.uploadImageToAws(_tempFile(), 'u')).fold((f) => f, (_) => null),
          isA<UnknownFailure>());
    });

    test('falhas do data source', () async {
      final repo = ChangeOwnershipRepositoryImpl(dataSource: _FakeDataSource(fail: true), uploader: _FakeUploader());
      expect((await repo.getAws('c', _validEntity())).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.postChange('c', _validEntity())).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.getCanChange('c')).fold((f) => f, (_) => null), isA<UnknownFailure>());
    });
  });

  test('data source', () async {
    final api = MockApi();
    registerFallbackValue(ChangeOwnershipModel());
    final ds = ChangeOwnershipRemoteDataSourceImpl(api: api);
    when(() => api.getAwsPayload('c')).thenAnswer(
      (_) async => Response<dynamic>(http.Response(jsonEncode({'file_name': 'f', 'url': 'u'}), 200), null),
    );
    when(() => api.getCanChange('c')).thenAnswer(
      (_) async => Response<dynamic>(http.Response(jsonEncode({'can_change': true}), 200), null),
    );
    when(() => api.postChange('c', any())).thenAnswer(
      (_) async => Response<dynamic>(http.Response('', 200), null),
    );
    when(() => api.postChange('e', any())).thenAnswer(
      (_) async => Response<dynamic>(http.Response('', 500), null, error: 'err'),
    );
    expect((await ds.getAws('c')).fileName, 'f');
    expect((await ds.getCanChange('c')).canChange, isTrue);
    expect(await ds.postChange('c', ChangeOwnershipModel()), '');
    expect(() => ds.postChange('e', ChangeOwnershipModel()), throwsA('err'));
  });

  test('bloc', () async {
    final bloc = ChangeOwnershipBloc();
    expect(bloc.state, const ChangeOwnershipInitialState());
    final states = await _collect(bloc, () async {
      bloc
        ..add(const ChangeOwnershipLoadingEvent())
        ..add(const ChangeOwnershipLoadedEvent(canChange: false, cantChangeMessage: 'm'))
        ..add(const ChangeOwnershipFailureEvent(error: 'e'))
        ..add(const ChangeOwnershipSuccessEvent());
    });
    await bloc.close();
    expect(states, [
      const ChangeOwnershipLoadingState(),
      const ChangeOwnershipLoadedState(canChange: false, cantChangeMessage: 'm'),
      const ChangeOwnershipFailureState(errorMessageKey: 'e'),
      const ChangeOwnershipSuccessState(),
    ]);
    expect(const ChangeOwnershipLoadedEvent(canChange: true).props, [true, '']);
    expect(const ChangeOwnershipFailureEvent(error: 'e').props, ['e']);
  });

  group('OwnershipController', () {
    late ChangeOwnershipBloc bloc;
    setUp(() => bloc = ChangeOwnershipBloc());
    tearDown(() => bloc.close());

    OwnershipController build({bool failPost = false, bool failCan = false}) =>
        OwnershipController(
          bloc: bloc,
          sessionBloc: FakeSessionBloc(),
          postChangeUsecase: _FakePostChange(fail: failPost),
          canChange: _FakeCanChange(fail: failCan),
        );

    test('getCanChange', () async {
      var states = await _collect(bloc, build().getCanChange);
      expect(states, [
        const ChangeOwnershipLoadingState(),
        const ChangeOwnershipLoadedState(canChange: true),
      ]);
      states = await _collect(bloc, build(failCan: true).getCanChange);
      expect(states.last, const ChangeOwnershipFailureState(errorMessageKey: ''));
    });

    test('postChange', () async {
      var states = await _collect(bloc, build().postChange);
      expect(states.last, const ChangeOwnershipSuccessState());
      states = await _collect(bloc, build(failPost: true).postChange);
      expect(states.last, const ChangeOwnershipFailureState(errorMessageKey: ''));
    });
  });
}
