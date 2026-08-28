// Fakes de plugins usados pelos testes de `lib/ui/widget/` (in_app_review e
// image_cropper). Instalados em `*Platform.instance` até o fim do teste.
import 'package:flutter_test/flutter_test.dart';
import 'package:image_cropper_platform_interface/image_cropper_platform_interface.dart';
import 'package:in_app_review_platform_interface/in_app_review_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// in_app_review falso: controla [available], registra chamadas e pode
/// lançar [isAvailableError] em `isAvailable`.
class FakeInAppReviewPlatform extends InAppReviewPlatform
    with MockPlatformInterfaceMixin {
  FakeInAppReviewPlatform({this.available = true});

  bool available;
  Object? isAvailableError;
  int isAvailableCalls = 0;
  int requestReviewCalls = 0;
  int openStoreCalls = 0;

  @override
  Future<bool> isAvailable() async {
    isAvailableCalls++;
    if (isAvailableError != null) throw isAvailableError!;
    return available;
  }

  @override
  Future<void> requestReview() async {
    requestReviewCalls++;
  }

  @override
  Future<void> openStoreListing({
    String? appStoreId,
    String? microsoftStoreId,
  }) async {
    openStoreCalls++;
  }
}

FakeInAppReviewPlatform installFakeInAppReview({bool available = true}) {
  final previous = InAppReviewPlatform.instance;
  final fake = FakeInAppReviewPlatform(available: available);
  InAppReviewPlatform.instance = fake;
  addTearDown(() => InAppReviewPlatform.instance = previous);
  return fake;
}

/// Parâmetros recebidos numa chamada de `cropImage`.
class CropCall {
  CropCall({
    required this.sourcePath,
    this.maxWidth,
    this.maxHeight,
    this.aspectRatio,
    required this.compressFormat,
    required this.compressQuality,
    this.uiSettings,
  });

  final String sourcePath;
  final int? maxWidth;
  final int? maxHeight;
  final CropAspectRatio? aspectRatio;
  final ImageCompressFormat compressFormat;
  final int compressQuality;
  final List<PlatformUiSettings>? uiSettings;

  AndroidUiSettings get android =>
      uiSettings!.whereType<AndroidUiSettings>().single;

  IOSUiSettings get ios => uiSettings!.whereType<IOSUiSettings>().single;
}

/// image_cropper falso: registra as chamadas em [calls] e devolve [result].
class FakeImageCropperPlatform extends ImageCropperPlatform
    with MockPlatformInterfaceMixin {
  final calls = <CropCall>[];
  CroppedFile? result;
  int recoverCalls = 0;

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
    calls.add(CropCall(
      sourcePath: sourcePath,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      aspectRatio: aspectRatio,
      compressFormat: compressFormat,
      compressQuality: compressQuality,
      uiSettings: uiSettings,
    ));
    return result;
  }

  @override
  Future<CroppedFile?> recoverImage() async {
    recoverCalls++;
    return result;
  }
}

FakeImageCropperPlatform installFakeImageCropper({CroppedFile? result}) {
  final previous = ImageCropperPlatform.instance;
  final fake = FakeImageCropperPlatform()..result = result;
  ImageCropperPlatform.instance = fake;
  addTearDown(() => ImageCropperPlatform.instance = previous);
  return fake;
}
