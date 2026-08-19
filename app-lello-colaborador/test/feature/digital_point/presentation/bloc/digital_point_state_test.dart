import 'dart:async';

import 'package:colaborador/feature/digital_point/presentation/bloc/digital_point_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DigitalPointState', () {
    test('estados simples são iguais entre si', () {
      expect(const FaceInitialPictureState(), const FaceInitialPictureState());
      expect(const FaceLoadingPictureState(), const FaceLoadingPictureState());
      expect(
        const FaceRequestCanceledPictureState(),
        const FaceRequestCanceledPictureState(),
      );
      expect(
        const FaceRequestNoFacePictureState(),
        const FaceRequestNoFacePictureState(),
      );
      expect(
        const FaceRequestErrorPictureState(),
        const FaceRequestErrorPictureState(),
      );
      expect(
        const FaceRequestLoadedPictureState(),
        const FaceRequestLoadedPictureState(),
      );
    });

    test('estados diferentes não se confundem', () {
      expect(
        const FaceInitialPictureState() == const FaceLoadingPictureState(),
        isFalse,
      );
    });

    test('registro guarda se foi online ou offline', () {
      const online = FaceRegisterLoadedPictureState(isOnlineRegister: true);
      const offline = FaceRegisterLoadedPictureState(isOnlineRegister: false);

      expect(online.isOnlineRegister, isTrue);
      expect(online == offline, isFalse);
      expect(online, const FaceRegisterLoadedPictureState(isOnlineRegister: true));
    });

    test('afastamento carrega a mensagem do backend', () {
      const state = FaceRegisterAwayPictureState(message: 'afastado');

      expect(state.message, 'afastado');
      expect(
        state == const FaceRegisterAwayPictureState(message: 'outro'),
        isFalse,
      );
    });

    test('falhas carregam a exceção quando existe', () {
      final exception = TimeoutException('tempo esgotado');

      expect(FaceRegisterFailedPictureState(exception).ex, exception);
      expect(FaceRequestFailedPictureState(exception).ex, exception);
      expect(const FaceRegisterFailedPictureState().ex, isNull);
      expect(const FaceRequestFailedPictureState().ex, isNull);
    });

    test('timeout de localização carrega a exceção', () {
      final exception = TimeoutException('sem gps');

      final state = LocationTimeoutFailedPictureState(exception);

      expect(state.exception, exception);
      expect(state.props, [exception]);
    });
  });
}
