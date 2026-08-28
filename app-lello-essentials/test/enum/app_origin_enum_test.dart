import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppOriginEnum tem os três perfis', () {
    expect(AppOriginEnum.values,
        [AppOriginEnum.manager, AppOriginEnum.owner, AppOriginEnum.employee]);
    expect(AppOriginEnum.employee.name, 'employee');
  });
}
