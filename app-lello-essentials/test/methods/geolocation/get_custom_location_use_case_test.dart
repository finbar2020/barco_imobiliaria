import 'package:essentials/functional/failure.dart';
import 'package:essentials/functional/try.dart';
import 'package:essentials/methods/geolocation/get_custom_location_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

import '../../helpers/firebase_mocks.dart';
import 'fake_geolocator.dart';

void main() {
  late FakeGeolocator geo;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    geo = instalaGeolocatorFalso();
    fakeAnalytics.reset();
  });

  test('online devolve a posição de alta precisão e loga o sucesso', () async {
    final pos = posicao(accuracy: 7);
    geo.porPrecisao[LocationAccuracy.high] = pos;
    final useCase = GetCustomPositionUseCase(isOnline: true);
    final r = await useCase.call(const ParamsGetCustomPositionUseCase());
    expect(r, Success<Position>(pos));
    expect(useCase.accuracyLevel, 3);
    expect(geo.pedidas, [LocationAccuracy.high]);
    expect(geo.pedidosUltima, 0);
    expect(fakeAnalytics.eventNames, ['get_location_succ']);
    final params = fakeAnalytics.events['get_location_succ']!;
    expect(params['accuracy'], '7.0');
    expect(params['accuracy_requested'], '3');
    expect(params['elapsed_ms'], isNotEmpty);
  });

  /// Corrigido: se a posição veio do cache é decidido antes de atualizar
  /// `_lastPosition`, então uma posição recém-obtida loga `cache: false`.
  test('posição recém-obtida loga cache false', () async {
    geo.porPrecisao[LocationAccuracy.high] = posicao();
    await GetCustomPositionUseCase(isOnline: true)
        .call(const ParamsGetCustomPositionUseCase());
    expect(fakeAnalytics.events['get_location_succ']!['cache'], 'false');
  });

  test('posição igual à já guardada loga cache true', () async {
    final pos = posicao();
    geo.porPrecisao[LocationAccuracy.high] = pos;
    final useCase = GetCustomPositionUseCase(isOnline: true);
    await useCase.call(const ParamsGetCustomPositionUseCase(debouncerTime: 0));
    fakeAnalytics.reset();
    await useCase.call(const ParamsGetCustomPositionUseCase(debouncerTime: 0));
    expect(fakeAnalytics.events['get_location_succ']!['cache'], 'true');
  });

  test('logAnalytics sem fromCache compara com a posição em memória', () async {
    final useCase = GetCustomPositionUseCase(isOnline: true);
    useCase.logAnalytics(posicao());
    expect(fakeAnalytics.events['get_location_succ']!['cache'], 'false');
  });

  test('tenta as precisões em sequência até uma responder', () async {
    final pos = posicao();
    geo.porPrecisao[LocationAccuracy.lowest] = pos;
    final useCase = GetCustomPositionUseCase(isOnline: true);
    final r = await useCase.call(const ParamsGetCustomPositionUseCase());
    expect(r, Success<Position>(pos));
    expect(useCase.accuracyLevel, 0);
    expect(geo.pedidas,
        [LocationAccuracy.high, LocationAccuracy.medium, LocationAccuracy.lowest]);
  });

  test('precisão média define accuracyLevel 2', () async {
    geo.porPrecisao[LocationAccuracy.medium] = posicao();
    final useCase = GetCustomPositionUseCase(isOnline: true);
    await useCase.call(const ParamsGetCustomPositionUseCase());
    expect(useCase.accuracyLevel, 2);
  });

  test('sem posição atual usa a última conhecida recente', () async {
    final pos = posicao(quando: DateTime.now().subtract(const Duration(minutes: 1)));
    geo.ultimaConhecida = pos;
    final useCase = GetCustomPositionUseCase(isOnline: true);
    final r = await useCase.call(const ParamsGetCustomPositionUseCase());
    expect(r, Success<Position>(pos));
    expect(useCase.accuracyLevel, 9);
    expect(geo.pedidosUltima, 1);
  });

  test('última conhecida antiga é descartada e loga erro', () async {
    geo.ultimaConhecida =
        posicao(quando: DateTime.now().subtract(const Duration(minutes: 5)));
    final r = await GetCustomPositionUseCase(isOnline: true)
        .call(const ParamsGetCustomPositionUseCase());
    expect(r, isA<Rejection<Position>>());
    expect((r as Rejection).get(), isA<UnknownFailure>());
    expect(fakeAnalytics.eventNames, ['get_location_err']);
  });

  test('erro ao ler a última conhecida devolve Rejection', () async {
    geo.ultimaConhecidaFalha = true;
    final r = await GetCustomPositionUseCase(isOnline: true)
        .call(const ParamsGetCustomPositionUseCase());
    expect(r, isA<Rejection<Position>>());
  });

  test('sem última conhecida devolve Rejection', () async {
    final r = await GetCustomPositionUseCase(isOnline: true)
        .call(const ParamsGetCustomPositionUseCase());
    expect(r, isA<Rejection<Position>>());
  });

  test('offline pede só a precisão mais baixa', () async {
    final pos = posicao();
    geo.porPrecisao[LocationAccuracy.lowest] = pos;
    final useCase = GetCustomPositionUseCase(isOnline: false);
    final r = await useCase.call(const ParamsGetCustomPositionUseCase());
    expect(r, Success<Position>(pos));
    expect(useCase.accuracyLevel, 3);
    expect(geo.pedidas, [LocationAccuracy.lowest]);
  });

  test('offline com erro cai na última conhecida', () async {
    final pos = posicao();
    geo.ultimaConhecida = pos;
    final r = await GetCustomPositionUseCase(isOnline: false)
        .call(const ParamsGetCustomPositionUseCase());
    expect(r, Success<Position>(pos));
    expect(geo.pedidas, [LocationAccuracy.lowest]);
  });

  test('segunda chamada dentro do debounce usa a memória', () async {
    final pos = posicao();
    geo.porPrecisao[LocationAccuracy.high] = pos;
    final useCase = GetCustomPositionUseCase(isOnline: true);
    await useCase.call(const ParamsGetCustomPositionUseCase(debouncerTime: 30));
    fakeAnalytics.reset();
    final r = await useCase.call(const ParamsGetCustomPositionUseCase(debouncerTime: 30));
    expect(r, Success<Position>(pos));
    expect(geo.pedidas, hasLength(1));
    expect(fakeAnalytics.eventNames, isEmpty);
  });

  test('debounce zerado busca de novo', () async {
    geo.porPrecisao[LocationAccuracy.high] = posicao();
    final useCase = GetCustomPositionUseCase(isOnline: true);
    await useCase.call(const ParamsGetCustomPositionUseCase(debouncerTime: 0));
    await useCase.call(const ParamsGetCustomPositionUseCase(debouncerTime: 0));
    expect(geo.pedidas, hasLength(2));
  });

  test('ParamsGetCustomPositionUseCase tem debounce padrão de 30 s', () {
    expect(const ParamsGetCustomPositionUseCase().debouncerTime, 30);
  });
}
