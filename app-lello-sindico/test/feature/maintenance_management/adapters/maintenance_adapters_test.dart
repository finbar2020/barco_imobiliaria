import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/adapters/assets_lookup_model_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/chat/chat_channel_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/chat/chat_message_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/condominium_info_adapters.dart';
import 'package:lello/feature/maintenance_management/adapters/create_task_from_schedule_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/efficiency_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/filter_options_model_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/formulary_by_month_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/legal_obligation_activity_history_model_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/legal_obligation_model_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/locals_lookup_model_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/procedure_options_model_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/task_by_asset_model_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/task_by_local_model_adapter.dart';
import 'package:lello/feature/maintenance_management/adapters/task_by_month_adapter.dart';
import 'package:lello/feature/maintenance_management/data/model/assets_lookup_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/chat_channel_model.dart';
import 'package:lello/feature/maintenance_management/data/model/chat/chat_message_model.dart';
import 'package:lello/feature/maintenance_management/data/model/condominium_info_model.dart';
import 'package:lello/feature/maintenance_management/data/model/create_task_from_schedule_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/efficiency_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/filter_options_model.dart';
import 'package:lello/feature/maintenance_management/data/model/formulary_by_month_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/legal_obligation_activity_history_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/legal_obligation_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/locals_lookup_model.dart';
import 'package:lello/feature/maintenance_management/data/model/procedure_options_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_asset_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_local_response_model.dart';
import 'package:lello/feature/maintenance_management/data/model/task_by_month_response_model.dart';
import 'package:lello/feature/maintenance_management/domain/entity/create_task_from_schedule_entity.dart';

