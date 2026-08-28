import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/presentation/bloc/me_event.dart';
import 'package:morar/feature/me/presentation/bloc/me_state.dart';
import 'package:morar/feature/me/presentation/widgets/me_edit.dart';
import 'package:morar/feature/me/presentation/widgets/me_edit_phone.dart';
import 'package:morar/feature/me/presentation/widgets/me_last_update_info.dart';
import 'package:morar/feature/me/presentation/widgets/me_page/me_profile_info_widget.dart';
import 'package:morar/feature/me/presentation/widgets/me_page/me_profile_picture_widget.dart';
import 'package:shared_features/core/modal/theme_color_dialog.dart';
import 'package:shared_features/core/widgets/color_palette_widget.dart';
import 'package:shared_features/core/widgets/half_color_icon.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'me_page_helpers.dart';

void main() {
  late PageHarness harness;
  late MeFakes fakes;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    fakes = await installMeFakes(harness);
    observer = RecordingNavigatorObserver();
  });

  Future<void> pumpWidgetPage(WidgetTester tester, Widget child,
      {Size surface = const Size(500, 1400)}) async {
    await tester.pumpWidget(const SizedBox());
    await pumpPage(
      tester,
      Scaffold(body: SingleChildScrollView(child: child)),
      observer: observer,
      surface: surface,
    );
  }

  group('MeProfileInfoWidget', () {
    testWidgets('sem cpf, email e telefone mostra "não informado"',
        (tester) async {
      final me = Me()
        ..name = 'x'
        ..cpf = null
        ..email = ''
        ..phone = null
        ..picture = '';
      await pumpWidgetPage(tester, MeProfileInfoWidget(me: me));

      expect(find.text('me_cpf_title'), findsNothing);
      expect(find.text('cnpj'), findsNothing);
      expect(find.text('not_informed'), findsNWidgets(2));
    });

    testWidgets('cnpj usa o título de cnpj', (tester) async {
      final me = testMe(cpf: '12.345.678/0001-90');
      await pumpWidgetPage(tester, MeProfileInfoWidget(me: me));

      expect(find.text('cnpj'), findsOneWidget);
      expect(find.text('12.345.678/0001-90'), findsOneWidget);
    });

    testWidgets('cores do tema: reiniciar volta para o layout do condomínio',
        (tester) async {
      useSession(
        harness,
        testSession(
          me: testMe(condominiums: [testCondominium(layout: testLayout())]),
        ),
      );
      final themes = <ThemeData>[];
      await pumpWidgetPage(
        tester,
        MeProfileInfoWidget(me: testMe(), isGeneric: true, changeTheme: themes.add),
      );

      expect(find.text('Cores do Tema'), findsOneWidget);
      await tester.tap(find.byType(HalfColorIcon));
      await tester.pumpAndSettle();
      expect(find.byType(ThemeColorDialog), findsOneWidget);

      await tester.tap(find.text('REINICIAR'));
      await tester.pumpAndSettle();

      expect(harness.sessionBloc.getThemeColor(), isNull);
      expect(themes, hasLength(1));
      expect(themes.single.brightness, Brightness.light);
      expect(themes.single.colorScheme.primary.toARGB32(), 0xFFFF0000);
    });

    testWidgets('cores do tema: salvar aplica as cores escolhidas (escuro)',
        (tester) async {
      final themes = <ThemeData>[];
      await pumpWidgetPage(
        tester,
        MeProfileInfoWidget(me: testMe(), isGeneric: true, changeTheme: themes.add),
      );

      await tester.tap(find.byType(HalfColorIcon));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      await tester.tap(find.text('SALVAR'));
      await tester.pumpAndSettle();

      expect(harness.sessionBloc.getThemeColor(), isNotNull);
      expect(harness.sessionBloc.getThemeColor()!.isDark, isTrue);
      expect(themes.single.brightness, Brightness.dark);
    });

    testWidgets('cores do tema: fechar o diálogo sem valor não muda nada',
        (tester) async {
      final themes = <ThemeData>[];
      await pumpWidgetPage(
        tester,
        MeProfileInfoWidget(me: testMe(), isGeneric: true, changeTheme: themes.add),
      );

      await tester.tap(find.byType(HalfColorIcon));
      await tester.pumpAndSettle();
      Navigator.of(tester.element(find.byType(ThemeColorDialog))).pop();
      await tester.pumpAndSettle();

      expect(themes, isEmpty);
    });

    testWidgets('"Show Color Palette" abre a paleta de cores', (tester) async {
      await pumpWidgetPage(
        tester,
        MeProfileInfoWidget(me: testMe(), isGeneric: true, changeTheme: (_) {}),
      );

      await tester.tap(find.text('Show Color Palette'));
      await tester.pumpAndSettle();

      expect(find.byType(ColorPaletteWidget), findsOneWidget);
    });
  });

  group('MeLastUpdateInfo', () {
    testWidgets('mostra a diferença do último getMe e do último switch roles',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'LAST_SWITCH_ROLES': DateTime.now().subtract(const Duration(seconds: 30)).toString(),
      });
      final controller = fakes.controller;
      controller.bloc.add(MeLoadedEvent(
          testMe(lastUpdatedAt: DateTime.now().subtract(const Duration(seconds: 5)))));
      await pumpWidgetPage(tester, MeLastUpdateInfo(controller: controller));

      final text = tester.widget<Text>(find.descendant(
        of: find.byType(MeLastUpdateInfo),
        matching: find.byType(Text),
      ));
      // "MMdd-<segundos do getMe>-<segundos do switch roles>"
      expect(text.data, matches(RegExp(r'^\d{4}-\d+-\d+$')));
    });

    testWidgets('sem data de atualização mostra só a data de hoje',
        (tester) async {
      final controller = fakes.controller;
      controller.bloc.add(MeLoadedEvent(testMe()..lastUpdatedAt = null));
      await pumpWidgetPage(tester, MeLastUpdateInfo(controller: controller));

      final text = tester.widget<Text>(find.descendant(
        of: find.byType(MeLastUpdateInfo),
        matching: find.byType(Text),
      ));
      expect(text.data, matches(RegExp(r'^\d{4}$')));
    });
  });

  group('MeEditPhoneInfo', () {
    testWidgets('cancelar chama o callback informado', (tester) async {
      var cancelled = 0;
      await pumpWidgetPage(
        tester,
        MeEditPhoneInfo(
          controller: fakes.controller,
          cancelOnPressed: () => cancelled++,
        ),
      );

      expect(find.text('profile_change_phone_rationale'), findsOneWidget);
      await tester.tap(find.text('cancel'));
      expect(cancelled, 1);
    });

    testWidgets('enquanto pede o código mostra o indicador', (tester) async {
      final controller = fakes.controller;
      await pumpWidgetPage(tester, MeEditPhoneInfo(controller: controller));

      await emitState(tester, controller.bloc,
          MeEditRequestingCodeState(controller.bloc.state.me),
          settle: false);
      await tester.pump();

      expect(find.text('receive_code'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('MeEdit', () {
    Future<void> pumpEdit(WidgetTester tester, Me me) async {
      final controller = fakes.controller;
      controller.bloc.add(MeEditLoadedEvent(me: me));
      await pumpWidgetPage(tester, MeEdit(controller: controller));
    }

    List<String?> phoneFields(WidgetTester tester) {
      final fields = find.byType(TextFormField);
      return [
        tester.widget<TextFormField>(fields.at(2)).initialValue,
        tester.widget<TextFormField>(fields.at(3)).initialValue,
      ];
    }

    testWidgets('separa DDD e telefone nos formatos conhecidos', (tester) async {
      const cases = <String, List<String>>{
        '+55 11 99999-8888': ['11', '999998888'],
        '(11) 99999-8888': ['11', '999998888'],
        '11999998888': ['11', '999998888'],
        '551199999888': ['55', '1199999888'],
        '1199999888': ['11', '99999888'],
        '99999': ['', '99999'],
        '': ['', ''],
        '(11)': ['', ''],
      };
      for (final entry in cases.entries) {
        await pumpEdit(tester, testMe(phone: entry.key));
        expect(phoneFields(tester), entry.value, reason: 'telefone "${entry.key}"');
      }
    });

    testWidgets('digitar o DDD pula para o telefone e monta o número',
        (tester) async {
      final me = testMe(phone: '');
      await pumpEdit(tester, me);

      await tester.enterText(find.byType(TextFormField).at(2), '2');
      expect(me.phone, '(2)');
      await tester.enterText(find.byType(TextFormField).at(2), '21');
      await tester.pumpAndSettle();
      expect(me.phone, '(21)');
      await tester.enterText(find.byType(TextFormField).at(3), '977776666');
      expect(me.phone, '(21)97777-6666');
    });

    testWidgets('cnpj usa o título de cnpj', (tester) async {
      await pumpEdit(tester, testMe(cpf: '12.345.678/0001-90'));

      expect(find.text('cnpj'), findsOneWidget);
    });
  });

  group('MeProfilePictureWidget', () {
    testWidgets('sem botão de edição não mostra o ícone de lápis',
        (tester) async {
      await pumpWidgetPage(
        tester,
        MeProfilePictureWidget(controller: fakes.controller, showEditButton: false),
      );

      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });
}
