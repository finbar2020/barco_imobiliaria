import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// ViaCEP falso.
///
/// `ViaCepSearchCep` (search_cep) cria o seu próprio `http.Client()`. Dentro
/// da zona do `mockNetworkImagesFor` (usada pelo `pumpPage`) esse client
/// cairia no `MockHttpClient` do mockito, que não implementa `openUrl` e
/// estoura `TypeError`. `http.runWithClient` registra um valor de zona que é
/// herdado pelas zonas filhas, então o `http.Client()` do ViaCEP passa a ser
/// o [MockClient] daqui — inclusive nas continuações assíncronas dos blocs.
///
/// Respostas por CEP (só dígitos) em [ceps]; CEP desconhecido responde
/// `{"erro": true}` (→ `InvalidCepError`). [status] != 200 simula falha.
class FakeViaCep {
  FakeViaCep({Map<String, Map<String, dynamic>>? ceps, this.status = 200})
      : ceps = ceps ?? {'01001000': saoPaulo('01001-000')};

  final Map<String, Map<String, dynamic>> ceps;
  int status;
  final requests = <String>[];

  static Map<String, dynamic> saoPaulo(String cep, {String? localidade}) => {
        'cep': cep,
        'logradouro': 'Praça da Sé',
        'complemento': 'lado ímpar',
        'bairro': 'Sé',
        'localidade': localidade ?? 'São Paulo',
        'uf': 'SP',
        'ibge': '3550308',
        'gia': '1004',
        'ddd': '11',
        'siafi': '7107',
      };

  http.Client get client => MockClient((request) async {
        requests.add(request.url.toString());
        if (status != 200) return http.Response('', status);
        // https://viacep.com.br/ws/<cep>/json/
        final segments = request.url.pathSegments;
        final cep = segments.length > 1 ? segments[1] : '';
        final body = ceps[cep] ?? const {'erro': true};
        return http.Response(jsonEncode(body), 200, headers: const {
          'content-type': 'application/json; charset=utf-8',
        });
      });

  /// Executa [body] numa zona em que `http.Client()` devolve [client].
  R run<R>(R Function() body) => http.runWithClient(body, () => client);
}
