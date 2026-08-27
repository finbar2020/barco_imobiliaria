import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/page_harness.dart';

void main() {
  late PageHarness harness;

  setUp(() async {
    harness = await installPageHarness();
  });

  void authenticated() {
    final bloc = harness.resolve<AuthenticationBloc>();
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    bloc.emit(AuthenticatedState(accessToken: AccessToken()..accessToken = 'jwt'));
  }

  testWidgets('sem link mostra o placeholder', (tester) async {
    authenticated();
    await pumpPage(
      tester,
      const Scaffold(body: CustomCachedNetworkImage(link: '')),
      settle: false,
    );

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNothing);
  });

  testWidgets('sem sessão autenticada mostra o placeholder customizado',
      (tester) async {
    await pumpPage(
      tester,
      const Scaffold(
        body: CustomCachedNetworkImage(
          link: '/foto.png',
          errorImageAssetsPath: 'assets/logo.svg',
        ),
      ),
      settle: false,
    );

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNothing);
  });

  testWidgets('com sessão usa a base url do app e o header de autorização',
      (tester) async {
    authenticated();
    await pumpPage(
      tester,
      const Scaffold(body: CustomCachedNetworkImage(link: '/foto.png')),
      settle: false,
    );

    final image = tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
    expect(image.imageUrl, 'http://localhost/foto.png');
    expect(image.httpHeaders, {'Authorization': 'Bearer jwt'});
  });

  testWidgets('outra base url carrega a imagem sem o header de autorização',
      (tester) async {
    authenticated();
    await pumpPage(
      tester,
      const Scaffold(
        body: CustomCachedNetworkImage(
          link: '/foto.png',
          differentBaseUrl: 'https://cdn.example',
        ),
      ),
      settle: false,
    );

    // Corrigido: com `differentBaseUrl` o header é zerado mas a imagem é
    // carregada mesmo assim, usando a outra base url e sem `Authorization`.
    final image = tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
    expect(image.imageUrl, 'https://cdn.example/foto.png');
    expect(image.httpHeaders, isNull);
  });
}
