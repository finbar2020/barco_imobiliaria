import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:essentials/ui/widget/app_version_and_name/app_version_and_name_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../helpers/pump_app.dart';
import '../../ui_test_helpers.dart';

void main() {
  setUpAll(() {
    PackageInfo.setMockInitialValues(
      appName: 'essentials',
      packageName: 'app.lello.essentials',
      version: '2.5.1',
      buildNumber: '10',
      buildSignature: '',
    );
  });
  tearDown(resetPalletes);

  testWidgets('mostra rótulo e versão com prefixo do app (owner = m)',
      (tester) async {
    await pumpApp(
        tester, AppVersionAndNameWidget(appOrigin: AppOriginEnum.owner));
    expect(find.text('version'), findsOneWidget);
    expect(find.text('m2.5.1'), findsOneWidget);
    final rotulo = tester.widget<Text>(find.text('version'));
    expect(rotulo.textAlign, TextAlign.right);
    expect(rotulo.style!.fontWeight, FontWeight.w700);
    expect(rotulo.style!.color, LightPallete().text());
    final versao = tester.widget<Text>(find.text('m2.5.1'));
    expect(versao.style!.color, LightPallete().text());
    final coluna = tester.widget<Column>(find.byType(Column));
    expect(coluna.crossAxisAlignment, CrossAxisAlignment.end);
  });

  testWidgets('antes do PackageInfo resolver a versão fica vazia',
      (tester) async {
    await pumpApp(
        tester, AppVersionAndNameWidget(appOrigin: AppOriginEnum.owner),
        settle: false);
    expect(find.text(''), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('m2.5.1'), findsOneWidget);
  });

  testWidgets('prefixo s para manager e c para employee', (tester) async {
    await pumpApp(
        tester, AppVersionAndNameWidget(appOrigin: AppOriginEnum.manager));
    expect(find.text('s2.5.1'), findsOneWidget);
    await pumpApp(
        tester, AppVersionAndNameWidget(appOrigin: AppOriginEnum.employee));
    expect(find.text('c2.5.1'), findsOneWidget);
  });

  testWidgets('usa o texto padrão "Versão" sem tradução', (tester) async {
    await pumpApp(
        tester, AppVersionAndNameWidget(appOrigin: AppOriginEnum.owner),
        locOverrides: {'version': 'Versão do app'});
    expect(find.text('Versão do app'), findsOneWidget);
  });

  testWidgets('ambiente não produtivo mostra o nome em roxo', (tester) async {
    await pumpApp(
      tester,
      AppVersionAndNameWidget(
        appOrigin: AppOriginEnum.owner,
        env: FakeEnvironment(isProduction: false, name: 'HOMOLOG'),
      ),
    );
    final env = tester.widget<Text>(find.text('HOMOLOG'));
    expect(env.style!.fontSize, 10);
    expect(env.style!.color, LightPallete().purpleText());
  });

  testWidgets('ambiente produtivo ou nulo não mostra o nome', (tester) async {
    await pumpApp(
      tester,
      AppVersionAndNameWidget(
        appOrigin: AppOriginEnum.owner,
        env: FakeEnvironment(isProduction: true, name: 'PROD'),
      ),
    );
    expect(find.text('PROD'), findsNothing);
    expect(find.byType(Text), findsNWidgets(2));
  });

  testWidgets('desmontar antes do PackageInfo resolver não quebra',
      (tester) async {
    /// Corrigido: o `PackageInfo` é buscado uma única vez no `initState` e o
    /// `setState` só acontece se o widget ainda estiver montado. Aqui o widget
    /// é removido antes do future completar e nenhum erro é reportado.
    await pumpApp(
        tester, AppVersionAndNameWidget(appOrigin: AppOriginEnum.owner),
        settle: false);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('golden do widget de versão', (tester) async {
    await pumpApp(
      tester,
      AppVersionAndNameWidget(
        appOrigin: AppOriginEnum.owner,
        env: FakeEnvironment(isProduction: false, name: 'HML'),
      ),
      surface: const Size(400, 120),
    );
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('../../goldens/app_version_and_name.png'));
  });
}
