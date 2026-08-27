import 'package:chopper/chopper.dart';
import 'package:essentials/network/api_failure.dart';
import 'package:essentials/network/api_failure_converter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  final converter = ApiFailureConverter();

  test('corpo JSON vira ApiFailure em bodyError', () async {
    const corpo = '{"status":404,"message":"nao achou"}';
    final response = Response<dynamic>(http.Response(corpo, 404), corpo);
    final convertida = await converter.convertError<dynamic, dynamic>(response);
    expect(convertida.error, isA<ApiFailure>());
    final erro = convertida.error as ApiFailure;
    expect(erro.status, 404);
    expect(erro.message, 'nao achou');
    expect(convertida.statusCode, 404);
  });

  test('corpo que não é JSON mantém a resposta original', () async {
    final response = Response<dynamic>(
        http.Response('<html>erro</html>', 500), '<html>erro</html>');
    final convertida = await converter.convertError<dynamic, dynamic>(response);
    expect(identical(convertida, response), isTrue);
    expect(convertida.error, isNull);
  });

  test('JSON que não é objeto mantém a resposta original', () async {
    final response = Response<dynamic>(http.Response('[1,2]', 500), '[1,2]');
    final convertida = await converter.convertError<dynamic, dynamic>(response);
    expect(identical(convertida, response), isTrue);
  });

  test('corpo nulo mantém a resposta original', () async {
    final response = Response<dynamic>(http.Response('{}', 500), null);
    final convertida = await converter.convertError<dynamic, dynamic>(response);
    expect(identical(convertida, response), isTrue);
  });

  test('continua sendo um JsonConverter para o corpo de sucesso', () {
    expect(converter, isA<JsonConverter>());
  });
}
