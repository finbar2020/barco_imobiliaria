import 'package:colaborador/core/database/lello_database/lello_database.dart';
import 'package:colaborador/feature/me/data/data_source/local/me_local_data_source_impl.dart';
import 'package:colaborador/feature/me/data/model/condominium_model.dart';
import 'package:colaborador/feature/me/data/model/me_model.dart';
import 'package:colaborador/feature/me/data/model/work_shift_details_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/init_sqflite_ffi.dart';

MeModel _meModel() => MeModel(
      id: 'm1',
      name: 'Ana Silva',
      email: 'ana@lello.com',
      cpf: '12345678901',
      phone: '11999999999',
      condominiums: [
        CondominiumModel(
          id: 'c1',
          name: 'Torre Lello',
          reference: 'R1',
          jobPosition: 'porteiro',
          workShiftDetails: [
            WorkShiftDetailsModel(
              badageNumber: '1',
              entry1: '08:00',
              out1: '12:00',
              entry2: '13:00',
              out2: '17:00',
              isDayOff: false,
              date: DateTime(2026, 1, 10),
              reference: 'R1',
            ),
          ],
        ),
      ],
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  initSqfliteForTests();

  late LelloDatabase database;
  late MeLocalDataSourceImpl dataSource;

  setUp(() async {
    database = LelloDatabase();
    dataSource = MeLocalDataSourceImpl(
      meDao: database.meDao,
      condominiumDao: database.condominiumDao,
      condominiumEmployeeScheduleDao: database.condominiumEmployeeScheduleDao,
    );
    await database.resetDb();
  });

  tearDown(() async {
    await database.close();
  });

  group('MeLocalDataSourceImpl', () {
    test('save e select retornam perfil completo', () async {
      await dataSource.save(_meModel());
      final loaded = await dataSource.select();
      expect(loaded, isNotNull);
      expect(loaded!.name, 'Ana Silva');
      expect(loaded.condominiums, hasLength(1));
      expect(loaded.condominiums.first.reference, 'R1');
      expect(loaded.condominiums.first.workShiftDetails, hasLength(1));
      expect(loaded.condominiums.first.workShiftDetails.first.entry1, '08:00');
    });

    test('select retorna null sem dados', () async {
      expect(await dataSource.select(), isNull);
    });

    test('save null limpa dados', () async {
      await dataSource.save(_meModel());
      await dataSource.save(null);
      expect(await dataSource.select(), isNull);
    });

    test('save múltiplos condomínios', () async {
      final model = MeModel(
        id: 'm1',
        name: 'Ana Silva',
        email: 'ana@lello.com',
        cpf: '12345678901',
        phone: '11999999999',
        condominiums: [
          CondominiumModel(
            id: 'c1',
            name: 'Torre A',
            reference: 'R1',
            jobPosition: 'porteiro',
          ),
          CondominiumModel(
            id: 'c2',
            name: 'Torre B',
            reference: 'R2',
            jobPosition: 'zelador',
            workShiftDetails: [
              WorkShiftDetailsModel(
                badageNumber: '2',
                entry1: '09:00',
                out1: '18:00',
                entry2: '',
                out2: '',
                isDayOff: false,
                date: DateTime(2026, 1, 11),
                reference: 'R2',
              ),
            ],
          ),
        ],
      );
      await dataSource.save(model);
      final loaded = await dataSource.select();
      expect(loaded?.condominiums, hasLength(2));
      expect(loaded?.condominiums.last.name, 'Torre B');
      expect(loaded?.condominiums.last.workShiftDetails, hasLength(1));
    });
  });
}
