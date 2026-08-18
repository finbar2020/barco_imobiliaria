import 'dart:io';

/// Remove do lcov arquivos gerados, entrypoints e integrações não unit-testáveis.
///
/// Uso: dart run tool/filter_lcov.dart [entrada] [saida]
/// Padrão: coverage/lcov.info -> coverage/lcov.filtered.info
void main(List<String> args) {
  final input = args.isNotEmpty ? args[0] : 'coverage/lcov.info';
  final output = args.length > 1 ? args[1] : 'coverage/lcov.filtered.info';

  final raw = File(input);
  if (!raw.existsSync()) {
    stderr.writeln('Arquivo não encontrado: $input');
    exit(1);
  }

  final filtered = _filter(raw.readAsStringSync());
  File(output).writeAsStringSync(filtered);

  final before = _stats(raw.readAsStringSync());
  final after = _stats(filtered);
  stdout.writeln(
    'Filtrado: ${after.percent.toStringAsFixed(1)}% (${after.hit}/${after.lines}) '
    '— antes ${before.percent.toStringAsFixed(1)}% (${before.hit}/${before.lines})',
  );
  stdout.writeln('Saída: $output');
}

bool _exclude(String path) {
  final p = path.replaceAll('\\', '/');
  const patterns = [
    '.g.dart',
    '.chopper.dart',
    '/application_container.dart',
    '/main-',
    '/lello_app.dart',
    '/face_detector_page.dart',
    '/message_handler.dart',
    '/ghost_notification_usecase_impl.dart',
    '/uploader_impl.dart',
    '/home_app_bar_widget.dart',
    '/digital_point_bloc.dart',
    '/me_bloc.dart',
    '/session_bloc.dart',
    '/sync_digital_points_worker.dart',
  ];
  return patterns.any(p.contains);
}

String _filter(String raw) {
  final out = StringBuffer();
  final blocks = raw.split('end_of_record');
  for (final block in blocks) {
    final trimmed = block.trim();
    if (trimmed.isEmpty) continue;
    final pathLine = trimmed
        .split(RegExp(r'\r?\n'))
        .firstWhere((l) => l.startsWith('SF:'), orElse: () => '');
    if (pathLine.isEmpty) continue;
    final path = pathLine.substring(3).trim();
    if (_exclude(path)) continue;
    out.writeln(trimmed);
    out.writeln('end_of_record');
  }
  return out.toString();
}

({int lines, int hit, double percent}) _stats(String raw) {
  var lines = 0, hit = 0;
  for (final line in raw.split(RegExp(r'\r?\n'))) {
    if (line.startsWith('LF:')) lines += int.parse(line.substring(3));
    if (line.startsWith('LH:')) hit += int.parse(line.substring(3));
  }
  return (
    lines: lines,
    hit: hit,
    percent: lines == 0 ? 0 : hit * 100 / lines,
  );
}
