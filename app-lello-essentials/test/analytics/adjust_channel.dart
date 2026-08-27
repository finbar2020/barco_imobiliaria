import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const adjustChannel = MethodChannel('com.adjust.sdk/api');

/// Grava as chamadas Dart → nativo feitas pelo SDK do Adjust
/// (`initSdk`, `trackEvent`, ...). Substitui o handler no-op instalado por
/// `setUpFakeFirebase`, então deve ser chamado depois dele.
class AdjustChannelRecorder {
  final calls = <MethodCall>[];

  List<String> get methods => calls.map((c) => c.method).toList();

  MethodCall? last(String method) {
    for (final call in calls.reversed) {
      if (call.method == method) return call;
    }
    return null;
  }

  void install() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(adjustChannel, (call) async {
      calls.add(call);
      return null;
    });
  }

  /// Simula uma chamada nativo → Dart (callbacks de atribuição, sessão,
  /// evento e deeplink que o SDK registra com `setMethodCallHandler`).
  Future<void> emitFromNative(String method, Object? arguments) async {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    await messenger.handlePlatformMessage(
      adjustChannel.name,
      adjustChannel.codec.encodeMethodCall(MethodCall(method, arguments)),
      (_) {},
    );
  }
}

AdjustChannelRecorder installAdjustRecorder() {
  final recorder = AdjustChannelRecorder()..install();
  addTearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(adjustChannel, (_) async => null);
  });
  return recorder;
}
