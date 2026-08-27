import 'package:flutter/material.dart';

/// Caminhos da `MyPreferencesApi` (sem barra inicial no chopper → baseUrl/).
const unitPersonalDataPath = '/me/preferences/unit-personal-data';
const streetTypesPath = '/me/preferences/street-type-list';

/// `EasyFixApi.getCities` usado pelo formulário de endereço (condomínio c1).
const citiesPath = '/condominiums/c1/easyfix/cities';

const saoPauloCity = {'ibge_code': 3550308, 'name': 'SAO PAULO'};
const campinasCity = {'ibge_code': 3509502, 'name': 'CAMPINAS'};
const rioCity = {'ibge_code': 3304557, 'name': 'RIO DE JANEIRO'};

const streetTypesJson = [
  {'tpLogradouro': 'R', 'nmTpLogradouro': 'Rua', 'dtFlex': ''},
  {'tpLogradouro': 'AV', 'nmTpLogradouro': 'Avenida', 'dtFlex': ''},
];

/// JSON completo de `AccessData` (`UnitContactDataEntity.fromJson` estoura
/// TypeError se `usarEmailContato` faltar, então nunca omita campos).
Map<String, dynamic> accessJson({
  String careName = 'Carlos',
  String careEmail = 'cuidados@lello.com',
  String correspondenceEmail = 'corr@lello.com',
  bool useCondoAddress = false,
  bool printedSlips = true,
  bool emailSlips = false,
  bool printedStatements = false,
  bool emailStatements = true,
  bool printedMinutes = false,
  bool emailMinutes = true,
  bool printedAnnouncements = true,
  bool emailAnnouncements = true,
}) =>
    {
      'idUnidPessoa': 1,
      'idMoradorUnidade': 2,
      'tipoAcesso': 'P',
      'usarEnderecoCondominio': useCondoAddress,
      'dadosPessoais': {'cpf': '12345678901'},
      'dadosUnidade': {'idUnidade': 10, 'referencia': 20, 'nmUnidade': '101'},
      'dadosContatoUnidade': {
        'emailCorrespondencia': correspondenceEmail,
        'emailAosCuidados': careEmail,
        'nomeAosCuidados': careName,
        'usarEmailContato': true,
      },
      'dadosEnderecoUnidade': {
        'cep': '01001-000',
        'tipoLogradouro': 'Rua',
        'nomeLogradouro': 'das Flores',
        'numero': '100',
        'complemento': 'ap 1',
        'nomeCidade': 'São Paulo',
        'bairro': 'Centro',
        'uf': 'SP',
      },
      'dadosPapelZeroUnidade': {
        'boletosImpressos': printedSlips,
        'boletosEmail': emailSlips,
        'demonstrativosImpresso': printedStatements,
        'demonstrativosEmail': emailStatements,
        'atasEditaisImpresso': printedMinutes,
        'atasEditaisEmail': emailMinutes,
        'comunicadosImpressos': printedAnnouncements,
        'comunicadosEmail': emailAnnouncements,
      },
      'dadosEnderecoCondominio': {
        'cep': '02002-000',
        'tipoLogradouro': 'Avenida',
        'nomeLogradouro': 'Paulista',
        'numero': '1000',
        'complemento': 'null',
        'nomeCidade': 'São Paulo',
        'bairro': 'Bela Vista',
        'uf': 'SP',
      },
    };

/// Tela inicial que empurra [route] por cima, para observar os `pop`s.
class LauncherPage extends StatelessWidget {
  const LauncherPage(this.route, {super.key});
  final String route;

  static const launcherKey = Key('launcher');

  @override
  Widget build(BuildContext context) => Scaffold(
        key: launcherKey,
        body: Center(
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, route),
            child: const Text('abrir'),
          ),
        ),
      );
}
