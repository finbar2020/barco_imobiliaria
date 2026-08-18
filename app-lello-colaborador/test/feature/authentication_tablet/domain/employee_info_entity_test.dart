import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:flutter_test/flutter_test.dart';

EmployeeInfo _employee({
  String cpf = '12345678901',
  String name = 'JOÃO SILVA',
  String jobPosition = 'PORTEIRO NOTURNO',
  String pictureHash = 'abc123',
}) =>
    EmployeeInfo(
      numCra: '1',
      numCad: '2',
      cpf: cpf,
      name: name,
      jobPosition: jobPosition,
      idLogin: 'l1',
      pictureHash: pictureHash,
      registered: true,
      statusEnum: DigitalTimesheetStatusEnum.approved,
    );

void main() {
  group('EmployeeInfo', () {
    test('nameFormatted capitaliza palavras', () {
      expect(_employee().nameFormatted, 'João Silva');
    });

    test('jobPositionFormatted capitaliza cargo', () {
      expect(_employee().jobPositionFormatted, 'Porteiro Noturno');
    });

    test('cpfFormatted mascara documento', () {
      expect(_employee().cpfFormatted, contains('.'));
      expect(_employee().cpfFormatted, contains('-'));
    });

    test('cpf curto usa fallback de capitalização', () {
      expect(_employee(cpf: 'a').cpfFormatted, 'A');
    });

    test('pictureLink monta url quando há hash', () {
      expect(
        _employee().pictureLink,
        '/registration/employee/picture/file/abc123',
      );
    });

    test('pictureLink null sem hash', () {
      expect(_employee(pictureHash: '').pictureLink, isNull);
    });
  });
}
