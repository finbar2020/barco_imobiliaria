import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/feature/documents/data/model/document_file_response_model.dart';
import 'package:morar/feature/documents/domain/entity/document_file.dart';
import 'package:morar/feature/documents/integration/documents_routing.dart';
import 'package:morar/feature/documents/integration/morar_documents_analytics.dart';
import 'package:morar/feature/documents/integration/morar_documents_menu_strategy.dart';
import 'package:morar/feature/documents/integration/morar_shared_session.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_menu_item.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';
import '../../helpers/test_application_container.dart';

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  test('DocumentFile e DocumentFileResponseModel', () {
    final entity = DocumentFile(id: '1', name: 'n', type: 't', data: 'd', extractedText: 'x');
    expect(entity.toString(), contains('name: n'));
    final model = DocumentFileResponseModel.fromEntity(entity)!;
    expect(model.toJson(), {'id': '1', 'name': 'n', 'type': 't', 'data': 'd', 'extractedText': 'x'});
    expect(DocumentFileResponseModel.fromJson(model.toJson()).toEntity().extractedText, 'x');
    expect(DocumentFileResponseModel.fromEntity(null), isNull);
    expect(DocumentsPageArgs(type: FeaturesRoutesEnum.DOCUMENTOS_ATAS).type, FeaturesRoutesEnum.DOCUMENTOS_ATAS);
  });

  test('MorarSharedSession lê a sessão ao vivo', () {
    final sessionBloc = FakeSessionBloc();
    final shared = MorarSharedSession(sessionBloc);
    expect(shared.condominiumId, 'c1');
    expect(shared.condominiumReference, 'R1');
    expect(shared.unitId, 'u1');
    expect(shared.userId, 'm1');
    sessionBloc.session.unity = testUnity(id: 'u2');
    expect(shared.unitId, 'u2');
  });

  test('MorarDocumentsAnalytics loga por tipo', () {
    fakeAnalytics.reset();
    final analytics = MorarDocumentsAnalytics(FakeSessionBloc());
    analytics.logAccess('documents_minutes');
    analytics.logAccess('documents_notices');
    analytics.logAccess('documents_circulars');
    analytics.logAccess('documents_divers');
    analytics.logAccess('outro');
    analytics.logShare('documents_minutes');
    expect(fakeAnalytics.eventNames, [
      'documentos_atas_acessar',
      'documentos_editais_acessar',
      'documentos_circulares_acessar',
      'documentos_diversos_acessar',
      'documentos_acessar_compartilhar',
    ]);
    expect(fakeAnalytics.events['documentos_atas_acessar']!['unidade'], '101');
  });

  testWidgets('MorarDocumentsMenuStrategy envolve os cards no circuit breaker', (tester) async {
    final sessionBloc = FakeSessionBloc(allowedRbacs: {ApplicationRbac.morarDocumentosAtas});
    await installTestCircuitBreaker(sessionBloc: sessionBloc);
    final strategy = MorarDocumentsMenuStrategy(sessionBloc);
    expect(strategy.items, kDefaultDocumentsMenuItems);
    expect(strategy.items, isNotEmpty);

    Widget wrap(String type) => Builder(
          builder: (context) => strategy.wrapItem(
            context,
            DocumentsMenuItem(type),
            Text('card-$type'),
          ),
        );
    await pumpApp(
      tester,
      Column(children: [
        wrap('documents_minutes'),
        wrap('documents_notices'),
        wrap('documents_divers'),
        wrap('documents_circulars'),
        wrap('outro'),
      ]),
      localized: true,
    );
    expect(find.byType(CircuitBreakerWidget), findsNWidgets(5));
    expect(find.text('card-documents_minutes'), findsOneWidget);
    expect(find.text('card-documents_notices'), findsNothing);
    expect(sessionBloc.rbacChecked, contains(ApplicationRbac.morarDocumentosEditais));
  });
}
