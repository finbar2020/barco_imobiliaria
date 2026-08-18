import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/feature/digital_point/data/data_source/local/digital_point_local_data_source_impl.dart';
import 'package:colaborador/feature/digital_point/data/model/digital_point_model.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/init_sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  initSqfliteForTests();

  late DigitalPointDatabase database;
  late DigitalPointLocalDataSourceImpl dataSource;

  setUp(() async {
    database = DigitalPointDatabase();
    dataSource = DigitalPointLocalDataSourceImpl(
      digitalPointDao: database.digitalPointDao,
      digitalPointLogDao: database.digitalPointLogDao,
    );
    await database.resetDb();
  });

  tearDown(() async {
    await database.close();
  });

  DigitalPointModel _model({int? id, DateTime? date, String uniqueHash = 'h1'}) =>
      DigitalPointModel.fromEntity(
        testPoint(id: id).copyWith(
          date: date ?? DateTime(2026, 1, 10, 8, 5),
          uniqueHash: uniqueHash,
        ),
      );

  group('DigitalPointLocalDataSourceImpl', () {
    test('save persiste e retorna id', () async {
      final saved = await dataSource.save(_model(), 'c1', 'm1');
      expect(saved.id, isNotNull);
      expect(saved.uniqueHash, 'h1');
    });

    test('selectAll lista pontos do condomínio', () async {
      await dataSource.save(_model(), 'c1', 'm1');
      await dataSource.save(
        _model(date: DateTime(2026, 1, 10, 12, 0), uniqueHash: 'h2'),
        'c1',
        'm1',
      );
      final list = await dataSource.selectAll('c1', 'm1');
      expect(list, hasLength(2));
    });

    test('select filtra por status', () async {
      await dataSource.save(_model(), 'c1', 'm1');
      final pending = enumToString(DigitalPointStatusEnum.pending)!;
      final list = await dataSource.select('c1', 'm1', pending);
      expect(list, hasLength(1));
      expect(list.first.status, pending);
    });

    test('selectPendingFromDevice e selectNoAuthList', () async {
      await dataSource.save(_model(), 'c1', 'm1');
      expect(await dataSource.selectPendingFromDevice(), hasLength(1));
      expect(await dataSource.selectNoAuthList(), hasLength(1));
    });

    test('updatePointStatus retorna false sem id', () async {
      expect(
        await dataSource.updatePointStatus(
          id: null,
          newStatusEnum: DigitalPointStatusEnum.sended,
        ),
        isFalse,
      );
    });

    test('updatePointStatus atualiza registro', () async {
      final saved = await dataSource.save(_model(), 'c1', 'm1');
      expect(
        await dataSource.updatePointStatus(
          id: saved.id,
          newStatusEnum: DigitalPointStatusEnum.sended,
        ),
        isTrue,
      );
      final pending = enumToString(DigitalPointStatusEnum.pending)!;
      final sended = enumToString(DigitalPointStatusEnum.sended)!;
      expect(await dataSource.select('c1', 'm1', pending), isEmpty);
      expect(await dataSource.select('c1', 'm1', sended), hasLength(1));
    });

    test('saveDigitalPointLog ignora id nulo', () async {
      dataSource.saveDigitalPointLog(_model(), 'pending');
      expect(await dataSource.selectLogById(1), isEmpty);
    });

    test('saveDigitalPointLog grava histórico', () async {
      final saved = await dataSource.save(_model(), 'c1', 'm1');
      dataSource.saveDigitalPointLog(
        saved.copyWith(status: enumToString(DigitalPointStatusEnum.sended)),
        enumToString(DigitalPointStatusEnum.pending)!,
        description: 'sync',
      );
      final logs = await dataSource.selectLogById(saved.id!);
      expect(logs, hasLength(1));
      expect(logs.first.description, 'sync');
    });
  });
}
