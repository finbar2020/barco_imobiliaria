import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/splash/domain/entity/boot_data.dart';
import 'package:lello/feature/splash/domain/repository/boot_data_repository.dart';
import 'package:lello/feature/splash/domain/use_case/get_boot_data/get_boot_data.dart';
import 'package:lello/feature/splash/domain/use_case/get_boot_data/get_boot_data_impl.dart';
import 'package:lello/feature/splash/domain/use_case/set_boot_data/set_boot_data_impl.dart';

class _FakeBootRepo extends Fake implements BootDataRepository {
  BootData? stored = BootData()..showOnBoarding = false;
  bool throwOnSave = false;

  @override
  Future<Try<BootData?>> select() async => Success(stored);

  @override
  Future<Try<BootData?>> save(BootData data) async {
    if (throwOnSave) throw StateError('fail');
    stored = data;
    return Success(data);
  }
}

void main() {
  late _FakeBootRepo repo;

  setUp(() => repo = _FakeBootRepo());

  test('GetBootDataImpl devolve o dado persistido', () async {
    final result = await GetBootDataImpl(repository: repo)();
    expect(result, isA<Success<BootData>>());
    expect((result as Success<BootData>).get().showOnBoarding, isFalse);
  });

  test('GetBootDataImpl usa o default quando o repositório devolve nulo',
      () async {
    repo.stored = null;
    final result = await GetBootDataImpl(repository: repo)();
    expect((result as Success<BootData>).get().showOnBoarding, isTrue);
  });

  test('SetBootDataImpl persiste o boot data', () async {
    final data = BootData()..showOnBoarding = true;
    final result = await SetBootDataImpl(repository: repo)(data);
    expect(result, isA<Success<BootData?>>());
    expect(repo.stored?.showOnBoarding, isTrue);
  });

  test('SetBootDataImpl rejeita quando o repositório lança', () async {
    repo.throwOnSave = true;
    final result = await SetBootDataImpl(repository: repo)(BootData());
    expect(result, isA<Rejection<BootData?>>());
  });
}
