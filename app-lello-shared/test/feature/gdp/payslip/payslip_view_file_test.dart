import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_features/feature/gdp/payslip/domain/entity/payslipFile.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/bloc/selection/payslip_selection_state.dart';
import 'package:shared_features/feature/gdp/payslip/presentation/page/payslip_selection_page.dart';

import 'payslip_test_helpers.dart';

class _TempPathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  _TempPathProvider(this.dir);
  final Directory dir;
  @override
  Future<String?> getApplicationDocumentsPath() async => dir.path;
}

void main() {
  late Directory dir;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('payslip');
    PathProviderPlatform.instance = _TempPathProvider(dir);
  });

  tearDown(() => dir.deleteSync(recursive: true));

  test('viewFile grava o pdf decodificado na pasta de documentos', () async {
    final state = PayslipFileDownloadedState(
        const [], 'M1', PayslipFile(name: 'holerite.pdf', data: pdfBase64));

    final file = await viewFile(state);

    expect(file.path, '${dir.path}/holerite.pdf');
    expect(file.existsSync(), isTrue);
    expect(utf8.decode(file.readAsBytesSync()), '%PDF-1.4');
  });

  test('viewFile sem dados grava um arquivo vazio', () async {
    final state = PayslipFileDownloadedState(
        const [], 'M1', PayslipFile(name: 'vazio.pdf'));
    final file = await viewFile(state);
    expect(file.lengthSync(), 0);
  });
}
