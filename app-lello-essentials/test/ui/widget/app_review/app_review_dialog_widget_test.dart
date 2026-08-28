import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/ui/widget/app_review/app_review_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';
import '../fake_plugins.dart';

void main() {
  Future<RecordingNavigatorObserver> pumpDialogo(
    WidgetTester tester,
    AppOriginEnum origem,
  ) async {
    final observer = RecordingNavigatorObserver();
    await pumpApp(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) => AppReviewDialogWidget(appOriginEnum: origem),
          ),
          child: const Text('abrir'),
        ),
      ),
      navigatorObserver: observer,
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    return observer;
  }

  testWidgets('síndico usa o título do gestor; demais origens usam o de morador',
      (tester) async {
    installFakeInAppReview();
    await pumpDialogo(tester, AppOriginEnum.manager);
    expect(find.byType(AppReviewDialogWidget), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.text('rate_dialog_title_sindico'), findsOneWidget);
    expect(find.text('rate_dialog_subtitle'), findsOneWidget);
    expect(find.text('rate_dialog_button'), findsOneWidget);
    expect(find.text('rate_dialog_second_button'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await pumpDialogo(tester, AppOriginEnum.owner);
    expect(find.text('rate_dialog_title_morar'), findsOneWidget);
    expect(find.text('rate_dialog_title_sindico'), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await pumpDialogo(tester, AppOriginEnum.employee);
    expect(find.text('rate_dialog_title_morar'), findsOneWidget);
  });

  testWidgets('botão principal fecha o diálogo e pede a avaliação nativa',
      (tester) async {
    final review = installFakeInAppReview();
    final observer = await pumpDialogo(tester, AppOriginEnum.manager);

    await tester.tap(find.text('rate_dialog_button'));
    await tester.pumpAndSettle();

    expect(review.requestReviewCalls, 1);
    expect(observer.popped, hasLength(1));
    expect(find.byType(AppReviewDialogWidget), findsNothing);
  });

  testWidgets('botão secundário só fecha o diálogo', (tester) async {
    final review = installFakeInAppReview();
    final observer = await pumpDialogo(tester, AppOriginEnum.owner);

    await tester.tap(find.text('rate_dialog_second_button'));
    await tester.pumpAndSettle();

    expect(review.requestReviewCalls, 0);
    expect(observer.popped, hasLength(1));
    expect(find.byType(AppReviewDialogWidget), findsNothing);
  });

  testWidgets('golden', (tester) async {
    installFakeInAppReview();
    await pumpApp(
      tester,
      const AppReviewDialogWidget(appOriginEnum: AppOriginEnum.manager),
      locOverrides: const {
        'rate_dialog_title_sindico': 'Está gostando do app?',
        'rate_dialog_subtitle': 'Sua avaliação nos ajuda a melhorar.',
        'rate_dialog_button': 'Avaliar agora',
        'rate_dialog_second_button': 'Agora não',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/app_review_dialog_widget.png'),
    );
  });
}
