import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_model.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import 'authentication_support.dart';

void main() {
  late AccessTokenLocalDataSourceImpl dataSource;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    initHiveTemp();
    dataSource = AccessTokenLocalDataSourceImpl();
  });

  test('sem nada salvo devolve nulo', () async {
    expect(await dataSource.select(role: ''), isNull);
    expect(await dataSource.select(role: 'SINDICO'), isNull);
  });

  test('save persiste o token por papel, o último papel e o refresh token',
      () async {
    final model = AccessTokenModel.fromJson(tokenJson());

    final saved = await dataSource.save(model, role: 'SINDICO');

    expect(saved, same(model));
    final box = await Hive.openBox('accessToken');
    final refreshBox = await Hive.openBox('refreshToken');
    expect(box.get(SharedPreferencesKeys.lastRole), 'SINDICO');
    final persisted =
        jsonDecode(box.get('${SharedPreferencesKeys.accessToken}SINDICO'));
    expect(persisted['access_token'], 'jwt-1');
    expect(refreshBox.get(SharedPreferencesKeys.refreshToken), 'refresh-1');
  });

  test('select por papel devolve o token e atualiza o último papel',
      () async {
    await dataSource.save(
        AccessTokenModel.fromJson(tokenJson(accessToken: 'a')),
        role: 'A');
    await dataSource.save(
        AccessTokenModel.fromJson(tokenJson(accessToken: 'b')),
        role: 'B');

    final a = await dataSource.select(role: 'A');
    expect(a!.accessToken, 'a');
    final box = await Hive.openBox('accessToken');
    expect(box.get(SharedPreferencesKeys.lastRole), 'A');

    // Papel vazio usa o último papel.
    final last = await dataSource.select(role: '');
    expect(last!.accessToken, 'a');
  });

  test('token salvo sem refresh recupera o refresh da caixa separada',
      () async {
    await dataSource.save(AccessTokenModel.fromJson(tokenJson()), role: 'R');
    final semRefresh = AccessTokenModel.fromJson(
        tokenJson(accessToken: 'novo', refreshToken: null));

    final saved = await dataSource.save(semRefresh, role: 'R');
    expect(saved!.refreshToken, 'refresh-1');

    final selected = await dataSource.select(role: 'R');
    expect(selected!.accessToken, 'novo');
    expect(selected.refreshToken, 'refresh-1');
  });

  test('sem refresh em lugar nenhum o refresh fica nulo', () async {
    final semRefresh =
        AccessTokenModel.fromJson(tokenJson(refreshToken: ''));

    final saved = await dataSource.save(semRefresh, role: 'R');
    expect(saved!.refreshToken, isNull);

    final selected = await dataSource.select(role: 'R');
    expect(selected!.refreshToken, isNull);
  });

  /// Defeito: `save(null)` chama `box.clear()`/`boxRefresh.clear()` sem
  /// `await`; logo depois do retorno o token ainda pode ser lido — a limpeza
  /// só se completa quando a escrita assíncrona do Hive termina.
  test('save nulo limpa as duas caixas (de forma assíncrona)', () async {
    await dataSource.save(AccessTokenModel.fromJson(tokenJson()), role: 'R');

    final result = await dataSource.save(null, role: '');

    expect(result, isNull);
    // Comportamento atual: imediatamente após o retorno ainda há token.
    expect(await dataSource.select(role: 'R'), isNotNull);

    await Future.delayed(const Duration(milliseconds: 200));
    expect(await dataSource.select(role: 'R'), isNull);
    final refreshBox = await Hive.openBox('refreshToken');
    expect(refreshBox.isEmpty, isTrue);
  });

  test('conteúdo corrompido é ignorado e devolve nulo', () async {
    final box = await Hive.openBox('accessToken');
    await box.put('${SharedPreferencesKeys.accessToken}R', 'não é json');

    expect(await dataSource.select(role: 'R'), isNull);
  });

  test('valor vazio persistido não gera modelo', () async {
    final box = await Hive.openBox('accessToken');
    await box.put('${SharedPreferencesKeys.accessToken}R', '');

    expect(await dataSource.select(role: 'R'), isNull);
  });
}
