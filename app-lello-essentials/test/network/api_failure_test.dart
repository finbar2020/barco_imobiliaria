import 'package:essentials/network/api_failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final json = {
    'status': 400,
    'title': 't',
    'detail': 'd',
    'type': 'ty',
    'instance': 'i',
    'failure': 'f',
    'message': 'm',
  };

  test('fromJson/toJson round trip', () {
    final f = ApiFailure.fromJson(json);
    expect(f.status, 400);
    expect(f.title, 't');
    expect(f.detail, 'd');
    expect(f.type, 'ty');
    expect(f.instance, 'i');
    expect(f.failure, 'f');
    expect(f.message, 'm');
    expect(f.toJson(), json);
  });

  test('campos ausentes ficam nulos', () {
    final f = ApiFailure.fromJson({});
    expect(f.status, isNull);
    expect(f.message, isNull);
    expect(ApiFailure().toJson()['status'], isNull);
  });

  test('toString descreve os campos', () {
    expect(ApiFailure.fromJson(json).toString(),
        'ApiFailure(status: 400, title: t, detail: d, type: ty, instance: i, failure: f, message: m)');
  });
}
