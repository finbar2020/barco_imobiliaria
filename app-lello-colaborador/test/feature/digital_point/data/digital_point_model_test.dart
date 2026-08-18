import 'package:colaborador/feature/digital_point/data/model/digital_point_model.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_type_enum.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fixtures.dart';

void main() {
  test('DigitalPointModel fromEntity, toEntity e copyWith', () {
    final model = DigitalPointModel.fromEntity(testPoint(id: 7));
    expect(model.id, 7);
    expect(model.toEntity().uniqueHash, 'h1');
    expect(model.toEntity().typePoint, DigitalPointTypeEnum.offline);
    expect(model.copyWith(status: 'sended').status, 'sended');
    expect(model.copyWith(id: 8).id, 8);

    final json = DigitalPointModel.fromJson({
      'date': '2026-01-10T08:05:00.000',
      'latitude': '-23.5',
      'longitude': '-46.6',
      'photo_path': 'p.jpg',
      'type_point': 'offline',
      'type_capture': 'manual',
      'status': 'pending',
      'unique_hash': 'h2',
      'tablet_session': true,
    });
    expect(json.toEntity().status, DigitalPointStatusEnum.pending);
    json.toJson();
  });
}
