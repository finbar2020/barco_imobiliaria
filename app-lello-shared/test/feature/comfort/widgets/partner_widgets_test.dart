import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/partner_contact_widget.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/partner_favorite_status.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/partner_info_widget.dart';

import '../../../helpers/pump_app.dart';
import '../../../helpers/test_container.dart';
import '../comfort_my_requests/comfort_requests_test_support.dart';

void main() {
  group('PartnerContactWidget', () {
    testWidgets('mostra o tipo e o título do parceiro', (tester) async {
      final partner = buildPartner(comfortType: ComfortType.cleaning);
      await pumpApp(
          tester, PartnerContactWidget(partnerIntro: partner.partnerIntro));

      expect(find.text('comfort_cleaning'), findsOneWidget);
      expect(find.text('Academia Lello'), findsOneWidget);
      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/partner_contact_widget.png'));
    });

    testWidgets('tipo recém-mapeado usa a própria tradução', (tester) async {
      // Corrigido: `playroom` deixou de cair em "outros".
      final partner = buildPartner(comfortType: ComfortType.playroom);
      await pumpApp(
          tester, PartnerContactWidget(partnerIntro: partner.partnerIntro));
      expect(find.text('comfort_playroom'), findsOneWidget);
      expect(find.text('comfort_others'), findsNothing);
    });

    testWidgets('tipo sem tradução específica cai em "outros"', (tester) async {
      final partner = buildPartner(comfortType: ComfortType.others);
      await pumpApp(
          tester, PartnerContactWidget(partnerIntro: partner.partnerIntro));
      expect(find.text('comfort_others'), findsOneWidget);
    });
  });

  group('PartnerFavoriteStatusWidget', () {
    testWidgets('favorito mostra o coração cheio e o toque inverte', (tester) async {
      final partner = buildPartner(favorite: true);
      final calls = <List<Object>>[];
      await pumpApp(
        tester,
        PartnerFavoriteStatusWidget(
          partnerIntro: partner.partnerIntro,
          onTap: (id, name, favorite) => calls.add([id, name, favorite]),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      await tester.tap(find.byType(InkWell));
      expect(calls, [
        ['p1', 'Academia Lello', false]
      ]);
    });

    testWidgets('não favorito mostra o svg vazio e o toque favorita', (tester) async {
      final partner = buildPartner(favorite: false);
      final calls = <List<Object>>[];
      await pumpApp(
        tester,
        PartnerFavoriteStatusWidget(
          partnerIntro: partner.partnerIntro,
          onTap: (id, name, favorite) => calls.add([id, name, favorite]),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsNothing);
      expect(svgAsset('assets/ic_partner_favorite.svg'), findsOneWidget);
      await tester.tap(find.byType(InkWell));
      expect(calls, [
        ['p1', 'Academia Lello', true]
      ]);
      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/partner_favorite_status_widget.png'));
    });
  });

  group('PartnerIntroWidget', () {
    testWidgets('mostra imagem placeholder, tipo e título', (tester) async {
      final container = TestSharedContainer()
        ..register<AuthenticationStore>(FakeAuthenticationStore());
      final partner = buildPartner(imageLink: '/img/p1');
      var favoriteCalls = 0;

      await pumpApp(
        tester,
        PartnerIntroWidget(
          applicationContainer: container,
          partnerIntro: partner.partnerIntro,
          changeFavoriteStatus: (_, __, ___) => favoriteCalls++,
        ),
      );

      expect(find.text('comfort_gym'), findsOneWidget);
      expect(find.text('Academia Lello'), findsOneWidget);
      // Sem header de autenticação a imagem cai no placeholder local.
      expect(svgAsset('assets/custom_image_network_placeholder.svg'),
          findsOneWidget);
      // O botão de favorito está comentado no widget.
      expect(find.byType(PartnerFavoriteStatusWidget), findsNothing);
      expect(favoriteCalls, 0);
      await expectLater(findGoldenSurface(),
          matchesGoldenFile('goldens/partner_intro_widget.png'));
    });
  });
}
