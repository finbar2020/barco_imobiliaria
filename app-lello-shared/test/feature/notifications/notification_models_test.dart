import 'package:essentials/essentials.dart' hide isNull, isNotNull, Image;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/notifications/data/models/notification_model.dart';
import 'package:shared_features/feature/notifications/data/models/notification_resume_model.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/pump_app.dart';
import 'notifications_support.dart';

void main() {
  setUpAll(initDates);

  group('NotificationModel', () {
    test('fromJson lê as chaves snake_case e toJson devolve o mesmo mapa', () {
      final json = notificationJson(
          id: 'n9', hash: 'h1', bigMessage: 'big', senderId: 's1', uuidGroup: 'g1');
      final model = NotificationModel.fromJson(json);

      expect(model.id, 'n9');
      expect(model.date, DateTime(2026, 1, 10, 9, 30));
      expect(model.title, 'Título 1');
      expect(model.message, 'Mensagem 1');
      expect(model.visualizedAt, isNull);
      expect(model.status, 'ATIVO');
      expect(model.reference, 'U1');
      expect(model.identifier, 'ident-n9');
      expect(model.module, 'BOLETOS');
      expect(model.type, 'PUSH');
      expect(model.markRead, isFalse);
      expect(model.inApp, isTrue);
      expect(model.typeRedirect, 'FEATURE');
      expect(model.redirectPath, 'BOLETOS');
      expect(model.redirectId, 'b1');
      expect(model.callback, 'cb');
      expect(model.hash, 'h1');
      expect(model.bigMessage, 'big');
      expect(model.senderId, 's1');
      expect(model.uuidGroup, 'g1');
      expect(model.canRedirect, isTrue);

      expect(model.toJson(), json);
    });

    test('fromJson aceita as chaves camelCase do push', () {
      final model = NotificationModel.fromJson({
        'id': 'p1',
        'redirectId': '77',
        'redirectPath': 'OCORRENCIA_NOVA',
        'visualizedAt': '2026-02-01T10:00:00.000',
        'markRead': 'true',
        'inApp': 'false',
        'typeRedirect': 'FEATURE',
        'bigMessage': '<b>oi</b>',
        'senderId': 'sender',
        'uuidGroup': 'grupo',
      });

      expect(model.redirectId, '77');
      expect(model.redirectPath, 'OCORRENCIA_NOVA');
      expect(model.visualizedAt, DateTime(2026, 2, 1, 10));
      expect(model.markRead, isTrue);
      expect(model.inApp, isFalse);
      expect(model.typeRedirect, 'FEATURE');
      expect(model.bigMessage, '<b>oi</b>');
      expect(model.senderId, 'sender');
      expect(model.uuidGroup, 'grupo');
    });

    test('fromJson lê visualized_at em snake_case', () {
      final json = notificationJson()..['visualized_at'] = '2026-02-01T10:00:00.000';
      expect(NotificationModel.fromJson(json).visualizedAt, DateTime(2026, 2, 1, 10));
    });

    test('fromJson usa `path` como redirectPath e aceita visualizedAt nulo', () {
      final model = NotificationModel.fromJson({
        'id': 'p2',
        'path': 'BOLETOS',
        'visualizedAt': null,
        'markRead': true,
        'inApp': 1,
      });
      expect(model.redirectPath, 'BOLETOS');
      expect(model.visualizedAt, isNull);
      expect(model.markRead, isTrue);
      expect(model.inApp, isFalse);
      expect(model.canRedirect, isTrue);

      expect(NotificationModel.fromJson({'id': 'x'}).canRedirect, isFalse);
      expect(NotificationModel.fromJson({'id': 'x', 'redirect_path': ''})
          .canRedirect, isFalse);
    });

    test('fromEntity/toEntity preservam os campos e a página', () {
      final entity = buildNotification(
          id: 'n1', hash: 'h', bigMessage: 'b', senderId: 's', uuidGroup: 'g',
          page: 3);
      final model = NotificationModel.fromEntity(entity)!;
      expect(model.id, 'n1');
      expect(model.hash, 'h');
      expect(model.bigMessage, 'b');
      expect(model.senderId, 's');
      expect(model.uuidGroup, 'g');
      expect(model.callback, 'cb');

      final back = model.toEntity(page: 5);
      expect(back.page, 5);
      expect(back.id, 'n1');
      expect(back.senderId, 's');
      expect(back.uuidGroup, 'g');
      expect(back.markRead, isFalse);

      expect(NotificationModel.fromEntity(null), isNull);
    });
  });

  group('NotificationResumeModel', () {
    test('json, entidade e nulos viram zero', () {
      final model = NotificationResumeModel.fromJson(resumeJson());
      expect(model.totalRead, 3);
      expect(model.totalIgnored, 1);
      expect(model.totalExcluded, 0);
      expect(model.totalReceived, 2);
      expect(model.toJson(), resumeJson());

      final entity = model.toEntity();
      expect(entity.totalRead, 3);
      expect(entity.totalReceived, 2);

      final empty = NotificationResumeModel().toEntity();
      expect(empty.totalRead, 0);
      expect(empty.totalIgnored, 0);
      expect(empty.totalExcluded, 0);
      expect(empty.totalReceived, 0);

      final fromEntity = NotificationResumeModel.fromEntity(
          NotificationResumeEntity(totalRead: 7, totalReceived: 8))!;
      expect(fromEntity.totalRead, 7);
      expect(fromEntity.totalReceived, 8);
      expect(fromEntity.totalIgnored, isNull);
      expect(NotificationResumeModel.fromEntity(null), isNull);
    });
  });

  group('SingleNotification', () {
    test('dateFormatted: hoje, ontem e data completa', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day, 14, 5);
      expect(SingleNotification(date: today).dateFormatted, 'Hoje, às 14:05');

      /// Defeito: "Ontem" só é detectado quando ontem cai no mesmo mês
      /// (`date.day - now.day == -1`); no dia 1º a data de ontem cai no
      /// formato completo. O teste cobre o comportamento atual.
      final yesterday = today.subtract(const Duration(days: 1));
      final expectedYesterday = yesterday.month == now.month
          ? 'Ontem, às 14:05'
          : '${DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR').format(yesterday)}, às 14:05';
      expect(SingleNotification(date: yesterday).dateFormatted,
          expectedYesterday);

      expect(SingleNotification(date: DateTime(2025, 3, 7, 8, 1)).dateFormatted,
          '7 de março de 2025, às 08:01');
      expect(SingleNotification().dateFormatted, isNull);
    });

    test('datePeriodKey agrupa por semana, mês e mês/ano', () {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeekDate =
          DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

      expect(SingleNotification(date: now).datePeriodKey, 'Esta semana');
      expect(SingleNotification(date: startOfWeekDate).datePeriodKey,
          'Esta semana');

      final beforeWeek = startOfWeekDate.subtract(const Duration(days: 1));
      final expected = beforeWeek.year == now.year && beforeWeek.month == now.month
          ? 'Este mês'
          : _capitalized(
              DateFormat("MMMM 'de' yyyy", 'pt_BR').format(beforeWeek));
      expect(SingleNotification(date: beforeWeek).datePeriodKey, expected);

      expect(SingleNotification(date: DateTime(2025, 3, 7)).datePeriodKey,
          'Março de 2025');
      expect(SingleNotification().datePeriodKey, '');
    });

    test('getters derivados', () {
      final n = buildNotification(page: 2, hash: 'abc', bigMessage: '<p>x</p>');
      expect(n.getBackgroundColor, Colors.grey);
      expect(buildNotification(page: 1).getBackgroundColor, Colors.white);
      expect(n.imageLink, '/dashboard/pendencies/notificationImage/abc');
      expect(buildNotification().imageLink, isNull);
      expect(buildNotification(hash: '').imageLink, isNull);
      expect(n.getInAppMessage, '<p>x</p>');
      expect(n.isHtml, isTrue);
      expect(buildNotification().getInAppMessage, 'Mensagem 1');
      expect(buildNotification().isHtml, isFalse);
      expect(buildNotification(message: null).getInAppMessage, '');
      expect(n.canRedirect, isTrue);
      expect(buildNotification(reference: null).canRedirect, isFalse);
      expect(buildNotification(redirectPath: '').canRedirect, isFalse);
    });

    testWidgets('iconFromModule escolhe o ícone pelo módulo ou pelo título',
        (tester) async {
      final modules = [
        'OCORRENCIA',
        'PRESTACAO_CONTAS',
        'RESERVA_AREA',
        'RESERVA_MUDANCA',
        'DESPESAS',
        'MKT',
        'GDP',
        'BOLETOS',
        'COMUNICADOS',
        'CORRESPONDENCIA',
        'APROVACOES',
        'SISTEMA',
        'ACORDOS',
        'QUALQUER',
        null,
      ];
      final bundle = NotificationsAssetBundle();
      await pumpApp(
        tester,
        withNotificationAssets(bundle: bundle, Wrap(
          children: [
            for (final m in modules)
              SizedBox(
                width: 40,
                height: 40,
                child: buildNotification(module: m).iconFromModule(Colors.blue),
              ),
            // Módulo desconhecido, mas título conhecido.
            SizedBox(
              width: 40,
              height: 40,
              child: buildNotification(module: 'X', title: 'GDP')
                  .iconFromModule(Colors.red),
            ),
          ],
        )),
        settle: false,
      );
      await tester.pump();

      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images, hasLength(modules.length + 1));
      String asset(int i) => (images[i].image as AssetImage).assetName;
      expect(asset(0), 'assets/ic_notifications_ocorrencia.png');
      expect(asset(1), 'assets/ic_notifications_prestacao_conta.png');
      expect(asset(2), 'assets/ic_notifications_reservas.png');
      expect(asset(3), 'assets/ic_notifications_reservas.png');
      expect(asset(4), 'assets/ic_notifications_despesas.png');
      expect(asset(5), 'assets/ic_notifications_marketing.png');
      expect(asset(6), 'assets/ic_notifications_gdp.png');
      expect(asset(7), 'assets/ic_notifications_boletos.png');
      expect(asset(8), 'assets/ic_notifications_comunicados.png');
      expect(asset(9), 'assets/ic_notifications_correspondencias.png');
      expect(asset(10), 'assets/ic_notifications_aprovacoes.png');
      expect(asset(11), 'assets/ic_notifications_outras.png');
      expect(asset(12), 'assets/ic_notifications_outras.png');
      expect(asset(13), 'assets/ic_notifications_outras.png');
      expect(asset(14), 'assets/ic_notifications_outras.png');
      expect(asset(15), 'assets/ic_notifications_gdp.png');
      expect(images.first.color, Colors.white);
      await tester.pump();
      expect(bundle.loaded, contains('assets/ic_notifications_gdp.png'));
    });

    testWidgets('getModuleTitle traduz cada módulo', (tester) async {
      late BuildContext ctx;
      await pumpApp(tester, Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      }));

      String title(String? module) =>
          buildNotification(module: module).getModuleTitle(ctx);
      expect(title('ACORDOS'), 'agreements');
      expect(title('OCORRENCIA'), 'reports_report');
      expect(title('PRESTACAO_CONTAS'), 'accountability_title');
      expect(title('RESERVA_AREA'), 'condominium_hub_manage_space');
      expect(title('RESERVA_MUDANCA'), 'condominium_hub_manage_space');
      expect(title('BOLETOS'), 'income_control_billets');
      expect(title('GDP'), 'lello_hub_employee');
      expect(title('COMUNICADOS'), 'notification_module_announcements');
      expect(title('MKT'), 'notification_module_mkt');
      expect(title('CORRESPONDENCIA'), 'mailing_title');
      expect(title('DESPESAS'), 'lello_hub_outcome');
      expect(title('OUTRO'), 'notification_module_others');
      expect(title(null), 'notification_module_others');
    });
  });

  test('enums de rota e de callback', () {
    expect(FeaturesRoutesEnum.values, contains(FeaturesRoutesEnum.BOLETOS));
    expect(stringToEnum(FeaturesRoutesEnum.values, 'DOCUMENTOS_ATAS'),
        FeaturesRoutesEnum.DOCUMENTOS_ATAS);
    expect(stringToEnum(FeaturesRoutesEnum.values, 'NAO_EXISTE'), isNull);
    expect(enumToString(NotificationCallbackType.CLICOU), 'CLICOU');
    expect(NotificationCallbackType.values, hasLength(5));
    final resume = NotificationResumeEntity(totalRead: 1);
    expect(resume.totalRead, 1);
    expect(resume.totalIgnored, isNull);
  });
}

String _capitalized(String s) => s[0].toUpperCase() + s.substring(1);
