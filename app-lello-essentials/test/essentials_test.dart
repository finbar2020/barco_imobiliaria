import 'package:essentials/api/api_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should be able to instantiate api mapper from package', () {
    final apiMapper = ApiMapper();

    expect(apiMapper, isA<ApiMapper>());
  });
}