void main() {
  test('CondominiumInfo adapters mapeiam token TRACKING_TRADE', () {
    final model = CondominiumInfoModel.fromJson({
      'id': 'c1',
      'assets': 2,
      'floor': 'térreo',
      'localsCount': 4,
      'workflowUsers': '3',
      'condominiumName': 'Edifício',
      'blocksCount': 1,
      'unitsCount': 10,
      'hasEmployee': true,
      'tokens': [
        {'fornecedor': 'TRACKING_TRADE', 'token': 'jwt'},
      ],
      'trackingTrade': {
        'id': 'tt1',
        'idSession': 's1',
        'username': 'sindico',
        'status': 'ACTIVE',
        'admin': true,
        'profileId': 'p1',
        'imageUrl': 'https://img',
      },
      'condominium': {
        'idCondominiumTrackingTrade': 'ct1',
        'condominiumName': 'Edifício',
        'statusCondominium': 'ACTIVE',
      },
    });
    final entity = model.toEntity;
    expect(entity.trackingTradeToken, 'jwt');
    expect(entity.isAdmin, isTrue);
    expect(entity.tokens.single.token, 'jwt');
    expect(entity.condominium?.idCondominiumTrackingTrade, 'ct1');
  });

  test('Chat message e channel adapters', () {
    final message = ChatMessageModel.fromJson({
      'id': 'm1',
      'content': 'olá',
      'channel_id': 'ch1',
      'author_id': 'u1',
      'messageType': 'TEXT',
      'createdAt': '10/01/2026 08:30:00',
      'author': {
        'id': 'u1',
        'name': 'Ana',
        'email': 'a@b.com',
        'profile': {'id': 'p1', 'name': 'Síndico'},
      },
      'attachment': {
        'id': 'f1',
        'name': 'foto.png',
        'url': 'https://s3/f',
        'attachmentType': 'IMAGE',
        'fileSize': '10',
      },
    });
    final entity = message.toEntity();
    expect(entity.content, 'olá');
    expect(entity.createdAt.day, 10);
    expect(entity.author.profile?.name, 'Síndico');
    expect(entity.attachment?.name, 'foto.png');
    expect([message].toEntityList().single.id, 'm1');

    final iso = ChatMessageModel.fromJson({
      'id': 'm2',
      'content': 'iso',
      'createdAt': '2026-01-10T08:30:00.000',
      'author': {'id': 'u1', 'name': 'Ana', 'email': 'a@b.com'},
    }).toEntity();
    expect(iso.createdAt.year, 2026);

    final channels = ChatChannelsResponseModel.fromJson({
      'success': true,
      'ttJwtToken': 'tok',
      'pageInfo': {
        'hasNextPage': true,
        'hasPreviousPage': false,
        'startCursor': 'a',
        'endCursor': 'b',
      },
      'data': [
        {
          'id': 'ch1',
          'typeTask': 'ROTINA',
          'status': 'OPEN',
          'task': {'id': 't1', 'name': 'Limpeza'},
          'lastMessage': {
            'id': 'm1',
            'content': 'oi',
            'createdAt': '2026-01-10T08:00:00.000Z',
            'author': {'id': 'u1', 'name': 'Ana', 'email': 'a@b.com'},
          },
        }
      ],
    }).toEntity();
    expect(channels.channels.single.task.name, 'Limpeza');
    expect(channels.pageInfo?.hasNextPage, isTrue);
    expect((null as PageInfoModel?).toEntity() == null, isTrue);
  });

  test('Adapters de filtros, procedimentos, lookup e obrigações', () {
    final filters = FilterOptionsModelAdapter.fromModel(
      FilterOptionsModel.fromJson({
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
      }),
    );
    expect(filters.locals.single.name, 'Hall');
    expect(filters.taskType, isNotEmpty);

    final procedures = ProcedureOptionsModelAdapter.toEntity(
      ProcedureOptionsModel.fromJson({
        'procedure_options': [
          {
            'id': 1,
            'title': 'Limpeza',
            'first_responsible': {'id': 'u1', 'name': 'João'},
          }
        ],
      }),
    );
    expect(procedures.procedureOptions.single.firstResponsible?.name, 'João');

    expect(
      LocalsLookupModelAdapter.toEntity(
        LocalsLookupModel.fromJson({
          'locals': [
            {'id': 'l1', 'name': 'Hall', 'hierarchy_locals': 'Bloco A'}
          ],
        }),
      ).locals.single.hierarchyLocals,
      'Bloco A',
    );
    expect(
      AssetsLookupModelAdapter.toEntity(
        AssetsLookupModel.fromJson({
          'assets': [
            {'id': 'a1', 'name': 'Bomba'}
          ],
        }),
      ).assets.single.name,
      'Bomba',
    );

    final legal = LegalObligationResponseModel.fromJson({
      'success': true,
      'message': 'ok',
      'metadata': {'requestPartner': true},
      'data': [
        {
          'id': '1',
          'description': 'AVCB',
          'status': 'PENDING',
          'availableActions': ['NOTIFY'],
        }
      ],
    }).toEntity;
    expect(legal.items.single.description, 'AVCB');
    expect(legal.requestPartner, isTrue);

    final history = LegalObligationActivityHistoryResponseModel.fromJson({
      'success': true,
      'data': [
        {
          'collectionCode': 'c1',
          'date': '2026-01-10',
          'description': 'enviado',
          'responsible': 'Ana',
          'status': 'DONE',
        }
      ],
    }).toEntity;
    expect(history.items.single.responsible, 'Ana');
  });

  test('Adapters de gráficos, eficiência e criação de tarefa', () {
    final month = TaskByMonthResponseModel.fromJson({
      'formularyByMonthDTO': [
        {
          'name': 'Jan',
          'data': [
            {'key': 'done', 'value': 2}
          ],
        }
      ],
      'totalConcluidos': 2,
      'totalNaoConcluidos': 0,
      'totalGeral': 2,
    }).toEntity;
    expect(month.totalGeral, 2);

    final formulary = FormularyByMonthResponseModel.fromJson({
      'formularyByMonthDTO': [
        {
          'name': 'Rotina',
          'data': [
            {'key': 'ok', 'value': 1}
          ],
        }
      ],
      'totalConcluidos': 1,
      'totalNaoConcluidos': 0,
      'totalGeral': 1,
    }).toEntity;
    expect(formulary.formularyByMonthDto.single.name, 'Rotina');

    final efficiency = EfficiencyResponseModel.fromJson({
      'efficiency_response': [
        {'id': 'g1', 'name': 'Grupo', 'done': 1, 'not_started': 2, 'draft': 0}
      ],
      'task_summary': {'total': 3, 'done': 1, 'notStarted': 2, 'draft': 0},
    }).toEntity;
    expect(efficiency.taskSummary.total, 3);

    final local = TaskByLocalResponseModelAdapter.toEntity(
      TaskByLocalResponseModel.fromJson({
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
      }),
    );
    expect(local.data.single.total, 3);

    final asset = TaskByAssetResponseModelAdapter.toEntity(
      TaskByAssetResponseModel.fromJson({
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
      }),
    );
    expect(asset.dataTaskByAssetResponse?.single.name, 'Bomba');

    final request = CreateTaskFromScheduleAdapter.toModel(
      CreateTaskFromScheduleRequestEntity(
        scheduleId: 's1',
        scheduleEventId: 'e1',
      ),
    );
    expect(request.scheduleId, 's1');

    final created = CreateTaskFromScheduleAdapter.toEntity(
      CreateTaskFromScheduleResponseModel.fromJson({
        'task': {
          'id': 't1',
          'name': 'Limpeza',
          'current_responsible_name': 'Ana',
        },
        'event': {
          'id': 'e1',
          'name': 'Evento',
          'last_content_answers': {
            'questionId': 'q1',
            'type': 'TEXT',
            'content': 'ok',
            'updatedAt': '2026-01-10',
            'formularyId': 'f1',
          },
        },
      }),
    );
    expect(created.task.name, 'Limpeza');
    expect(created.event.lastContentAnswers?.content, 'ok');
  });
}
