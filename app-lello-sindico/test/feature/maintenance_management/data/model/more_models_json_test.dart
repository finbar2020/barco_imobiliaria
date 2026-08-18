import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/access_management/data/model/url_upload_s3_model.dart';
import 'package:lello/feature/maintenance_management/data/model/condominium_info_model.dart';
import 'package:lello/feature/maintenance_management/data/model/efficiency_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/efficiency_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/filter_options_model.dart';
import 'package:lello/feature/maintenance_management/data/model/formulary_by_month_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/formulary_by_month_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/procedure_options_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_asset_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_local_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_local_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_month_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_month_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_sector_request_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_sector_response_model.dart';
import 'package:lello/feature/maintenance_management/domain/enum/tracking_trade_status.dart';
import 'package:shared_features/shared_features.dart';

void main() {
  test('FilterOptionsModel toJson/fromJson', () {
    final parsed = FilterOptionsModel.fromJson({
      'locals': [
        {'id': 'l1', 'name': 'Hall'}
      ],
      'assets': [
        {'id': 'a1', 'name': 'Bomba'}
      ],
      'responsibles': [
        {'id': 'r1', 'name': 'Maria'}
      ],
      'employee_group': [
        {'id': 'g1', 'name': 'Manutenção'}
      ],
    });
    expect(parsed.locals.single.name, 'Hall');
    expect(parsed.assets.single.id, 'a1');
    expect(parsed.toJson()['employee_group'], isNotEmpty);
  });

  test('ProcedureOptionsModel fromJson com responsável e opções inválidas', () {
    final parsed = ProcedureOptionsModel.fromJson({
      'procedure_options': [
        {
          'id': 12,
          'title': 'Limpeza',
          'title_key': 'clean',
          'url_image': 'https://img',
          'procedure_id': 'p1',
          'first_responsible': {'id': 'u1', 'name': 'João'},
        },
        'ignorar',
        null,
      ],
    });
    expect(parsed.procedureOptions, hasLength(1));
    expect(parsed.procedureOptions.single.title, 'Limpeza');
    expect(parsed.procedureOptions.single.firstResponsible?.name, 'João');
    expect(parsed.toJson()['procedure_options'], isNotEmpty);
  });

  test('CondominiumInfoModel toJson/fromJson com tracking e tokens', () {
    final parsed = CondominiumInfoModel.fromJson({
      'id': 'c1',
      'assets': 2,
      'floor': 'térreo',
      'localsCount': 4,
      'workflowUsers': '3',
      'condominiumName': 'Edifício',
      'blocksCount': 1,
      'unitsCount': 10,
      'references': [1],
      'hasEmployee': true,
      'hasTechnicalInspection': false,
      'tokens': [
        {'fornecedor': 'trade', 'token': 'abc'}
      ],
      'trackingTrade': {
        'id': 'tt1',
        'username': 'sindico',
        'status': 'ACTIVE',
        'admin': true,
      },
      'condominium': {
        'idCondominiumTrackingTrade': 'ct1',
        'condominiumName': 'Edifício',
        'statusCondominium': 'ACTIVE',
      },
    });
    expect(parsed.condominiumName, 'Edifício');
    expect(parsed.tokens?.single.token, 'abc');
    expect(parsed.trackingTrade?.status, TrackingTradeStatus.active);
    expect(parsed.toJson()['id'], 'c1');
  });

  test('TaskByMonth request/response toJson/fromJson', () {
    final request = TaskByMonthRequestModel.fromJson({
      'dtStart': '01/01/2026',
      'untilDate': '31/01/2026',
      'filters': {
        'typeTask': ['ROTINA'],
        'status': ['PENDENTE'],
        'responsibleIds': ['r1'],
        'localIds': ['l1'],
        'assetIds': ['a1'],
      },
    });
    expect(request.filters.typeTask, ['ROTINA']);
    expect(request.toJson()['dtStart'], '01/01/2026');
    expect(request.filters.toJson()['assetIds'], ['a1']);

    final response = TaskByMonthResponseModel.fromJson({
      'formularyByMonthDTO': [
        {
          'name': 'Jan',
          'data': [
            {'key': 'done', 'value': '3'},
            {'key': 'draft', 'value': 1},
          ],
        }
      ],
      'totalConcluidos': 3,
      'totalNaoConcluidos': 1,
      'totalGeral': 4,
    });
    expect(response.totalGeral, 4);
    expect(response.formularyByMonthDto.single.data.first.value, 3);
  });

  test('FormularyByMonth request/response toJson/fromJson', () {
    final request = FormularyByMonthRequestModel.fromJson({
      'dtStart': '01/01/2026',
      'untilDate': '31/01/2026',
      'filters': {
        'typeTask': ['ROTINA'],
        'status': ['PENDENTE'],
        'dayCurrent': '15/01/2026',
        'responsibleIds': [],
        'localIds': [],
        'assetIds': [],
      },
    });
    expect(request.filters.dayCurrent, '15/01/2026');

    final response = FormularyByMonthResponseModel.fromJson({
      'formularyByMonthDTO': [
        {
          'name': 'Rotina',
          'data': [
            {'key': 'ok', 'value': 2},
          ],
        }
      ],
      'totalConcluidos': 2,
      'totalNaoConcluidos': 0,
      'totalGeral': 2,
    });
    expect(response.formularyByMonthDto.single.name, 'Rotina');
    expect(response.toJson()['totalGeral'], 2);
  });

  test('Efficiency request/response toJson/fromJson', () {
    final request = EfficiencyRequestModel.fromJson({
      'dtStart': '01/01/2026',
      'untilDate': '31/01/2026',
      'pageName': 'home',
      'filters': {
        'typeTask': ['ROTINA'],
        'dayCurrent': '15/01/2026',
        'procedureGroupLabels': [],
        'procedureGroupIds': [],
        'responsibleIds': [],
        'displayBy': 'GRUPO',
        'status': ['PENDENTE'],
      },
    });
    expect(request.pageName, 'home');
    expect(request.filters.displayBy, 'GRUPO');

    final response = EfficiencyResponseModel.fromJson({
      'efficiency_response': [
        {
          'id': 'g1',
          'name': 'Grupo',
          'done': 1,
          'not_started': 2,
          'draft': 0,
        }
      ],
      'task_summary': {
        'total': 3,
        'done': 1,
        'notStarted': 2,
        'draft': 0,
      },
    });
    expect(response.efficiencyResponse.single.notStarted, 2);
    expect(response.taskSummary.total, 3);
    expect(response.efficiencyResponse.single.toJson()['not_started'], 2);
    expect(response.toJson()['efficiency_response'], isNotEmpty);
  });

  test('TaskBySector request/response toJson/fromJson', () {
    final request = TaskBySectorRequestModel.fromJson({
      'dtStart': '01/01/2026',
      'untilDate': '31/01/2026',
      'filters': {
        'sectorIds': ['s1'],
        'dayCurrent': '15/01/2026',
      },
    });
    expect(request.filters?.sectorIds, ['s1']);

    final response = TaskBySectorResponseModel.fromJson({
      'data': [
        {'id': 's1', 'name': 'Elétrica', 'value': 4, 'color': '#fff'},
      ],
    });
    expect(response.data.single.name, 'Elétrica');
  });

  test('TaskByLocal request/response toJson/fromJson', () {
    final request = TaskByLocalRequestModel.fromJson({
      'dtStart': '01/01/2026',
      'untilDate': '31/01/2026',
      'filters': {
        'localIds': ['l1'],
      },
    });
    expect(request.filters?.localIds, ['l1']);

    final response = TaskByLocalResponseModel.fromJson({
      'data': [
        {
          'id': 'l1',
          'name': 'Hall',
          'done': 1,
          'draft': 0,
          'not_started': 2,
          'total': 3,
        }
      ],
    });
    expect(response.data.single.notStarted, 2);
  });

  test('TaskByAssetResponseModel fromJson e toEntity', () {
    final parsed = TaskByAssetResponseModel.fromJson({
      'data_task_by_asset_response': [
        {
          'id': '12',
          'name': 'Bomba',
          'done': 1,
          'draft': 0,
          'not_started': 1,
          'total': 2,
        }
      ],
    });
    final entity = parsed.toEntity();
    expect(entity.dataTaskByAssetResponse?.single.id, 12);
    expect(entity.dataTaskByAssetResponse?.single.name, 'Bomba');
  });

  test('UrlUploadS3Model fromJson/toEntity/fromEntity', () {
    final parsed = UrlUploadS3Model.fromJson({
      'file_name': 'laudo.pdf',
      'url': 'https://s3/laudo.pdf',
    });
    expect(parsed.fileName, 'laudo.pdf');
    final entity = parsed.toEntity();
    expect(entity.url, 'https://s3/laudo.pdf');
    expect(UrlUploadS3Model.fromEntity(entity).fileName, 'laudo.pdf');
  });
}
