import 'dart:io';

/// Gera um relatório HTML a partir de coverage/lcov.info (Windows-friendly).
void main(List<String> args) {
  final lcovPath = args.isNotEmpty ? args[0] : 'coverage/lcov.info';
  final outDir = args.length > 1 ? args[1] : 'coverage/html';

  final lcov = File(lcovPath);
  if (!lcov.existsSync()) {
    stderr.writeln('Arquivo não encontrado: $lcovPath');
    stderr.writeln('Rode antes: flutter test --coverage');
    exit(1);
  }

  final files = _parseLcov(lcov.readAsStringSync());
  files.sort((a, b) => a.percent.compareTo(b.percent));

  final out = Directory(outDir);
  if (out.existsSync()) {
    out.deleteSync(recursive: true);
  }
  out.createSync(recursive: true);

  File('$outDir/index.html').writeAsStringSync(_indexHtml(files));
  for (final file in files) {
    final name = file.safeName;
    File('$outDir/$name.html').writeAsStringSync(_fileHtml(file));
  }

  final total = files.fold<int>(0, (p, f) => p + f.lines);
  final hit = files.fold<int>(0, (p, f) => p + f.hits);
  final pct = total == 0 ? 0.0 : hit * 100 / total;
  stdout.writeln(
    'HTML gerado em $outDir/index.html  (${pct.toStringAsFixed(1)}% — $hit/$total linhas)',
  );
}

class _FileCov {
  _FileCov(this.path);
  final String path;
  final Map<int, int> lineHits = {};

  int get lines => lineHits.length;
  int get hits => lineHits.values.where((h) => h > 0).length;
  double get percent => lines == 0 ? 0 : hits * 100 / lines;
  String get safeName =>
      path.replaceAll('\\', '_').replaceAll('/', '_').replaceAll(':', '_');
}

List<_FileCov> _parseLcov(String raw) {
  final files = <_FileCov>[];
  _FileCov? current;
  for (final line in raw.split(RegExp(r'\r?\n'))) {
    if (line.startsWith('SF:')) {
      current = _FileCov(line.substring(3).trim());
    } else if (line.startsWith('DA:') && current != null) {
      final parts = line.substring(3).split(',');
      current.lineHits[int.parse(parts[0])] = int.parse(parts[1]);
    } else if (line == 'end_of_record' && current != null) {
      files.add(current);
      current = null;
    }
  }
  return files;
}

String _bar(double pct) {
  final color = pct >= 80
      ? '#16a34a'
      : pct >= 50
          ? '#ca8a04'
          : '#dc2626';
  return '<div class="bar"><span style="width:${pct.toStringAsFixed(1)}%;background:$color"></span></div>';
}

String _indexHtml(List<_FileCov> files) {
  final total = files.fold<int>(0, (p, f) => p + f.lines);
  final hit = files.fold<int>(0, (p, f) => p + f.hits);
  final pct = total == 0 ? 0.0 : hit * 100 / total;
  final rows = files.reversed
      .map((f) => '''
      <tr>
        <td><a href="${f.safeName}.html">${_esc(f.path)}</a></td>
        <td>${f.hits}/${f.lines}</td>
        <td>${f.percent.toStringAsFixed(1)}%</td>
        <td>${_bar(f.percent)}</td>
      </tr>''')
      .join();

  return '''<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<title>Cobertura — app-lello-sindico</title>
<style>
  body { font-family: Segoe UI, sans-serif; margin: 24px; color: #111; }
  h1 { font-size: 22px; }
  .summary { font-size: 18px; margin: 12px 0 24px; }
  table { border-collapse: collapse; width: 100%; }
  th, td { text-align: left; padding: 8px 10px; border-bottom: 1px solid #e5e7eb; }
  th { background: #f3f4f6; }
  a { color: #1d4ed8; text-decoration: none; }
  .bar { background: #e5e7eb; height: 10px; border-radius: 6px; overflow: hidden; min-width: 120px; }
  .bar span { display: block; height: 100%; }
</style>
</head>
<body>
  <h1>Cobertura — app-lello-sindico</h1>
  <p class="summary">Total: <b>${pct.toStringAsFixed(1)}%</b> ($hit / $total linhas)</p>
  <table>
    <thead><tr><th>Arquivo</th><th>Linhas</th><th>%</th><th></th></tr></thead>
    <tbody>$rows</tbody>
  </table>
</body>
</html>''';
}

String _fileHtml(_FileCov file) {
  final src = File(file.path);
  final lines = src.existsSync() ? src.readAsLinesSync() : <String>[];
  final buf = StringBuffer();
  for (var i = 0; i < lines.length; i++) {
    final n = i + 1;
    final covered = file.lineHits[n];
    final cls = covered == null
        ? ''
        : covered > 0
            ? 'hit'
            : 'miss';
    buf.writeln(
      '<tr class="$cls"><td class="ln">$n</td><td><pre>${_esc(lines[i])}</pre></td></tr>',
    );
  }

  return '''<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<title>${_esc(file.path)}</title>
<style>
  body { font-family: Segoe UI, sans-serif; margin: 16px; }
  a { color: #1d4ed8; }
  table { border-collapse: collapse; width: 100%; font-size: 13px; }
  .ln { color: #6b7280; width: 48px; text-align: right; padding-right: 12px; }
  pre { margin: 0; font-family: Consolas, monospace; }
  tr.hit td { background: #dcfce7; }
  tr.miss td { background: #fee2e2; }
</style>
</head>
<body>
  <p><a href="index.html">← Voltar</a></p>
  <h2>${_esc(file.path)} — ${file.percent.toStringAsFixed(1)}%</h2>
  <table>${buf.toString()}</table>
</body>
</html>''';
}

String _esc(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');
