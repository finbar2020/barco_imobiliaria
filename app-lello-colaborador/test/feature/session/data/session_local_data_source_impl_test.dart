import 'package:colaborador/feature/me/data/model/condominium_model.dart';
import 'package:colaborador/feature/me/data/model/me_model.dart';
import 'package:colaborador/feature/session/data/data_source/session_local_data_source_impl.dart';
import 'package:colaborador/feature/session/data/model/session_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

SessionModel _sessionModel() => SessionModel(
      meModel: MeModel(
        id: 'm1',
        name: 'Ana Silva',
        email: 'ana@lello.com',
        cpf: '12345678901',
      ),
      condominiumModel: CondominiumModel(
        id: 'c1',
        name: 'Torre Lello',
        reference: 'R1',
        jobPosition: 'porteiro',
      ),
    );

void main() {
  group('SessionLocalDataSourceImpl', () {
    test('save e select persistem sessão', () async {
      SharedPreferences.setMockInitialValues({});
      final dataSource = SessionLocalDataSourceImpl();

      await dataSource.save(_sessionModel());
      final loaded = await dataSource.select();

      expect(loaded, isNotNull);
      expect(loaded!.meModel?.name, 'Ana Silva');
      expect(loaded.condominiumModel?.reference, 'R1');
    });

    test('select retorna null sem dados', () async {
      SharedPreferences.setMockInitialValues({});
      final dataSource = SessionLocalDataSourceImpl();
      expect(await dataSource.select(), isNull);
    });

    test('save null remove sessão', () async {
      SharedPreferences.setMockInitialValues({});
      final dataSource = SessionLocalDataSourceImpl();

      await dataSource.save(_sessionModel());
      await dataSource.save(null);

      expect(await dataSource.select(), isNull);
    });

    test('save substitui sessão anterior', () async {
      SharedPreferences.setMockInitialValues({});
      final dataSource = SessionLocalDataSourceImpl();

      await dataSource.save(_sessionModel());
      await dataSource.save(
        SessionModel(
          meModel: MeModel(id: 'm2', name: 'Bruno'),
          condominiumModel: CondominiumModel(
            id: 'c2',
            name: 'Torre B',
            reference: 'R2',
          ),
        ),
      );

      final loaded = await dataSource.select();
      expect(loaded?.meModel?.name, 'Bruno');
      expect(loaded?.condominiumModel?.reference, 'R2');
    });
  });
}
