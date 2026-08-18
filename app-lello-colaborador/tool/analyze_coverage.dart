import 'dart:io';

void main() {
  final lines = File('coverage/lcov.info').readAsLinesSync();
  String? current;
  int lf = 0, lh = 0;
  final files = <Map<String, dynamic>>[];

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      if (current != null) {
        files.add({'path': current, 'lf': lf, 'lh': lh});
      }
      current = line.substring(3).trim().replaceAll('\\', '/');
      lf = 0;
      lh = 0;
    } else if (line.startsWith('LF:')) {
      lf = int.parse(line.substring(3));
    } else if (line.startsWith('LH:')) {
      lh = int.parse(line.substring(3));
    }
  }
  if (current != null) files.add({'path': current, 'lf': lf, 'lh': lh});

  files.sort((a, b) {
    final missA = (a['lf'] as int) - (a['lh'] as int);
    final missB = (b['lf'] as int) - (b['lh'] as int);
    return missB.compareTo(missA);
  });

  bool shouldExclude(String p) {
    const patterns = [
      '.g.dart',
      '.chopper.dart',
      'application_container.dart',
      '/main-',
      'main.dart',
      'lello_app.dart',
      'face_detector_page.dart',
      'message_handler.dart',
      'ghost_notification_usecase_impl.dart',
      'uploader_impl.dart',
      'home_app_bar_widget.dart',
      'digital_point_bloc.dart',
      'me_bloc.dart',
      'session_bloc.dart',
      'sync_digital_points_worker.dart',
    ];
    return patterns.any(p.contains);
  }

  var totalLf = 0, totalLh = 0, exLf = 0, exLh = 0;
  for (final f in files) {
    final p = f['path'] as String;
    totalLf += f['lf'] as int;
    totalLh += f['lh'] as int;
    if (shouldExclude(p)) {
      exLf += f['lf'] as int;
      exLh += f['lh'] as int;
    }
  }

  final adjLf = totalLf - exLf;
  final adjLh = totalLh - exLh;
  stdout.writeln(
    'Total bruto: ${(100 * totalLh / totalLf).toStringAsFixed(1)}% ($totalLh/$totalLf)',
  );
  stdout.writeln(
    'Sem gerados/container/mains: ${(100 * adjLh / adjLf).toStringAsFixed(1)}% ($adjLh/$adjLf)',
  );
  stdout.writeln('Para 90% em escopo ajustado faltam: ${(0.9 * adjLf - adjLh).ceil()} linhas');
  stdout.writeln('\nTop 30 arquivos com mais linhas descobertas:');
  var shown = 0;
  for (final f in files) {
    final miss = (f['lf'] as int) - (f['lh'] as int);
    if (miss <= 0) continue;
    final p = f['path'] as String;
    if (shouldExclude(p)) continue;
    stdout.writeln('  $miss  $p');
    if (++shown >= 30) break;
  }
}
