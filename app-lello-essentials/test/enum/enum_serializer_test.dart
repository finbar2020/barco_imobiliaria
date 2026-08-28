import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/enum/enum_serializer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('enumToString devolve só o nome do valor', () {
    expect(enumToString(AppOriginEnum.manager), 'manager');
  });

  test('enumToString com nulo devolve nulo', () {
    expect(enumToString<AppOriginEnum?>(null), isNull);
  });

  test('stringToEnum encontra o valor pelo nome', () {
    expect(stringToEnum(AppOriginEnum.values, 'owner'), AppOriginEnum.owner);
  });

  test('stringToEnum devolve nulo quando não encontra', () {
    expect(stringToEnum(AppOriginEnum.values, 'nada'), isNull);
    expect(stringToEnum(AppOriginEnum.values, null), isNull);
  });
}
