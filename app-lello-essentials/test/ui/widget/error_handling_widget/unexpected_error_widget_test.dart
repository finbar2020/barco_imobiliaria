import 'package:essentials/ui/widget/error_handling_widget/unexpected_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('mostra ilustração, título, subtítulo e descrição',
      (tester) async {
    await pumpApp(tester, const UnexpectedErrorWidget(), shrinkWrap: false);

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.text('unexpected_error_title'), findsOneWidget);
    expect(find.text('unexpected_error_subtitle'), findsOneWidget);
    expect(find.text('unexpected_error_description'), findsOneWidget);

    final descricao =
        tester.widget<Text>(find.text('unexpected_error_description'));
    expect(descricao.textAlign, TextAlign.center);
    expect(find.byType(Center), findsWidgets);
  });

  testWidgets('golden', (tester) async {
    await pumpApp(
      tester,
      const UnexpectedErrorWidget(),
      shrinkWrap: false,
      locOverrides: const {
        'unexpected_error_title': 'Ops!',
        'unexpected_error_subtitle': 'Algo inesperado aconteceu',
        'unexpected_error_description':
            'Tente novamente em alguns instantes.',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('../goldens/unexpected_error_widget.png'),
    );
  });
}
