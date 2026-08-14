import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/api/maintenance_management_api.dart';
import 'package:lello/feature/maintenance_management/data/data_source/maintenance_management_remote_data_source_impl.dart';
import 'package:lello/feature/maintenance_management/data/exceptions/maintenance_management_api_exception.dart';
import 'package:lello/feature/maintenance_management/data/model/send_technical_inspection_email_request_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

void main() {
  late MaintenanceManagementApi api;
  late MaintenanceManagementRemoteDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    api = _MaintenanceManagementApiMock();
    dataSource = MaintenanceManagementRemoteDataSourceImpl(api);
  });

  group('getCondominiumInfo', () {
    test('deve lançar MaintenanceManagementApiException quando erro vier no body', () async {
      when(() => api.getCondominiumInfo()).thenAnswer(
        (_) async => _response(
          statusCode: 400,
          body: const <String, dynamic>{},
          bodyString: '{"error_code":"MM_001","message":"Erro de negócio"}',
        ),
      );

      expect(
        dataSource.getCondominiumInfo(),
        throwsA(
          isA<MaintenanceManagementApiException>()
              .having((it) => it.errorCode, 'errorCode', 'MM_001')
              .having((it) => it.message, 'message', 'Erro de negócio'),
        ),
      );
      verify(() => api.getCondominiumInfo()).called(1);
    });
  });

  group('getCondominiumInfoV2', () {
    test('deve aceitar errorCode no formato camelCase', () async {
      when(() => api.getCondominiumInfoV2('v2')).thenAnswer(
        (_) async => _response(
          statusCode: 422,
          body: const <String, dynamic>{},
          bodyString: '{"errorCode":"MM_002","message":"Versão inválida"}',
        ),
      );

      expect(
        dataSource.getCondominiumInfoV2(),
        throwsA(
          isA<MaintenanceManagementApiException>()
              .having((it) => it.errorCode, 'errorCode', 'MM_002')
              .having((it) => it.message, 'message', 'Versão inválida'),
        ),
      );
      verify(() => api.getCondominiumInfoV2('v2')).called(1);
    });
  });

  group('requestLegalObligationRenewal', () {
    test('deve retornar true quando sucesso for true no body', () async {
      when(() => api.requestLegalObligationRenewal('123', 'CERTIFICATE')).thenAnswer(
        (_) async => _response(
          statusCode: 200,
          body: {'success': true},
          bodyString: '{"success":true}',
        ),
      );

      final result = await dataSource.requestLegalObligationRenewal(
        id: '123',
        type: 'CERTIFICATE',
      );

      expect(result, isTrue);
      verify(() => api.requestLegalObligationRenewal('123', 'CERTIFICATE')).called(1);
    });

    test('deve lançar mensagem do body quando success for false', () async {
      when(() => api.requestLegalObligationRenewal('456', 'REPORT')).thenAnswer(
        (_) async => _response(
          statusCode: 400,
          body: {'success': false, 'message': 'Não foi possível renovar'},
          bodyString: '{"success":false,"message":"Não foi possível renovar"}',
        ),
      );

      expect(
        dataSource.requestLegalObligationRenewal(
          id: '456',
          type: 'REPORT',
        ),
        throwsA(
          isA<Exception>().having(
            (it) => it.toString(),
            'mensagem',
            contains('Não foi possível renovar'),
          ),
        ),
      );
    });
  });

  group('sendTechnicalInspectionEmail', () {
    test('deve retornar valor de success quando resposta for bem-sucedida', () async {
      final request = SendTechnicalInspectionEmailRequestModel(
        type: 'TECHNICAL',
        id: 'abc',
        email: 'teste@lello.com.br',
      );

      when(() => api.sendTechnicalInspectionEmail(any<Map<String, dynamic>>())).thenAnswer(
        (_) async => _response(
          statusCode: 200,
          body: const <String, dynamic>{},
          bodyString: '{"success":false}',
        ),
      );

      final result = await dataSource.sendTechnicalInspectionEmail(request);

      expect(result, isFalse);
      verify(() => api.sendTechnicalInspectionEmail(any<Map<String, dynamic>>())).called(1);
    });

    test('deve lançar erro do body quando chamada falhar', () async {
      final request = SendTechnicalInspectionEmailRequestModel(
        type: 'TECHNICAL',
        id: 'xyz',
        email: 'erro@lello.com.br',
      );

      when(() => api.sendTechnicalInspectionEmail(any<Map<String, dynamic>>())).thenAnswer(
        (_) async => _response(
          statusCode: 500,
          body: const <String, dynamic>{},
          bodyString: '{"message":"Falha ao enviar"}',
        ),
      );

      expect(
        dataSource.sendTechnicalInspectionEmail(request),
        throwsA(
          isA<Exception>().having(
            (it) => it.toString(),
            'mensagem',
            contains('Falha ao enviar'),
          ),
        ),
      );
    });
  });
}

Response<dynamic> _response({
  required int statusCode,
  required dynamic body,
  required String bodyString,
}) {
  final request = http.Request('GET', Uri.parse('https://example.com'));
  final baseResponse = http.Response(
    bodyString,
    statusCode,
    request: request,
    headers: {'content-type': 'application/json'},
  );
  return Response<dynamic>(baseResponse, body);
}

class _MaintenanceManagementApiMock extends Mock
    implements MaintenanceManagementApi {}
