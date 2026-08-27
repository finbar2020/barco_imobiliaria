import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/rating_bar_widget.dart';

import '../../../helpers/pump_app.dart';
import '../comfort_my_requests/comfort_requests_test_support.dart';

void main() {
  testWidgets('toque na estrela devolve a nota inteira', (tester) async {
    final ratings = <double>[];
    await pumpApp(
      tester,
      RatingBarWidget(allowHalfRating: false, setRating: ratings.add),
    );

    IgnorePointer? nearest() => tester
        .element(find.byType(RatingBar))
        .findAncestorWidgetOfExactType<IgnorePointer>();
    expect(nearest()?.child, isNot(isA<RatingBar>()));
    expect(svgAsset('assets/rating_star_empty.svg'), findsNWidgets(5));

    await setRating(tester, 4);
    expect(ratings, [4.0]);
    await setRating(tester, 1);
    await setRating(tester, 0);
    expect(ratings, [4.0, 1.0, 0.0]);
  });

  testWidgets('sem setRating fica só leitura (IgnorePointer)', (tester) async {
    await pumpApp(
      tester,
      RatingBarWidget(allowHalfRating: true, initValue: 2.5, size: 20),
    );

    final nearest = tester
        .element(find.byType(RatingBar))
        .findAncestorWidgetOfExactType<IgnorePointer>();
    expect(nearest?.child, isA<RatingBar>());
    expect(nearest?.ignoring, isTrue);
    expect(svgAsset('assets/rating_star_full.svg'), findsNWidgets(2));
    expect(svgAsset('assets/rating_star_half.svg'), findsOneWidget);
    expect(svgAsset('assets/rating_star_empty.svg'), findsNWidgets(2));
    await setRating(tester, 5);
    await tester.pump();
    expect(svgAsset('assets/rating_star_full.svg'), findsNWidgets(2));
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('goldens/rating_bar_widget_half.png'));
  });

  testWidgets('disableRating ignora gestos mas mantém o callback', (tester) async {
    final ratings = <double>[];
    await pumpApp(
      tester,
      RatingBarWidget(
        allowHalfRating: false,
        initValue: 3,
        disableRating: true,
        color: Colors.green,
        setRating: ratings.add,
      ),
    );

    final bar = tester.widget<RatingBar>(find.byType(RatingBar));
    expect(bar.ignoreGestures, isTrue);
    expect(bar.glowColor, Colors.green);
    expect(bar.initialRating, 3);
    await setRating(tester, 5);
    expect(ratings, [5.0]);
  });
}
