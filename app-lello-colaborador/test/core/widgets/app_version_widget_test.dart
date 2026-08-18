import 'package:colaborador/core/widgets/app_version_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';

import '../../helpers/pump_app.dart';

class _FakePackageInfo extends PackageInfoPlatform {
  @override
  Future<PackageInfoData> getAll({String? baseUrl}) async => PackageInfoData(
        appName: 'Colaborador',
        packageName: 'com.lello.colaborador',
        version: '2.5.0',
        buildNumber: '100',
        buildSignature: '',
      );
}

void main() {
  PackageInfoPlatform.instance = _FakePackageInfo();

  testWidgets('exibe versão após carregar package info', (tester) async {
    await pumpApp(
      tester,
      const AppVersionWidget(),
      localized: true,
      surface: const Size(200, 80),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('version'), findsOneWidget);
    expect(find.text('V2.5.0'), findsOneWidget);
  });
}
