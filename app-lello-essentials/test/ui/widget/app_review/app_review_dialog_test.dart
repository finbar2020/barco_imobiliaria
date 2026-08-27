import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/ui/widget/app_review/app_review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/pump_app.dart';
import '../fake_plugins.dart';

const _chave = 'REVIEW_DATE_CHECK';
const _umDiaMs = 24 * 60 * 60 * 1000;

void main() {
  Future<BuildContext> contexto(WidgetTester tester) async {
    late BuildContext ctx;
    await pumpApp(
      tester,
      Builder(
        builder: (c) {
          ctx = c;
          return const SizedBox();
        },
      ),
    );
    return ctx;
  }

  Future<String?> dataSalva() async =>
      (await SharedPreferences.getInstance()).getString(_chave);

  testWidgets('sem data salva grava a data atual e não pede avaliação',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final review = installFakeInAppReview();
    final ctx = await contexto(tester);

    await AppReviewDialog.call(
      context: ctx,
      origin: AppOriginEnum.manager,
      reviewInterval: _umDiaMs,
    );
    // `_setDate` não é aguardado pelo `call`.
    await tester.pump();

    expect(review.isAvailableCalls, 1);
    expect(review.requestReviewCalls, 0);
    final data = await dataSalva();
    expect(data, isNotNull);
    expect(DateTime.parse(data!).difference(DateTime.now()).abs(),
        lessThan(const Duration(minutes: 1)));
  });

  testWidgets('data vazia também grava a data atual', (tester) async {
    SharedPreferences.setMockInitialValues({_chave: ''});
    final review = installFakeInAppReview();
    final ctx = await contexto(tester);

    await AppReviewDialog.call(
      context: ctx,
      origin: AppOriginEnum.owner,
      reviewInterval: _umDiaMs,
    );
    await tester.pump();

    expect(review.requestReviewCalls, 0);
    expect(await dataSalva(), isNotEmpty);
  });

  testWidgets('intervalo atingido pede a avaliação nativa', (tester) async {
    final antiga = DateTime.now().subtract(const Duration(days: 2)).toString();
    SharedPreferences.setMockInitialValues({_chave: antiga});
    final review = installFakeInAppReview();
    final ctx = await contexto(tester);

    await AppReviewDialog.call(
      context: ctx,
      origin: AppOriginEnum.employee,
      reviewInterval: _umDiaMs,
    );
    await tester.pump();

    expect(review.requestReviewCalls, 1);
    expect(find.byType(Dialog), findsNothing,
        reason: 'o diálogo próprio está desativado; usa só o review nativo');
    expect(await dataSalva(), antiga,
        reason: 'a data não é atualizada ao pedir o review');
  });

  testWidgets('intervalo zero com data de agora também pede avaliação',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      _chave: DateTime.now().subtract(const Duration(seconds: 1)).toString(),
    });
    final review = installFakeInAppReview();
    final ctx = await contexto(tester);

    await AppReviewDialog.call(
      context: ctx,
      origin: AppOriginEnum.manager,
      reviewInterval: 0,
    );
    expect(review.requestReviewCalls, 1);
  });

  testWidgets('intervalo não atingido não pede avaliação', (tester) async {
    final recente = DateTime.now().toString();
    SharedPreferences.setMockInitialValues({_chave: recente});
    final review = installFakeInAppReview();
    final ctx = await contexto(tester);

    await AppReviewDialog.call(
      context: ctx,
      origin: AppOriginEnum.manager,
      reviewInterval: _umDiaMs,
    );

    expect(review.requestReviewCalls, 0);
    expect(await dataSalva(), recente);
  });

  /// Corrigido: uma data corrompida nas preferências é tratada como "sem
  /// data" — não pede avaliação nesta chamada, mas regrava a data atual para
  /// que o intervalo volte a contar.
  testWidgets('data inválida salva não pede avaliação e é regravada',
      (tester) async {
    SharedPreferences.setMockInitialValues({_chave: 'não é data'});
    final review = installFakeInAppReview();
    final ctx = await contexto(tester);

    await AppReviewDialog.call(
      context: ctx,
      origin: AppOriginEnum.manager,
      reviewInterval: 0,
    );
    await tester.pump();

    expect(review.requestReviewCalls, 0);
    expect(tester.takeException(), isNull);
    final data = await dataSalva();
    expect(data, isNot('não é data'));
    expect(DateTime.parse(data!).difference(DateTime.now()).abs(),
        lessThan(const Duration(minutes: 1)));
  });

  testWidgets('review indisponível não grava data nem pede avaliação',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final review = installFakeInAppReview(available: false);
    final ctx = await contexto(tester);

    await AppReviewDialog.call(
      context: ctx,
      origin: AppOriginEnum.manager,
      reviewInterval: 0,
    );
    await tester.pump();

    expect(review.isAvailableCalls, 1);
    expect(review.requestReviewCalls, 0);
    expect(await dataSalva(), isNull);
  });

  testWidgets('erro do plugin é engolido', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final review = installFakeInAppReview()
      ..isAvailableError = StateError('sem loja');
    final ctx = await contexto(tester);

    await expectLater(
      AppReviewDialog.call(
        context: ctx,
        origin: AppOriginEnum.manager,
        reviewInterval: 0,
      ),
      completes,
    );
    expect(review.requestReviewCalls, 0);
    expect(await dataSalva(), isNull);
  });
}
