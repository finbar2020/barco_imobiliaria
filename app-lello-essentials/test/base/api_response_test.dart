import 'package:essentials/base/api_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('valores padrão', () {
    final r = ApiResponse();
    expect(r.success, isFalse);
    expect(r.message, isNull);
    expect(r.data, isNull);
    expect(r.errorCode, isNull);
  });

  test('guarda os campos', () {
    final r = ApiResponse(success: true, message: 'm', data: 1, errorCode: 'E');
    expect(r.success, isTrue);
    expect(r.message, 'm');
    expect(r.data, 1);
    expect(r.errorCode, 'E');
  });
}
