import 'package:chopper/chopper.dart';
import 'package:essentials/api/api_mapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

Response<dynamic> _resposta(int status, String body, {Object? error}) =>
    Response<dynamic>(http.Response(body, status), body, error: error);

void main() {
  test('mapList converte cada item do JSON', () {
    final lista = ApiMapper.mapList<int>(
        _resposta(200, '[{"v":1},{"v":2}]'), (json) => json['v'] as int);
    expect(lista, [1, 2]);
  });

  test('mapList lança o erro da resposta quando falha', () {
    expect(
        () => ApiMapper.mapList<int>(
            _resposta(500, 'x', error: 'erro'), (json) => 1),
        throwsA('erro'));
  });

  test('mapList sem erro lança string vazia', () {
    expect(() => ApiMapper.mapList<int>(_resposta(404, ''), (json) => 1),
        throwsA(''));
  });

  test('map converte o objeto', () {
    expect(ApiMapper.map<String>(_resposta(201, '{"n":"a"}'), (json) => json['n']),
        'a');
  });

  test('map lança o erro da resposta quando falha', () {
    expect(() => ApiMapper.map<int>(_resposta(400, '', error: 'e'), (json) => 1),
        throwsA('e'));
    expect(() => ApiMapper.map<int>(_resposta(400, ''), (json) => 1),
        throwsA(''));
  });
}
