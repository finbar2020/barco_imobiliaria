import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';

import '../../../../helpers/pump_app.dart';

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
  setUp(() {
    PackageInfoPlatform.instance = _FakePackageInfo();
  });

  testWidgets('ErrorHandlingWidget exibe erro de comprovante', (tester) async {
    await pumpApp(
      tester,
      ErrorHandlingWidget(
        errorCode: '500',
        error: 'proof_page_error_message',
        reTryFunction: () {},
        backFunction: () {},
        isProduction: false,
      ),
      localized: true,
      shrinkWrap: false,
      settle: false,
      surface: const Size(400, 480),
    );
    await tester.pump();
    for (var i = 0; i < 20; i++) {
      if (find.text('2.5.0').evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(find.text('proof_page_error_message'), findsOneWidget);
    expect(find.text('500'), findsOneWidget);
    expect(find.text('error_handling_widget_button_back'), findsOneWidget);
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
  });
}
