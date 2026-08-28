import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/feature/my_preferences/data/data_source/my_preferences_api.dart';
import 'package:morar/feature/my_preferences/data/data_source/my_preferences_data_source.dart';
import 'package:morar/feature/my_preferences/data/data_source/my_preferences_data_source_impl.dart';
import 'package:morar/feature/my_preferences/data/repository/my_preferences_repository_impl.dart';
import 'package:morar/feature/my_preferences/domain/entities/access_data_entity.dart';
import 'package:morar/feature/my_preferences/domain/entities/condo_addess_data_entity.dart';
import 'package:morar/feature/my_preferences/domain/entities/personal_data_entity.dart';
import 'package:morar/feature/my_preferences/domain/entities/street_type_entity.dart';
import 'package:morar/feature/my_preferences/domain/entities/unit_addess_data_entity.dart';
import 'package:morar/feature/my_preferences/domain/entities/unit_contact_data_entity.dart';
import 'package:morar/feature/my_preferences/domain/entities/unit_data_entity.dart';
import 'package:morar/feature/my_preferences/domain/entities/unit_paperless_data_entity.dart';
import 'package:morar/feature/my_preferences/domain/repositories/my_preferences_repository.dart';
import 'package:morar/feature/my_preferences/domain/use_cases/get_street_types/get_street_types_use_case_impl.dart';
import 'package:morar/feature/my_preferences/domain/use_cases/get_unit_personal_data/get_unit_personal_data_use_case_impl.dart';
import 'package:morar/feature/my_preferences/domain/use_cases/update_unit_personal_data/update_unit_personal_data_use_case_impl.dart';
import 'package:morar/feature/my_preferences/model/zero_paper_preference_item_model.dart';

import '../../helpers/pump_app.dart';

class MockApi extends Mock implements MyPreferencesApi {}

Map<String, dynamic> _accessJson({bool withCondo = true}) => {
      'idUnidPessoa': 1,
      'idMoradorUnidade': 2,
      'tipoAcesso': 'P',
      'usarEnderecoCondominio': true,
      'dadosPessoais': {'cpf': '123'},
      'dadosUnidade': {'idUnidade': 10, 'referencia': 20, 'nmUnidade': '101'},
      'dadosContatoUnidade': {
        'emailCorrespondencia': 'c@x',
        'emailAosCuidados': 'a@x',
        'nomeAosCuidados': 'Ana',
        'usarEmailContato': true,
      },
      'dadosEnderecoUnidade': {
        'cep': '01000',
        'tipoLogradouro': 'Rua',
        'nomeLogradouro': 'A',
        'numero': '1',
        'complemento': null,
        'bairro': 'Centro',
        'uf': 'SP',
      },
      'dadosPapelZeroUnidade': {
        'boletosImpressos': true,
        'boletosEmail': false,
        'demonstrativosImpresso': true,
        'demonstrativosEmail': false,
        'atasEditaisImpresso': false,
        'atasEditaisEmail': true,
        'comunicadosImpressos': false,
        'comunicadosEmail': true,
      },
      if (withCondo)
        'dadosEnderecoCondominio': {
          'cep': '02000',
          'tipoLogradouro': 'Av',
          'nomeLogradouro': 'B',
          'numero': '2',
          'complemento': 'c',
          'nomeCidade': 'SP',
          'bairro': '',
          'uf': 'SP',
        },
    };

class _FakeDataSource extends Fake implements MyPreferencesDataSource {
  _FakeDataSource({this.fail = false});
  final bool fail;
  @override
  Future<AccessData> getUnitPersonalData(int unitId) async {
    if (fail) throw Exception('x');
    return AccessData.fromJson(_accessJson());
  }

  @override
  Future<AccessData> updateUnitPersonalData(AccessData accessData) async {
    if (fail) throw Exception('x');
    return accessData;
  }

  @override
  Future<List<StreetTypeEntity>> getStreetTypesList() async {
    if (fail) throw Exception('x');
    return [StreetTypeEntity(type: 'R', name: 'Rua', dtFlex: 'd')];
  }
}

class _FakeRepository extends Fake implements MyPreferencesRepository {
  final calls = <String>[];
  @override
  Future<Try<AccessData>> getUnitPersonalData(int unitId) async {
    calls.add('get:$unitId');
    return Success(AccessData.fromJson(_accessJson()));
  }

