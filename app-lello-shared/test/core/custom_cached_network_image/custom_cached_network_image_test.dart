import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/test_container.dart';
import '../core_test_support.dart';

/// A `CustomCachedNetworkImage` só usa `getCustomHeader()` do store.
class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  _FakeAuthenticationStore({this.header});
  final Map<String, String>? header;

  @override
  Map<String, String>? getCustomHeader() => header;
}

const _placeholder = 'assets/custom_image_network_placeholder.svg';

void main() {
  late TestSharedContainer container;
  late FakeSvgAssetBundle bundle;

  setUp(() {
    container = TestSharedContainer(baseUrl: 'https://api.lello.com.br');
    bundle = FakeSvgAssetBundle();
  });

  Widget build({
    String? link,
    Map<String, String>? header,
    String? errorAsset,
    EdgeInsetsGeometry? padding,
    BoxFit? fit,
  }) {
    container.register<AuthenticationStore>(_FakeAuthenticationStore(header: header));
    return withFakeAssets(
      SizedBox(
        width: 100,
        height: 100,
        child: CustomCachedNetworkImage(
          link: link,
          applicationContainer: container,
          errorImageAssetsPath: errorAsset,
          padding: padding,
          fit: fit,
        ),
      ),
      bundle: bundle,
    );
  }

  testWidgets('sem link mostra o SVG padrão', (tester) async {
    await pumpApp(tester, build(link: null, header: const {'Authorization': 'x'}));
    expect(find.byType(CachedNetworkImage), findsNothing);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(bundle.loaded, [_placeholder]);
    await expectLater(findGoldenSurface(),
        matchesGoldenFile('goldens/custom_cached_network_image_placeholder.png'));
  });

  testWidgets('sem cabeçalho de autenticação mostra o SVG informado',
      (tester) async {
    await pumpApp(tester,
        build(link: '/img.png', header: null, errorAsset: 'assets/meu_erro.svg'));
    expect(find.byType(CachedNetworkImage), findsNothing);
    expect(bundle.loaded, ['assets/meu_erro.svg']);
  });

  testWidgets('com link e cabeçalho monta a imagem com a base url e o header',
      (tester) async {
    await pumpApp(
      tester,
      build(
        link: '/img.png',
        header: const {'Authorization': 'Bearer t'},
        fit: BoxFit.cover,
        padding: const EdgeInsets.all(2),
      ),
      settle: false,
    );
    final image =
        tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
    expect(image.imageUrl, 'https://api.lello.com.br/img.png');
    expect(image.httpHeaders, {'Authorization': 'Bearer t'});
    expect(image.fit, BoxFit.cover);

    // enquanto carrega, o placeholder com o padding informado
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final padding = tester.widget<Padding>(find.ancestor(
        of: find.byType(CircularProgressIndicator),
        matching: find.byType(Padding)).first);
    expect(padding.padding, const EdgeInsets.all(2));

    // o errorWidget cai no SVG padrão
    final context = tester.element(find.byType(CachedNetworkImage));
    final error = image.errorWidget!(context, 'url', Exception('x'));
    expect(error, isA<SvgPicture>());
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('placeholder usa o espaçamento padrão e errorWidget o asset informado',
      (tester) async {
    await pumpApp(
      tester,
      build(
        link: '/img.png',
        header: const {'Authorization': 'Bearer t'},
        errorAsset: 'assets/erro.svg',
      ),
      settle: false,
    );
    final image =
        tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
    final context = tester.element(find.byType(CachedNetworkImage));
    final placeholder = image.placeholder!(context, 'url');
    expect(placeholder, isA<Center>());
    final padding = tester.widget<Padding>(find.ancestor(
        of: find.byType(CircularProgressIndicator),
        matching: find.byType(Padding)).first);
    expect(padding.padding, EdgeInsets.all(Dimens.spacingSmall));
    expect(image.fit, isNull);

    await tester.pumpWidget(withFakeAssets(
      MaterialApp(home: image.errorWidget!(context, 'url', 'erro')),
      bundle: bundle,
    ));
    await tester.pump();
    expect(bundle.loaded, ['assets/erro.svg']);
    await tester.pumpWidget(const SizedBox());
  });
}
