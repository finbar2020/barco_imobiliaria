import 'package:essentials/methods/launch_url/urls.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('links fixos', () {
    expect(UrlsUri.lgpd().toString(),
        'https://www.lellocondominios.com.br/lgpd-e-lello-condominios');
    expect(UrlsUri.privacyPolicy().toString(),
        'https://www.lello.com.br/politica-de-privacidade/lello-condominios');
    expect(UrlsUri.vamosParcelar().toString(),
        'https://credenciado.vamosparcelar.com.br/lello-condominios');
    expect(UrlsUri.resolvaFacilPreferenciasEditar().toString(),
        'https://www.lellocondominios.com.br/resolvafacil/preferencias/editar.xhtml');
  });

  test('pontoDigital usa a url informada ou o padrão', () {
    expect(UrlsUri.pontoDigital(url: '').host,
        'www.applelloparacolaboradores.com.br');
    expect(UrlsUri.pontoDigital(url: 'ponto.lello').toString(),
        'https://ponto.lello/');
  });

  test('indiqueGanhe, condoLivre e cursos usam url/path informados ou padrão',
      () {
    expect(UrlsUri.indiqueGanhe(url: '', path: '').toString(),
        'https://www.indicalello.com.br/souzelador');
    expect(UrlsUri.indiqueGanhe(url: 'i.com', path: 'p').toString(),
        'https://i.com/p');
    expect(UrlsUri.condoLivre(url: '', path: '').toString(),
        'https://cred.condolivre.com.br/home');
    expect(UrlsUri.condoLivre(url: 'c.com', path: 'x').toString(),
        'https://c.com/x');
    expect(UrlsUri.cursos(url: '', path: '').toString(),
        'https://www.cursos.sindiconet.com.br/zeladoria-na-pratica-e-manutencao-predial');
    expect(UrlsUri.cursos(url: 'k.com', path: 'y').toString(),
        'https://k.com/y');
  });

  test('whatsApp monta wa.me com texto', () {
    final uri = UrlsUri.whatsApp('5511999998888', message: 'olá');
    expect(uri.host, 'wa.me');
    expect(uri.path, '/5511999998888/');
    expect(uri.queryParameters['text'], 'olá');
  });

  /// Corrigido: sem mensagem (nula ou vazia) o parâmetro `text` é omitido em
  /// vez de gerar `https://wa.me/55/?text`.
  test('whatsApp sem mensagem omite o parâmetro text', () {
    final uri = UrlsUri.whatsApp('55');
    expect(uri.hasQuery, isFalse);
    expect(uri.queryParameters.containsKey('text'), isFalse);
    expect(uri.toString(), 'https://wa.me/55/');
    expect(UrlsUri.whatsApp('55', message: '').hasQuery, isFalse);
  });

  test('tel e sms', () {
    expect(UrlsUri.tel('11999998888').toString(), 'tel://11999998888');
    expect(UrlsUri.sms('11999998888').scheme, 'sms');
    expect(UrlsUri.tel(null).host, '');
  });

  test('UrlsString existe', () {
    expect(UrlsString(), isA<UrlsString>());
  });
}
