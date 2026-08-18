import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_capture_type_enum.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_type_enum.dart';
import 'package:flutter_test/flutter_test.dart';

DigitalPointEntity _point({String photoPath = 'photo.jpg'}) => DigitalPointEntity(
      date: DateTime(2026, 1, 10, 8, 5),
      latitude: '-23.5',
      longitude: '-46.6',
      typePoint: DigitalPointTypeEnum.offline,
      photoPath: photoPath,
      status: DigitalPointStatusEnum.pending,
      captureType: DigitalPointCaptureTypeEnum.manual,
      uniqueHash: 'h1',
      tabletSession: false,
    );

void main() {
  test('isValid exige photoPath', () {
    expect(_point().isValid, isTrue);
    expect(_point(photoPath: '').isValid, isFalse);
  });

  test('formata data e hora fixas', () {
    expect(_point().dateFormatted, '10/01/2026');
    expect(_point().timeFormatted, '08:05');
  });

  test('copyWith troca status', () {
    final copy = _point().copyWith(status: DigitalPointStatusEnum.sended);
    expect(copy.status, DigitalPointStatusEnum.sended);
    expect(copy.photoPath, 'photo.jpg');
  });
}
