import 'package:essentials/essentials.dart' hide isNull, isNotNull, Address;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/gdp/payslip/data/data_source/payslip_api.dart';
import 'package:shared_features/feature/gdp/payslip/data/data_source/payslip_remote_data_source_impl.dart';
import 'package:shared_features/feature/gdp/payslip/data/model/payslip_file_model.dart';
import 'package:shared_features/feature/gdp/payslip/data/model/payslip_model.dart';
import 'package:shared_features/feature/gdp/payslip/data/repository/payslip_repository_impl.dart';
import 'package:shared_features/feature/gdp/payslip/domain/entity/payslip.dart';
import 'package:shared_features/feature/gdp/payslip/domain/entity/payslipFile.dart';
import 'package:shared_features/feature/gdp/payslip/domain/use_case/get_payslips/get_payslip.dart';
import 'package:shared_features/feature/gdp/payslip/domain/use_case/get_payslips/get_payslip_impl.dart';
import 'package:shared_features/feature/gdp/payslip/domain/use_case/get_payslips_file/get_payslip_file.dart';
import 'package:shared_features/feature/gdp/payslip/domain/use_case/get_payslips_file/get_payslip_file_impl.dart';

import 'payslip_test_helpers.dart';

void main() {
  group('PayslipModel', () {
    test('fromJson (snake_case), toJson, toEntity e fromEntity', () {
      final model = PayslipModel.fromJson(payslipJson(
          name: 'h1.pdf', description: 'Holerite', date: '2026-08-05T00:00:00.000'));
      expect(model.name, 'h1.pdf');
      expect(model.description, 'Holerite');
      expect(model.type, 'pdf');
      expect(model.processingDate, DateTime(2026, 8, 5));

      final json = model.toJson();
      expect(json['processing_date'], startsWith('2026-08-05'));
      expect(json['name'], 'h1.pdf');

      final entity = model.toEntity();
      expect(entity, isA<Payslip>());
      expect(entity.description, 'Holerite');
      expect(entity.processingDate, DateTime(2026, 8, 5));

      final volta = PayslipModel.fromEntity(entity)!;
      expect(volta.name, 'h1.pdf');
      expect(volta.type, 'pdf');
      expect(PayslipModel.fromEntity(null), isNull);
    });

    test('nulos', () {
      final model = PayslipModel.fromJson({});
      expect(model.processingDate, isNull);
      expect(model.toJson()['processing_date'], isNull);
      expect(model.toEntity().name, isNull);
      final entity = Payslip(name: 'n', description: 'd', type: 't');
      expect(entity.processingDate, isNull);
    });
  });

  group('PayslipFileModel', () {
    test('fromJson, toJson, toEntity e fromEntity', () {
      final model = PayslipFileModel.fromJson(payslipFileJson());
      expect(model.id, 'F1');
      expect(model.name, 'holerite.pdf');
      expect(model.type, 'pdf');
      expect(model.data, pdfBase64);
      expect(model.toJson(), payslipFileJson());

      final entity = model.toEntity();
      expect(entity, isA<PayslipFile>());
      expect(entity.data, pdfBase64);
      final volta = PayslipFileModel.fromEntity(entity)!;
      expect(volta.id, 'F1');
      expect(volta.name, 'holerite.pdf');
      expect(PayslipFileModel.fromEntity(null), isNull);
      expect(PayslipFile(id: 'x').name, isNull);
    });
  });

  group('PayslipRemoteDataSourceImpl + PayslipRepositoryImpl', () {
    late PayslipEnv env;
    setUp(() => env = PayslipEnv());

    test('find chama o endpoint e converte a lista', () async {
      env.stubPayslips('M1', [payslipJson(name: 'a'), payslipJson(name: 'b')]);
      final result = await env.dataSource.find('M1');
      expect(result.map((e) => e.name), ['a', 'b']);
      expect(env.paths, ['/digitalRepository/documents/M1']);
    });

    test('getFile chama o endpoint com nome e matrícula', () async {
      env.stubPayslipFile('holerite.pdf', 'M1');
      final result = await env.dataSource.getFile('holerite.pdf', 'M1');
      expect(result.name, 'holerite.pdf');
      expect(env.paths, ['/digitalRepository/documents/holerite.pdf/M1']);
    });

    test('resposta com erro lança e o repositório devolve Rejection', () async {
      env.http.failAll();
      expect(() => env.dataSource.find('M1'), throwsA(anything));
      final list = await env.repository.getPayslip('M1');
      expect(list, isA<Rejection<List<Payslip>>>());
      expect(list.fold((l) => l, (r) => null), isA<UnknownFailure>());
      final file = await env.repository.getPayslipFile('h.pdf', 'M1');
      expect(file, isA<Rejection<PayslipFile>>());
    });

    test('repositório ordena por data de processamento decrescente', () async {
      env.stubPayslips('M1', [
        payslipJson(name: 'antigo', date: '2026-01-01T00:00:00.000'),
        payslipJson(name: 'novo', date: '2026-08-01T00:00:00.000'),
        payslipJson(name: 'meio', date: '2026-05-01T00:00:00.000'),
      ]);
      final result = await env.repository.getPayslip('M1');
      final list = result.getOrElse(() => []);
      expect(list.map((e) => e.name), ['novo', 'meio', 'antigo']);
      expect(list.first, isA<Payslip>());
    });

    /// Corrigido: o comparador trata datas nulas de forma consistente — a
    /// ordem relativa dos itens sem data é preservada e eles vão para o fim.
    test('repositório mantém a ordem dos itens sem data de processamento',
        () async {
      env.stubPayslips('M1', [
        payslipJson(name: 'a', date: null),
        payslipJson(name: 'b', date: null),
      ]);
      final result = await env.repository.getPayslip('M1');
      expect(result.getOrElse(() => []).map((e) => e.name), ['a', 'b']);
    });

    test('repositório manda os itens sem data para o fim', () async {
      env.stubPayslips('M1', [
        payslipJson(name: 'sem data', date: null),
        payslipJson(name: 'antigo', date: '2026-01-01T00:00:00.000'),
        payslipJson(name: 'novo', date: '2026-08-01T00:00:00.000'),
      ]);
      final result = await env.repository.getPayslip('M1');
      expect(result.getOrElse(() => []).map((e) => e.name),
          ['novo', 'antigo', 'sem data']);
    });

    test('repositório devolve o arquivo convertido', () async {
      env.stubPayslipFile('h.pdf', 'M1');
      final result = await env.repository.getPayslipFile('h.pdf', 'M1');
      expect(result, isA<Success<PayslipFile>>());
      expect(result.getOrElse(() => PayslipFile()).id, 'F1');
    });
  });

  group('use cases', () {
    late PayslipEnv env;
    setUp(() => env = PayslipEnv());

    test('GetPayslipImpl valida a matrícula', () async {
      final result = await env.getPayslip.call(GetPayslipParam(registrationNumber: ''));
      expect(result.fold((l) => l, (r) => null), isA<InvalidParamFailure>());
      expect(env.http.requests, isEmpty);

      env.stubPayslips('M1', [payslipJson()]);
      final ok = await env.getPayslip.call(GetPayslipParam(registrationNumber: 'M1'));
      expect(ok.getOrElse(() => []), hasLength(1));
    });

    test('GetPayslipFileImpl valida nome e matrícula', () async {
      final semNome = await env.getPayslipFile
          .call(GetPayslipFileParam(nameFile: '', registrationNumber: 'M1'));
      expect(semNome.fold((l) => l, (r) => null), isA<InvalidParamFailure>());
      final semMatricula = await env.getPayslipFile
          .call(GetPayslipFileParam(nameFile: 'h.pdf', registrationNumber: ''));
      expect(semMatricula.fold((l) => l, (r) => null), isA<InvalidParamFailure>());
      expect(env.http.requests, isEmpty);

      env.stubPayslipFile('h.pdf', 'M1');
      final ok = await env.getPayslipFile
          .call(GetPayslipFileParam(nameFile: 'h.pdf', registrationNumber: 'M1'));
      expect(ok.getOrElse(() => PayslipFile()).name, 'h.pdf');
    });

    test('api pode ser criada diretamente', () {
      final api = PayslipApi.create(env.client);
      expect(api, isA<PayslipApi>());
      expect(PayslipRemoteDataSourceImpl(api: api).api, same(api));
      expect(PayslipRepositoryImpl(remoteDataSource: env.dataSource).remoteDataSource,
          same(env.dataSource));
      expect(GetPayslipImpl(repository: env.repository).validate(
          GetPayslipParam(registrationNumber: 'x')), isNull);
      expect(GetPayslipFileImpl(repository: env.repository).validate(
          GetPayslipFileParam(nameFile: 'x', registrationNumber: 'y')), isNull);
    });
  });
}
