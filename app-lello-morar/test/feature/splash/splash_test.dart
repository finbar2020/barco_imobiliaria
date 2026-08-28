import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/splash/data/data_source/boot_data_source.dart';
import 'package:morar/feature/splash/data/data_source/boot_data_source_impl.dart';
import 'package:morar/feature/splash/data/model/boot_data_model.dart';
import 'package:morar/feature/splash/data/repository/boot_data_repository_impl.dart';
import 'package:morar/feature/splash/domain/entity/boot_data.dart';
import 'package:morar/feature/splash/domain/repository/boot_data_repository.dart';
import 'package:morar/feature/splash/domain/use_case/get_boot_data/get_boot_data.dart';
import 'package:morar/feature/splash/domain/use_case/get_boot_data/get_boot_data_impl.dart';
import 'package:morar/feature/splash/domain/use_case/set_boot_data/set_boot_data_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/firebase_mocks.dart';

class _ThrowingDataSource extends Fake implements BootDataSource {
  @override
  Future<BootDataModel?> select() async => throw Exception('x');
  @override
  Future<BootDataModel?> save(BootDataModel? model) async => throw Exception('x');
}

class _ThrowingRepository extends Fake implements BootDataRepository {
  @override
  Future<Try<BootData?>> select() async => throw Exception('x');
  @override
  Future<Try<BootData?>> save(BootData? data) async => throw Exception('x');
}

class _RejectingRepository extends Fake implements BootDataRepository {
  @override
  Future<Try<BootData?>> select() async => Rejection(UnknownFailure('x'));
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('BootDataModel', () {
    expect(BootDataModel.fromEntity(null), isNull);
    final model = BootDataModel.fromEntity(BootData()..showOnBoarding = true)!;
    expect(model.toJson(), {'show_on_boarding': true});
    expect(BootDataModel.fromJson({'show_on_boarding': null}).toEntity().showOnBoarding, isFalse);
  });

  test('BootDataSourceImpl persiste no SharedPreferences', () async {
    final ds = BootDataSourceImpl();
    expect(await ds.select(), isNull);
    await ds.save(BootDataModel()..showOnBoarding = false);
    expect((await ds.select())!.showOnBoarding, isFalse);
    await ds.save(null);
    expect(await ds.select(), isNull);

    SharedPreferences.setMockInitialValues({'BOOT_DATA': '{quebrado'});
    expect(await BootDataSourceImpl().select(), isNull);
  });

  test('BootDataRepositoryImpl', () async {
    final repo = BootDataRepositoryImpl(dataSource: BootDataSourceImpl());
    expect((await repo.select()).fold((_) => null, (d) => d), isNull);
    final saved = await repo.save(BootData()..showOnBoarding = true);
    expect(saved.fold((_) => null, (d) => d!.showOnBoarding), isTrue);
    expect((await repo.select()).fold((_) => null, (d) => d!.showOnBoarding), isTrue);
    expect((await repo.save(null)).fold((_) => null, (d) => d), isNull);

    final bad = BootDataRepositoryImpl(dataSource: _ThrowingDataSource());
    expect((await bad.select()).fold((f) => f, (_) => null), isA<UnknownFailure>());
    expect((await bad.save(null)).fold((f) => f, (_) => null), isA<UnknownFailure>());
  });

  test('GetBootDataImpl usa o padrão quando não há dado', () async {
    final repo = BootDataRepositoryImpl(dataSource: BootDataSourceImpl());
    final useCase = GetBootDataImpl(repository: repo);
    expect((await useCase()).fold((_) => null, (d) => d.showOnBoarding), isTrue);
    await repo.save(BootData()..showOnBoarding = false);
    expect((await useCase()).fold((_) => null, (d) => d.showOnBoarding), isFalse);
    expect((await GetBootDataImpl(repository: _RejectingRepository())()).fold((_) => null, (d) => d),
        same(GetBootData.defaultData));
    expect((await GetBootDataImpl(repository: _ThrowingRepository())()).fold((f) => f, (_) => null),
        isA<UnknownFailure>());
  });

  test('SetBootDataImpl', () async {
    final repo = BootDataRepositoryImpl(dataSource: BootDataSourceImpl());
    final result = await SetBootDataImpl(repository: repo)(BootData()..showOnBoarding = true);
    expect(result.fold((_) => null, (d) => d!.showOnBoarding), isTrue);
    expect((await SetBootDataImpl(repository: _ThrowingRepository())(BootData())).fold((f) => f, (_) => null),
        isA<UnknownFailure>());
  });
}
