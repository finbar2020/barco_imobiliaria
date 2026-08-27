import 'package:essentials/configs/custom_firebase_remote_config_link.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('construtor guarda link, webview e nome', () {
    final link = FirebaseRemoteConfigLink(
        link: 'https://lello.com.br', webview: true, name: 'site');
    expect(link.link, 'https://lello.com.br');
    expect(link.webview, isTrue);
    expect(link.name, 'site');
  });

  test('fromJson lê os três campos', () {
    final link = FirebaseRemoteConfigLink.fromJson({
      'link': 'https://wa.me/55',
      'webview': false,
      'name': 'whatsapp',
    });
    expect(link.link, 'https://wa.me/55');
    expect(link.webview, isFalse);
    expect(link.name, 'whatsapp');
  });

  test('fromJson exige os campos com os tipos corretos', () {
    expect(
      () => FirebaseRemoteConfigLink.fromJson({'link': 'x', 'webview': true}),
      throwsA(isA<TypeError>()),
    );
    expect(
      () => FirebaseRemoteConfigLink.fromJson(
          {'link': 'x', 'webview': 'true', 'name': 'n'}),
      throwsA(isA<TypeError>()),
    );
  });

  test('campos são mutáveis', () {
    final link =
        FirebaseRemoteConfigLink(link: 'a', webview: false, name: 'b')
          ..link = 'c'
          ..webview = true
          ..name = 'd';
    expect(link.link, 'c');
    expect(link.webview, isTrue);
    expect(link.name, 'd');
  });
}
