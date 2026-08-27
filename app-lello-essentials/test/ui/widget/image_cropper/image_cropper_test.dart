import 'package:essentials/ui/colors/light_pallete.dart';
import 'package:essentials/ui/widget/image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';

import '../fake_plugins.dart';

void main() {
  late FakeImageCropperPlatform cropper;

  setUp(() {
    cropper = installFakeImageCropper(result: CroppedFile('/tmp/recortada.jpg'));
  });

  /// Todas as funções usam a mesma configuração de Android/iOS; só a cor da
  /// toolbar varia.
  void expectConfiguracao(CropCall call, {Color? toolbar}) {
    expect(call.uiSettings, hasLength(2));
    final android = call.android;
    expect(android.toolbarColor, toolbar ?? LightPallete().primary());
    expect(android.toolbarWidgetColor, Colors.white);
    expect(android.hideBottomControls, isTrue);
    expect(android.initAspectRatio, CropAspectRatioPreset.original);
    expect(android.lockAspectRatio, isFalse);

    final ios = call.ios;
    expect(ios.minimumAspectRatio, 1.0);
    expect(ios.aspectRatioLockEnabled, isTrue);
    expect(ios.aspectRatioLockDimensionSwapEnabled, isFalse);
    expect(ios.aspectRatioPresets, [CropAspectRatioPreset.original]);

    expect(call.aspectRatio, isNull);
    expect(call.compressFormat, ImageCompressFormat.jpg);
    expect(call.compressQuality, 90);
  }

  group('showGeneralImageCropper', () {
    test('sem context usa a cor primária da paleta clara', () async {
      final resultado = await showGeneralImageCropper(
        '/fotos/a.jpg',
        maxHeight: 600,
        maxWidth: 800,
      );

      expect(resultado?.path, '/tmp/recortada.jpg');
      final call = cropper.calls.single;
      expect(call.sourcePath, '/fotos/a.jpg');
      expect(call.maxHeight, 600);
      expect(call.maxWidth, 800);
      expectConfiguracao(call);
    });

    test('parâmetros de proporção e estilo são aceitos sem alterar a chamada',
        () async {
      cropper.result = null;
      final resultado = await showGeneralImageCropper(
        '/fotos/b.png',
        aspectRatioPresets: const [CropAspectRatioPreset.ratio16x9],
        cropStyle: CropStyle.circle,
      );

      expect(resultado, isNull);
      final call = cropper.calls.single;
      expect(call.maxHeight, isNull);
      expect(call.maxWidth, isNull);
      expectConfiguracao(call);
    });

    testWidgets('com context usa a primaryColor do tema', (tester) async {
      late BuildContext contexto;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.purple),
          home: Builder(
            builder: (c) {
              contexto = c;
              return const SizedBox();
            },
          ),
        ),
      );

      final resultado = await showGeneralImageCropper(
        '/fotos/c.jpg',
        context: contexto,
      );

      expect(resultado?.path, '/tmp/recortada.jpg');
      expectConfiguracao(cropper.calls.single, toolbar: Colors.purple);
    });
  });

  test('showImageCropper repassa caminho e limites', () async {
    final resultado =
        await showImageCropper('/fotos/d.jpg', maxHeight: 100, maxWidth: 200);

    expect(resultado?.path, '/tmp/recortada.jpg');
    final call = cropper.calls.single;
    expect(call.sourcePath, '/fotos/d.jpg');
    expect(call.maxHeight, 100);
    expect(call.maxWidth, 200);
    expectConfiguracao(call);
  });

  test('showReceiptCropper repassa caminho e limites', () async {
    cropper.result = null;
    final resultado = await showReceiptCropper('/fotos/recibo.jpg');

    expect(resultado, isNull);
    final call = cropper.calls.single;
    expect(call.sourcePath, '/fotos/recibo.jpg');
    expect(call.maxHeight, isNull);
    expect(call.maxWidth, isNull);
    expectConfiguracao(call);
  });

  test('showProfileImageCropper repassa caminho e limites', () async {
    final resultado = await showProfileImageCropper(
      '/fotos/perfil.jpg',
      maxHeight: 512,
      maxWidth: 512,
    );

    expect(resultado?.path, '/tmp/recortada.jpg');
    final call = cropper.calls.single;
    expect(call.sourcePath, '/fotos/perfil.jpg');
    expect(call.maxHeight, 512);
    expect(call.maxWidth, 512);
    expectConfiguracao(call);
  });

  test('erro do plugin é propagado', () async {
    ImageCropperPlatform.instance = _CropperQueFalha();
    await expectLater(
      showImageCropper('/fotos/x.jpg'),
      throwsA(isA<StateError>()),
    );
  });
}

class _CropperQueFalha extends FakeImageCropperPlatform {
  @override
  Future<CroppedFile?> cropImage({
    required String sourcePath,
    int? maxWidth,
    int? maxHeight,
    CropAspectRatio? aspectRatio,
    ImageCompressFormat compressFormat = ImageCompressFormat.jpg,
    int compressQuality = 90,
    List<PlatformUiSettings>? uiSettings,
  }) async {
    throw StateError('cropper indisponível');
  }
}
