import 'dart:ui';

import 'package:cross_file/cross_file.dart';
import 'package:essentials/modal/share.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

class _FakeShare extends SharePlatform with MockPlatformInterfaceMixin {
  final params = <ShareParams>[];
  bool fail = false;

  @override
  Future<ShareResult> share(ShareParams p) async {
    if (fail) throw StateError('sem share');
    params.add(p);
    return const ShareResult('ok', ShareResultStatus.success);
  }
}

void main() {
  // `SharePlus.instance` é `static final` e captura o `SharePlatform.instance`
  // na primeira resolução: por isso o fake é único para o arquivo.
  final share = _FakeShare();

  setUpAll(() => SharePlatform.instance = share);

  setUp(() {
    share.params.clear();
    share.fail = false;
  });

  test('shareText envia o texto e a origem', () async {
    const rect = Rect.fromLTWH(1, 2, 3, 4);
    await shareText('olá', sharePositionOrigin: rect);
    expect(share.params.single.text, 'olá');
    expect(share.params.single.sharePositionOrigin, rect);
  });

  test('shareText engole erros do plugin', () async {
    share.fail = true;
    await shareText('olá');
    expect(share.params, isEmpty);
  });

  test('shareFile envia o arquivo', () async {
    final arquivo = XFile('/tmp/a.pdf');
    await shareFile(arquivo);
    expect(share.params.single.files, [arquivo]);
    expect(share.params.single.sharePositionOrigin, isNull);
  });

  test('shareFile engole erros do plugin', () async {
    share.fail = true;
    await shareFile(XFile('/tmp/a.pdf'));
    expect(share.params, isEmpty);
  });
}
