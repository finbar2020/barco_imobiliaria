import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_state.dart';
import 'package:colaborador/feature/me/presentation/widgets/me_page/me_profile_picture_widget.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeMeBloc extends Fake implements MeBloc {
  bool tookPhoto = false;
  bool pickedImage = false;

  @override
  MeState get state => MeLoadedState(testMe());

  @override
  Stream<MeState> get stream => Stream.value(state);

  @override
  void beginTakePhoto() => tookPhoto = true;

  @override
  void beginPickImage() => pickedImage = true;
}

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  @override
  Map<String, String>? getCustomHeader() => null;
}

class _FakeSessionBloc extends Fake implements SessionBloc {
  @override
  String getBaseUrl() => 'http://localhost';
}

Future<void> _installContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(_FakeSessionBloc());
  locator.registerSingleton<AuthenticationStore>(_FakeAuthenticationStore());
}

Future<_FakeMeBloc> _pumpPicture(WidgetTester tester) async {
  final bloc = _FakeMeBloc();
  await pumpApp(
    tester,
    MeProfilePictureWidget(meBloc: bloc),
    localized: true,
    shrinkWrap: false,
    surface: const Size(400, 400),
  );
  return bloc;
}

void main() {
  setUp(_installContainer);
  tearDown(resetTestApplicationContainer);

  group('MeProfilePictureWidget', () {
    testWidgets('mostra a foto do colaborador com o atalho de edição',
        (tester) async {
      await _pumpPicture(tester);

      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(ClipRRect), findsWidgets);
    });

    testWidgets('tocar na foto abre as opções de origem', (tester) async {
      await _pumpPicture(tester);

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('camera'), findsOneWidget);
      expect(find.text('gallery'), findsOneWidget);
    });

    testWidgets('escolher câmera aciona a captura e fecha as opções',
        (tester) async {
      final bloc = await _pumpPicture(tester);

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      await tester.tap(find.text('camera'));
      await tester.pumpAndSettle();

      expect(bloc.tookPhoto, isTrue);
      expect(find.text('camera'), findsNothing);
    });

    testWidgets('escolher galeria aciona a seleção e fecha as opções',
        (tester) async {
      final bloc = await _pumpPicture(tester);

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      await tester.tap(find.text('gallery'));
      await tester.pumpAndSettle();

      expect(bloc.pickedImage, isTrue);
      expect(find.text('gallery'), findsNothing);
    });
  });
}
