import 'package:colaborador/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:essentials/essentials.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';
import '../helpers/test_application_container.dart';

void main() {
  tearDown(resetTestApplicationContainer);

  testWidgets('sem header customizado cai no placeholder svg', (tester) async {
    final scope = await installTestApplicationContainer();
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const CustomCachedNetworkImage(link: '/foto.png'),
      settle: false,
    );

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNothing);
  });

  testWidgets('link nulo cai no placeholder svg', (tester) async {
    final scope = await installTestApplicationContainer(
      customHeader: const {'Authorization': 'Bearer abc'},
    );
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const CustomCachedNetworkImage(link: null),
      settle: false,
    );

    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('usa placeholder customizado quando informado', (tester) async {
    final scope = await installTestApplicationContainer();
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const CustomCachedNetworkImage(
        link: null,
        errorImageAssetsPath: 'assets/img_logo_colab.svg',
      ),
      settle: false,
    );

    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('com header customizado monta CachedNetworkImage com a base url',
      (tester) async {
    final scope = await installTestApplicationContainer(
      customHeader: const {'Authorization': 'Bearer abc'},
    );
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const CustomCachedNetworkImage(link: '/foto.png'),
      settle: false,
    );

    final image = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );
    expect(image.imageUrl, 'http://localhost/foto.png');
    expect(image.httpHeaders, const {'Authorization': 'Bearer abc'});
  });

  testWidgets('modo anônimo dispensa header e usa differentBaseUrl',
      (tester) async {
    final scope = await installTestApplicationContainer();
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const CustomCachedNetworkImage(
        link: '/foto.png',
        isAnonymous: true,
        differentBaseUrl: 'https://cdn.lello.com',
      ),
      settle: false,
    );

    final image = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );
    expect(image.imageUrl, 'https://cdn.lello.com/foto.png');
    expect(image.httpHeaders, isNull);
  });

  testWidgets('differentBaseUrl remove o header customizado', (tester) async {
    final scope = await installTestApplicationContainer(
      customHeader: const {'Authorization': 'Bearer abc'},
    );
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const CustomCachedNetworkImage(
        link: '/foto.png',
        differentBaseUrl: 'https://cdn.lello.com',
      ),
      settle: false,
    );

    // Sem header e sem `isAnonymous`, o widget volta para o svg de erro.
    expect(find.byType(CachedNetworkImage), findsNothing);
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('renderiza placeholder e errorWidget do CachedNetworkImage',
      (tester) async {
    final scope = await installTestApplicationContainer(
      customHeader: const {'Authorization': 'Bearer abc'},
    );
    addTearDown(scope.dispose);

    await pumpApp(
      tester,
      const CustomCachedNetworkImage(link: '/foto.png'),
      settle: false,
    );

    final image = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );
    final context = tester.element(find.byType(CachedNetworkImage));

    expect(
      image.placeholder!(context, image.imageUrl),
      isA<Center>(),
    );
    expect(
      image.errorWidget!(context, image.imageUrl, Exception('falhou')),
      isA<SvgPicture>(),
    );
  });
}
