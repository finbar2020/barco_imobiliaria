import 'package:essentials/base/api_response.dart';
import 'package:essentials/base/api_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromJson/toJson com error_code em snake_case', () {
    final json = {
      'success': true,
      'message': 'ok',
      'data': {'a': 1},
      'error_code': 'E1',
    };
    final model = ApiResponseModel.fromJson(json);
    expect(model.success, isTrue);
    expect(model.message, 'ok');
    expect(model.data, {'a': 1});
    expect(model.errorCode, 'E1');
    expect(model.toJson(), json);
  });

  test('fromJson usa valores padrão para campos ausentes', () {
    final model = ApiResponseModel.fromJson({});
    expect(model.success, isFalse);
    expect(model.message, '');
    expect(model.errorCode, '');
    expect(model.data, isNull);
  });

  test('fromEntity converte nulos em string vazia', () {
    final model = ApiResponseModel.fromEntity(ApiResponse(success: true, data: 2));
    expect(model.success, isTrue);
    expect(model.message, '');
    expect(model.errorCode, '');
    expect(model.data, 2);
    final completo = ApiResponseModel.fromEntity(
        ApiResponse(message: 'm', errorCode: 'E'));
    expect(completo.message, 'm');
    expect(completo.errorCode, 'E');
  });

  test('toEntity copia os campos', () {
    final entity = ApiResponseModel(
            success: true, message: 'm', data: 3, errorCode: 'E')
        .toEntity();
    expect(entity.success, isTrue);
    expect(entity.message, 'm');
    expect(entity.data, 3);
    expect(entity.errorCode, 'E');
  });
}