  @override
  Future<Try<AccessData>> updateUnitPersonalData(AccessData accessData) async {
    calls.add('update:${accessData.personUnitId}');
    return Success(accessData);
  }

  @override
  Future<Try<List<StreetTypeEntity>>> getStreetTypesList() async {
    calls.add('street');
    return Success(const []);
  }
}

void main() {
  test('AccessData fromJson/toJson/copyWith', () {
    final data = AccessData.fromJson(_accessJson());
    expect(data.personUnitId, 1);
    expect(data.residentUnitId, 2);
    expect(data.useUnitAddress, isTrue);
    expect(data.propagateOtherUnits, isFalse);
    expect(data.personalData!.cpf, '123');
    expect(data.unitData.unitName, '101');
    expect(data.unitContactData.careName, 'Ana');
    expect(data.unitAddressData.complement, '');
    expect(data.unitAddressData.cityName, '');
    expect(data.condoAddressData!.cityName, 'SP');
    expect(data.unitPaperlessData.emailMinutes, isTrue);

    final json = data.toJson();
    expect(json['idUnidPessoa'], 1);
    expect(json['dadosEnderecoCondominio']['cep'], '02000');
    expect(json['dadosPapelZeroUnidade']['boletosImpressos'], isTrue);

    final copy = data.copyWith(accessType: 'X', useCondoAddress: false, residentUnitId: 9);
    expect(copy.accessType, 'X');
    expect(copy.useUnitAddress, isFalse);
    expect(copy.residentUnitId, 9);
    expect(copy.unitData.unitId, 10);

    final semCondo = AccessData.fromJson(_accessJson(withCondo: false)
      ..['dadosPessoais'] = null
      ..['idMoradorUnidade'] = null);
    expect(semCondo.condoAddressData, isNull);
    expect(semCondo.personalData!.cpf, '');
    expect(semCondo.residentUnitId, 0);
  });

  test('entidades auxiliares', () {
    final address = AddressDataEntity.fromJson({
      'cep': '1', 'tipoLogradouro': 'Rua', 'nomeLogradouro': 'A', 'numero': '2',
      'complemento': 'c', 'nomeCidade': 'SP', 'bairro': 'Centro', 'uf': 'SP',
    });
    expect(address.toString(), '1, Rua A, 2, Centro, SP, SP');
    expect(address.copyWith(number: '3').number, '3');
    expect(address.copyWith().neighborhood, 'Centro');
    expect(address.toJson()['bairro'], 'Centro');

    final condo = CondoAddressDataEntity.fromJson({
      'cep': '1', 'tipoLogradouro': 'Av', 'nomeLogradouro': 'B', 'numero': '2',
      'complemento': 'c', 'uf': 'RJ',
    });
    expect(condo.toString(), '1, Av B, 2, , RJ');
    expect(condo.copyWith(cityName: 'Rio').toJson()['nomeCidade'], 'Rio');

    final personal = PersonalDataEntity(cpf: '1');
    expect(personal.copyWith(cpf: '2').toJson(), {'cpf': '2'});
    expect(PersonalDataEntity.fromJson({'cpf': '3'}).cpf, '3');

    final street = StreetTypeEntity(type: 'R', name: 'Rua', dtFlex: 'd');
    expect(StreetTypeEntity.fromMap(street.toMap()).name, 'Rua');
    expect(street.copyWith(name: 'Av').name, 'Av');

    final contact = UnitContactDataEntity.fromJson({'usarEmailContato': false});
    expect(contact.correspondenceEmail, '');
    // Corrigido: sem `usarEmailContato` o fallback é `false`, e o parse de um
    // json vazio não estoura mais TypeError.
    final empty = UnitContactDataEntity.fromJson({});
    expect(empty.useContactEmail, isFalse);
    expect(empty.correspondenceEmail, '');
    expect(contact.copyWith(careName: 'x').toJson()['nomeAosCuidados'], 'x');

    final unit = UnitDataEntity(unitId: 1, reference: 2, unitName: 'u');
    expect(UnitDataEntity.fromJson(unit.toJson()).reference, 2);
    expect(unit.copyWith(unitName: 'v').unitName, 'v');

    final paperless = UnitPaperlessDataEntity.fromJson(_accessJson()['dadosPapelZeroUnidade']);
    expect(paperless.copyWith(printedSlips: false).toJson()['boletosImpressos'], isFalse);
  });

  testWidgets('ZeroPaperItemModel', (tester) async {
    final item = ZeroPaperItemModel(
      type: ZeroPaperPreferenceTypeEnum.bankSlip,
      choice: ZeroPaperPreferenceChoiceEnum.email,
    );
    expect(item.copyWith(choice: ZeroPaperPreferenceChoiceEnum.both).choice,
        ZeroPaperPreferenceChoiceEnum.both);
    expect(item.props, [ZeroPaperPreferenceTypeEnum.bankSlip, ZeroPaperPreferenceChoiceEnum.email]);
    await pumpApp(tester, const Text('x'), localized: true);
    final context = tester.element(find.text('x'));
    expect(ZeroPaperPreferenceTypeEnum.bankSlip.getLabel(context), 'preferences_zero_paper_slips');
    expect(ZeroPaperPreferenceTypeEnum.minutesAndNotices.getLabel(context), 'preferences_zero_paper_minutes');
    expect(ZeroPaperPreferenceTypeEnum.statements.getLabel(context), 'preferences_zero_paper_statements');
    expect(ZeroPaperPreferenceTypeEnum.announcements.getLabel(context), 'preferences_zero_paper_announcements');
  });

  test('use cases', () async {
    final repo = _FakeRepository();
    final get = GetUnitPersonalDataUseCaseImpl(repo);
    expect((await get(-1)).fold((f) => f, (_) => null), isA<InvalidParamFailure>());
    expect((await get(5)).fold((_) => null, (d) => d.personUnitId), 1);

    final update = UpdateUnitPersonalDataUseCaseImpl(repo);
    final data = AccessData.fromJson(_accessJson());
    expect((await update(data.copyWith(personalData: PersonalDataEntity(cpf: ''))))
        .fold((f) => f, (_) => null), isA<InvalidParamFailure>());
    expect((await update(data)).fold((_) => null, (d) => d.personUnitId), 1);

    await GetStreetTypesUseCaseImpl(repo)();
    expect(repo.calls, ['get:5', 'update:1', 'street']);
  });

  test('repository', () async {
    final repo = MyPreferencesRepositoryImpl(_FakeDataSource());
    expect((await repo.getUnitPersonalData(1)).fold((_) => null, (d) => d.accessType), 'P');
    expect((await repo.updateUnitPersonalData(AccessData.fromJson(_accessJson()))).fold((_) => null, (d) => d.personUnitId), 1);
    expect((await repo.getStreetTypesList()).fold((_) => null, (l) => l.single.type), 'R');

    final bad = MyPreferencesRepositoryImpl(_FakeDataSource(fail: true));
    expect((await bad.getUnitPersonalData(1)).fold((f) => f, (_) => null), isA<UnknownFailure>());
    expect((await bad.updateUnitPersonalData(AccessData.fromJson(_accessJson()))).fold((f) => f, (_) => null), isA<UnknownFailure>());
    expect((await bad.getStreetTypesList()).fold((f) => f, (_) => null), isA<UnknownFailure>());
  });

  test('data source', () async {
    final api = MockApi();
    registerFallbackValue(AccessData.fromJson(_accessJson()));
    final ds = MyPreferencesDataSourceImpl(api);
    when(() => api.getPreferencesZeroPaper(1)).thenAnswer(
      (_) async => Response<dynamic>(http.Response(jsonEncode(_accessJson()), 200), null),
    );
    when(() => api.putPreferencesZeroPaper(any())).thenAnswer(
      (_) async => Response<dynamic>(http.Response(jsonEncode(_accessJson()), 200), null),
    );
    when(() => api.getStreetTypesList()).thenAnswer(
      (_) async => Response<dynamic>(
        http.Response(jsonEncode([{'tpLogradouro': 'R', 'nmTpLogradouro': 'Rua', 'dtFlex': 'd'}]), 200),
        null,
      ),
    );
    expect((await ds.getUnitPersonalData(1)).unitData.unitName, '101');
    expect((await ds.updateUnitPersonalData(AccessData.fromJson(_accessJson()))).accessType, 'P');
    expect((await ds.getStreetTypesList()).single.name, 'Rua');
  });
}
