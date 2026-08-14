// ignore_for_file: avoid_print
//
// Scanner CLI que varre a pasta pai (app-lello-morar) e gera um relatório
// JSON em assets/analysis.json descrevendo cada projeto Flutter/Dart
// encontrado com foco em arquitetura e gerenciamento de estado.
//
// Uso:
//   dart run tool/analyze_projects.dart
//
// Opcionalmente pode-se passar um caminho customizado:
//   dart run tool/analyze_projects.dart "C:\\caminho\\alternativo"

import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';

// ============================================================================
// Entry point
// ============================================================================

Future<void> main(List<String> args) async {
  // Platform.script -> .../dashboard/tool/analyze_projects.dart
  final scriptFile = File.fromUri(Platform.script);
  final dashboardDir = scriptFile.parent.parent; // .../dashboard
  // Raiz padrão: .../app-lello-morar (dois níveis acima de dashboard)
  final defaultParent = dashboardDir.parent.parent.absolute.path;
  final rootPath = args.isNotEmpty ? args.first : defaultParent;
  final rootDir = Directory(rootPath);
  if (!rootDir.existsSync()) {
    stderr.writeln('Pasta raiz não encontrada: $rootPath');
    exit(1);
  }

  print('Analisando projetos em: ${rootDir.path}');
  final scanner = ProjectScanner(rootDir);
  final report = await scanner.run(excludeFolderName: 'dashboard_analise');

  final outFile = File(_join([dashboardDir.path, 'assets', 'analysis.json']));
  outFile.parent.createSync(recursive: true);
  outFile.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(report),
  );
  print('OK ${report['projects'].length} projetos analisados.');
  print('Relatório escrito em: ${outFile.path}');
}

String _join(List<String> parts) => parts.join(Platform.pathSeparator);

// ============================================================================
// Scanner
// ============================================================================

class ProjectScanner {
  ProjectScanner(this.rootDir);

  final Directory rootDir;

  Future<Map<String, dynamic>> run({String? excludeFolderName}) async {
    final projects = <Map<String, dynamic>>[];
    for (final entity in rootDir.listSync()) {
      if (entity is! Directory) continue;
      final name = _basename(entity.path);
      if (name.startsWith('.')) continue;
      if (excludeFolderName != null && name == excludeFolderName) continue;
      final pubspec = File(_join([entity.path, 'pubspec.yaml']));
      if (!pubspec.existsSync()) continue;
      print('  -> $name');
      try {
        final analysis = _analyzeProject(entity);
        projects.add(analysis);
      } catch (e, s) {
        stderr.writeln('Falha ao analisar $name: $e\n$s');
      }
    }

    projects.sort((a, b) =>
        (a['folderName'] as String).compareTo(b['folderName'] as String));

    return {
      'generatedAt': DateTime.now().toIso8601String(),
      'rootPath': rootDir.path,
      'projects': projects,
    };
  }

  Map<String, dynamic> _analyzeProject(Directory dir) {
    final folderName = _basename(dir.path);
    final pubspecFile = File(_join([dir.path, 'pubspec.yaml']));
    final pubspec = _parseYamlFile(pubspecFile);

    final projectName = (pubspec['name'] as String?) ?? folderName;
    final description = (pubspec['description'] as String?) ?? '';
    final version = (pubspec['version'] as String?) ?? '';

    final deps = _extractDeps(pubspec['dependencies']);
    final devDeps = _extractDeps(pubspec['dev_dependencies']);
    final overrides = _extractDeps(pubspec['dependency_overrides']);

    final libDir = Directory(_join([dir.path, 'lib']));
    final testDir = Directory(_join([dir.path, 'test']));

    final dartFiles = libDir.existsSync() ? _collectDartFiles(libDir) : <File>[];
    final testFiles =
        testDir.existsSync() ? _collectDartFiles(testDir) : <File>[];

    final stats = _computeStats(dartFiles, testFiles);
    final features = _analyzeFeatures(libDir);
    final architecture = _analyzeArchitecture(libDir, features);
    final resolved =
        _readResolvedPackages(File(_join([dir.path, 'pubspec.lock'])));
    final stateMgmt =
        _analyzeStateManagement(deps, devDeps, dartFiles, resolved);

    // Categorização temática dos pacotes
    final categorized = _categorizeDependencies(deps);

    // Métricas específicas de blocs/cubits (higiene e padronização)
    final blocMetrics = _analyzeBlocMetrics(libDir);

    // Detecção de tipo do projeto
    final isFlutterPackage = (pubspec['flutter'] != null &&
        libDir.existsSync() &&
        !File(_join([libDir.path, 'main.dart'])).existsSync());
    final hasMain = File(_join([libDir.path, 'main.dart'])).existsSync() ||
        _hasMainVariant(libDir);
    final projectType = hasMain
        ? 'app'
        : isFlutterPackage
            ? 'package'
            : 'library';

    final platforms = _detectPlatforms(dir);

    return {
      'name': projectName,
      'folderName': folderName,
      'description': description,
      'version': version,
      'type': projectType,
      'path': dir.path,
      'platforms': platforms,
      'dependencies': deps.map((d) => d.toJson()).toList(),
      'devDependencies': devDeps.map((d) => d.toJson()).toList(),
      'dependencyOverrides': overrides.map((d) => d.toJson()).toList(),
      'dependencyCategories': categorized,
      'architecture': architecture,
      'stateManagement': stateMgmt,
      'stats': stats,
      'features': features.map((f) => f.toJson()).toList(),
      'blocMetrics': blocMetrics,
    };
  }

  // -----------------------------------------------------------------
  // Bloc / Cubit metrics (higiene e padronização)
  // -----------------------------------------------------------------
  Map<String, dynamic> _analyzeBlocMetrics(Directory libDir) {
    if (!libDir.existsSync()) {
      return {'perFeature': const [], 'totals': _emptyBlocTotals()};
    }

    // Procura a pasta que agrupa features
    Directory? featureDir;
    for (final name in const ['feature', 'features', 'modules']) {
      final candidate = Directory(_join([libDir.path, name]));
      if (candidate.existsSync()) {
        featureDir = candidate;
        break;
      }
    }
    if (featureDir == null) {
      return {'perFeature': const [], 'totals': _emptyBlocTotals()};
    }

    final perFeature = <Map<String, dynamic>>[];
    for (final entity in featureDir.listSync()) {
      if (entity is! Directory) continue;
      final m = _computeFeatureBlocMetrics(entity);
      if (m != null) perFeature.add(m);
    }

    // Ordena por total de arquivos (blocs+cubits) desc para dar destaque
    perFeature.sort((a, b) {
      final ta = (a['blocs'] as int) + (a['cubits'] as int);
      final tb = (b['blocs'] as int) + (b['cubits'] as int);
      return tb.compareTo(ta);
    });

    final totals = <String, dynamic>{
      'features': perFeature.length,
      'blocs': _sumField(perFeature, 'blocs'),
      'cubits': _sumField(perFeature, 'cubits'),
      'loc': _sumField(perFeature, 'loc'),
      'absImplPairs': _sumField(perFeature, 'absImplPairs'),
      'filesNoEquatable': _sumField(perFeature, 'filesNoEquatable'),
      'inlineEvents': _sumField(perFeature, 'inlineEvents'),
      'inlineStates': _sumField(perFeature, 'inlineStates'),
      'filesWithPrint': _sumField(perFeature, 'filesWithPrint'),
      'filesWithMapEventToState':
          _sumField(perFeature, 'filesWithMapEventToState'),
      'grade': _weightedHygieneGrade(perFeature),
      'standardization': _sumStandardization(perFeature),
    };

    return {'perFeature': perFeature, 'totals': totals};
  }

  Map<String, dynamic> _emptyBlocTotals() => {
        'features': 0,
        'blocs': 0,
        'cubits': 0,
        'loc': 0,
        'absImplPairs': 0,
        'filesNoEquatable': 0,
        'inlineEvents': 0,
        'inlineStates': 0,
        'filesWithPrint': 0,
        'filesWithMapEventToState': 0,
        'grade': 100,
        'standardization': _emptyStandardization(),
      };

  Map<String, int> _emptyStandardization() => {
        'stateClasses': 0,
        'eventClasses': 0,
        'stateNoSuffix': 0,
        'eventNoSuffix': 0,
        'idleInitialStates': 0,
        'singleClassStates': 0,
        'dedicatedErrorStates': 0,
        'nonConstBaseStates': 0,
        'outcomeEnumStates': 0,
      };

  int _sumField(List<Map<String, dynamic>> list, String key) {
    return list.fold<int>(0, (acc, m) => acc + (m[key] as int));
  }

  /// Média ponderada da nota de higiene por unidades (blocs+cubits).
  int _weightedHygieneGrade(List<Map<String, dynamic>> list) {
    var weightedGrade = 0;
    var weight = 0;
    for (final m in list) {
      final units = (m['blocs'] as int) + (m['cubits'] as int);
      if (units <= 0) continue;
      weightedGrade += ((m['grade'] as num?)?.toInt() ?? 100) * units;
      weight += units;
    }
    return weight > 0 ? (weightedGrade / weight).round() : 100;
  }

  /// Soma o bloco aninhado `standardization` de cada feature e calcula a nota
  /// agregada como média ponderada pela quantidade de unidades (blocs+cubits).
  Map<String, int> _sumStandardization(List<Map<String, dynamic>> list) {
    final result = _emptyStandardization();
    var weightedGrade = 0;
    var weight = 0;
    for (final m in list) {
      final std = m['standardization'];
      if (std is Map) {
        for (final key in result.keys.toList()) {
          result[key] = result[key]! + ((std[key] as num?)?.toInt() ?? 0);
        }
        final units = (m['blocs'] as int) + (m['cubits'] as int);
        if (units > 0) {
          weightedGrade += ((std['grade'] as num?)?.toInt() ?? 100) * units;
          weight += units;
        }
      }
    }
    result['grade'] = weight > 0 ? (weightedGrade / weight).round() : 100;
    return result;
  }

  /// Analisa uma única feature (raiz da feature) recursivamente. Suporta
  /// features aninhadas (ex: `gdp/employee/presentation/bloc/`) e retorna
  /// `null` se nenhum arquivo relevante foi encontrado.
  Map<String, dynamic>? _computeFeatureBlocMetrics(Directory featureDir) {
    final all = _collectDartFiles(featureDir);
    final relevant = all.where((f) {
      final norm = f.path.replaceAll('\\', '/');
      if (!norm.contains('/presentation/')) return false;
      final n = _basename(f.path);
      // Arquivos claramente de bloc/cubit são sempre elegíveis.
      if (n.endsWith('_bloc.dart') ||
          n.endsWith('_bloc_impl.dart') ||
          n.endsWith('_cubit.dart') ||
          n.endsWith('_cubit_impl.dart')) {
        return true;
      }
      // _event.dart e _state.dart só contam quando estão dentro de uma pasta
      // /bloc/ ou /cubit/. Isso evita falsos positivos com widgets como
      // `xxx_empty_state.dart`.
      if (n.endsWith('_event.dart') || n.endsWith('_state.dart')) {
        return norm.contains('/bloc/') || norm.contains('/cubit/');
      }
      return false;
    }).toList();
    if (relevant.isEmpty) return null;

    final blocRegex = RegExp(r'extends\s+Bloc<');
    final cubitRegex = RegExp(r'extends\s+Cubit<');
    final classEventRegex = RegExp(r'class\s+\w+Event\b');
    final classStateRegex = RegExp(r'class\s+\w+State\b');
    final classEventOrStateRegex = RegExp(r'class\s+\w+(Event|State)\b');
    final equatableRegex = RegExp(r'extends\s+Equatable');
    final printRegex = RegExp(r'(^|\s)print\s*\(');
    final mapEventRegex = RegExp('mapEventToState');

    // Padronização (padrão canônico usado como referência:
    // maintenance_management): base abstrata `XxxState/Event extends Equatable`,
    // subclasses com sufixo State/Event, InitialState (não Idle), ErrorState
    // dedicado, construtor const e sem "estado único" estilo form-bloc.
    final subclassRegex = RegExp(r'class\s+(\w+)\s+extends\s+(\w+)');
    final abstractStateRegex = RegExp(r'abstract\s+class\s+(\w+State)\b');
    final abstractEventRegex = RegExp(r'abstract\s+class\s+(\w+Event)\b');
    final errorStateRegex = RegExp(r'class\s+(\w+ErrorState)\b');
    final concreteEquatableStateRegex =
        RegExp(r'class\s+(\w+State)\s+extends\s+Equatable\b');
    final outcomeEnumRegex = RegExp(r'enum\s+\w+Outcome\b');

    var blocs = 0;
    var cubits = 0;
    var loc = 0;
    var filesNoEq = 0;
    var inlineEv = 0;
    var inlineSt = 0;
    var filesWithPrint = 0;
    var filesWithMap = 0;

    // Contadores de padronização (aderência ao padrão canônico).
    var stateClasses = 0;
    var eventClasses = 0;
    var stateNoSuffix = 0;
    var eventNoSuffix = 0;
    var idleInitialStates = 0;
    var singleClassStates = 0;
    var dedicatedErrorStates = 0;
    var nonConstBaseStates = 0;
    var outcomeEnumStates = 0;

    // Conta pares abstract+impl (arquivo `foo.dart` + `foo_impl.dart` no
    // mesmo diretório).
    var absImplPairs = 0;
    for (final f in relevant) {
      final name = _basename(f.path);
      if (!name.endsWith('_impl.dart')) continue;
      final base = name.substring(0, name.length - '_impl.dart'.length);
      final sibling = File(_join([f.parent.path, '$base.dart']));
      if (sibling.existsSync()) absImplPairs++;
    }

    for (final f in relevant) {
      String content;
      try {
        content = f.readAsStringSync();
      } catch (_) {
        continue;
      }
      loc += content.split('\n').length;
      blocs += blocRegex.allMatches(content).length;
      cubits += cubitRegex.allMatches(content).length;

      final name = _basename(f.path);
      final isBlocSource =
          name.endsWith('_bloc.dart') || name.endsWith('_bloc_impl.dart');
      if (isBlocSource) {
        if (!content.contains('_event.dart') &&
            classEventRegex.hasMatch(content)) {
          inlineEv++;
        }
        if (!content.contains('_state.dart') &&
            classStateRegex.hasMatch(content)) {
          inlineSt++;
        }
      }
      if (classEventOrStateRegex.hasMatch(content) &&
          !equatableRegex.hasMatch(content)) {
        filesNoEq++;
      }
      if (printRegex.hasMatch(content)) filesWithPrint++;
      if (mapEventRegex.hasMatch(content)) filesWithMap++;

      // --- Métricas de padronização (aderência ao padrão canônico) ---
      final isStateFile = name.endsWith('_state.dart');
      final isEventFile = name.endsWith('_event.dart');

      // Subclasses concretas de bases *State / *Event e adesão ao sufixo.
      for (final m in subclassRegex.allMatches(content)) {
        final child = m.group(1)!;
        final parent = m.group(2)!;
        if (parent.endsWith('State')) {
          stateClasses++;
          if (!child.endsWith('State')) stateNoSuffix++;
          if (child.contains('Idle')) idleInitialStates++;
        } else if (parent.endsWith('Event')) {
          eventClasses++;
          if (!child.endsWith('Event')) eventNoSuffix++;
        }
      }

      dedicatedErrorStates += errorStateRegex.allMatches(content).length;
      outcomeEnumStates += outcomeEnumRegex.allMatches(content).length;

      // "Estado único" estilo form-bloc: classe concreta `XxxState extends
      // Equatable` sem uma base abstrata correspondente no arquivo (foge do
      // padrão de subclasses Initial/Loading/Loaded/Error).
      if (isStateFile &&
          concreteEquatableStateRegex.hasMatch(content) &&
          !abstractStateRegex.hasMatch(content)) {
        singleClassStates++;
      }

      // Base abstrata sem construtor const (fricção de padronização).
      if (isStateFile || isEventFile) {
        for (final b in abstractStateRegex.allMatches(content)) {
          final base = b.group(1)!;
          if (!content.contains('const $base(')) nonConstBaseStates++;
        }
        for (final b in abstractEventRegex.allMatches(content)) {
          final base = b.group(1)!;
          if (!content.contains('const $base(')) nonConstBaseStates++;
        }
      }
    }

    // Nota de padronização (0-100) baseada em problemas encontrados por bloc.
    // Menos problemas = nota maior.
    final totalBlocs = blocs + cubits;
    var grade = 100;
    if (totalBlocs > 0) {
      grade -= (filesWithMap * 25); // migração bloc 9 pendente
      grade -= (inlineEv * 6 + inlineSt * 6);
      grade -= (filesWithPrint * 4);
      // absImplPairs contam como fricção estrutural
      grade -= (absImplPairs * 3);
      // filesNoEquatable é ruidoso (herança pode mascarar) mas ainda pesa
      grade -= (filesNoEq * 1);
    }
    if (grade < 0) grade = 0;

    // Nota de PADRONIZAÇÃO (0-100), separada da higiene técnica acima.
    // Mede a aderência ao padrão canônico (base abstrata + subclasses com
    // sufixo State/Event, InitialState, ErrorState dedicado, const, sem
    // estado único de form-bloc). Pesos escolhidos para serem legíveis:
    // desvios mais estruturais penalizam mais.
    var stdGrade = 100;
    if (stateClasses + eventClasses > 0) {
      stdGrade -= stateNoSuffix * 4;
      stdGrade -= eventNoSuffix * 1;
      stdGrade -= idleInitialStates * 4;
      stdGrade -= singleClassStates * 5;
      stdGrade -= nonConstBaseStates * 3;
      stdGrade -= outcomeEnumStates * 5;
    }
    if (stdGrade < 0) stdGrade = 0;

    return {
      'name': _basename(featureDir.path),
      'blocs': blocs,
      'cubits': cubits,
      'loc': loc,
      'absImplPairs': absImplPairs,
      'filesNoEquatable': filesNoEq,
      'inlineEvents': inlineEv,
      'inlineStates': inlineSt,
      'filesWithPrint': filesWithPrint,
      'filesWithMapEventToState': filesWithMap,
      'grade': grade,
      'standardization': {
        'stateClasses': stateClasses,
        'eventClasses': eventClasses,
        'stateNoSuffix': stateNoSuffix,
        'eventNoSuffix': eventNoSuffix,
        'idleInitialStates': idleInitialStates,
        'singleClassStates': singleClassStates,
        'dedicatedErrorStates': dedicatedErrorStates,
        'nonConstBaseStates': nonConstBaseStates,
        'outcomeEnumStates': outcomeEnumStates,
        'grade': stdGrade,
      },
    };
  }

  // -----------------------------------------------------------------
  // Estatísticas de código
  // -----------------------------------------------------------------
  Map<String, dynamic> _computeStats(List<File> libFiles, List<File> testFiles) {
    var totalLines = 0;
    var codeLines = 0;
    var generated = 0;

    for (final f in libFiles) {
      final name = _basename(f.path);
      if (name.endsWith('.g.dart') ||
          name.endsWith('.freezed.dart') ||
          name.endsWith('.gr.dart') ||
          name.endsWith('.chopper.dart') ||
          name.endsWith('.config.dart')) {
        generated++;
      }
      try {
        final lines = f.readAsLinesSync();
        totalLines += lines.length;
        for (final l in lines) {
          final t = l.trim();
          if (t.isEmpty) continue;
          if (t.startsWith('//') || t.startsWith('/*') || t.startsWith('*')) {
            continue;
          }
          codeLines++;
        }
      } catch (_) {
        // arquivo binário ou sem permissão — ignora
      }
    }

    return {
      'dartFiles': libFiles.length,
      'totalLines': totalLines,
      'codeLines': codeLines,
      'generatedFiles': generated,
      'testFiles': testFiles.length,
    };
  }

  // -----------------------------------------------------------------
  // Features
  // -----------------------------------------------------------------
  List<_FeatureInfo> _analyzeFeatures(Directory libDir) {
    if (!libDir.existsSync()) return const [];
    final featureRoots = ['feature', 'features', 'modules', 'pages'];
    Directory? featureDir;
    for (final name in featureRoots) {
      final candidate = Directory(_join([libDir.path, name]));
      if (candidate.existsSync()) {
        featureDir = candidate;
        break;
      }
    }
    if (featureDir == null) return const [];

    final features = <_FeatureInfo>[];
    for (final entity in featureDir.listSync()) {
      if (entity is! Directory) continue;
      final name = _basename(entity.path);
      final hasData = Directory(_join([entity.path, 'data'])).existsSync();
      final hasDomain = Directory(_join([entity.path, 'domain'])).existsSync();
      final hasPresentation =
          Directory(_join([entity.path, 'presentation'])).existsSync();
      final files = _collectDartFiles(entity);
      var lines = 0;
      for (final f in files) {
        try {
          lines += f.readAsLinesSync().length;
        } catch (_) {}
      }
      features.add(_FeatureInfo(
        name: name,
        hasData: hasData,
        hasDomain: hasDomain,
        hasPresentation: hasPresentation,
        fileCount: files.length,
        lineCount: lines,
        presentationSubfolders:
            _presentationSubfolders(Directory(_join([entity.path, 'presentation']))),
      ));
    }
    features.sort((a, b) => b.fileCount.compareTo(a.fileCount));
    return features;
  }

  List<String> _presentationSubfolders(Directory presentation) {
    if (!presentation.existsSync()) return const [];
    return presentation
        .listSync()
        .whereType<Directory>()
        .map((d) => _basename(d.path))
        .toList()
      ..sort();
  }

  // -----------------------------------------------------------------
  // Arquitetura
  // -----------------------------------------------------------------
  Map<String, dynamic> _analyzeArchitecture(
    Directory libDir,
    List<_FeatureInfo> features,
  ) {
    final topLevelFolders = <String, int>{};
    final topLevelFiles = <String>[];
    if (libDir.existsSync()) {
      for (final entity in libDir.listSync()) {
        if (entity is Directory) {
          topLevelFolders[_basename(entity.path)] =
              _collectDartFiles(entity).length;
        } else if (entity is File && entity.path.endsWith('.dart')) {
          topLevelFiles.add(_basename(entity.path));
        }
      }
    }

    final hasFeatureFolder = topLevelFolders.keys.any(
      (k) => k == 'feature' || k == 'features' || k == 'modules',
    );
    final hasCoreFolder = topLevelFolders.containsKey('core');
    final hasSharedFolder = topLevelFolders.containsKey('shared');

    var cleanFeatureCount = 0;
    for (final f in features) {
      if (f.hasData && f.hasDomain && f.hasPresentation) cleanFeatureCount++;
    }

    // Padrões clássicos "layer-first" no topo do lib
    final layerFirstFolders = <String>[
      'screens',
      'widgets',
      'pages',
      'views',
      'models',
      'controllers',
      'services',
      'repositories',
    ];
    final layerFirstHits =
        layerFirstFolders.where(topLevelFolders.containsKey).toList();

    String pattern;
    if (hasFeatureFolder && features.isNotEmpty) {
      final coverage =
          features.isEmpty ? 0 : (cleanFeatureCount * 100) ~/ features.length;
      if (coverage >= 60) {
        pattern = 'Feature-first + Clean Architecture';
      } else {
        pattern = 'Feature-first';
      }
    } else if (layerFirstHits.length >= 3) {
      pattern = 'Layer-first';
    } else if (topLevelFolders.isEmpty && topLevelFiles.isNotEmpty) {
      pattern = 'Flat';
    } else {
      pattern = 'Misto/Indefinido';
    }

    // Cobertura da estrutura Clean nas features
    final cleanCoverage = features.isEmpty
        ? 0
        : ((cleanFeatureCount * 100) / features.length).round();

    // Uso dos subfolders de presentation agregados
    final presentationSubUsage = <String, int>{};
    for (final f in features) {
      for (final sub in f.presentationSubfolders) {
        presentationSubUsage[sub] = (presentationSubUsage[sub] ?? 0) + 1;
      }
    }

    return {
      'pattern': pattern,
      'hasFeatureFolder': hasFeatureFolder,
      'hasCoreFolder': hasCoreFolder,
      'hasSharedFolder': hasSharedFolder,
      'featureCount': features.length,
      'cleanFeatures': cleanFeatureCount,
      'cleanCoverage': cleanCoverage,
      'topLevelFolders': topLevelFolders,
      'topLevelFiles': topLevelFiles,
      'layerFirstFolders': layerFirstHits,
      'presentationSubUsage': presentationSubUsage,
    };
  }

  // -----------------------------------------------------------------
  // Gerenciamento de estado
  // -----------------------------------------------------------------
  /// Lê o pubspec.lock e devolve um mapa `pkgName -> { version, dependency }`
  /// para os pacotes de gerenciamento de estado e DI conhecidos.
  Map<String, Map<String, String>> _readResolvedPackages(File lockFile) {
    if (!lockFile.existsSync()) return const {};
    const interesting = {
      // BLoC family
      'bloc',
      'flutter_bloc',
      'hydrated_bloc',
      'replay_bloc',
      'bloc_test',
      // Provider
      'provider',
      // Riverpod
      'riverpod',
      'flutter_riverpod',
      'hooks_riverpod',
      'riverpod_annotation',
      // GetX
      'get',
      // MobX
      'mobx',
      'flutter_mobx',
      // Redux
      'redux',
      'flutter_redux',
      // Signals
      'signals',
      'signals_flutter',
      // DI (útil listar junto)
      'get_it',
      'injectable',
    };
    try {
      final yaml = loadYaml(lockFile.readAsStringSync());
      if (yaml is! Map) return const {};
      final packages = yaml['packages'];
      if (packages is! Map) return const {};
      final result = <String, Map<String, String>>{};
      packages.forEach((k, v) {
        final name = k.toString();
        if (!interesting.contains(name)) return;
        if (v is Map) {
          result[name] = {
            'version': (v['version'] ?? '').toString(),
            'dependency': (v['dependency'] ?? '').toString(),
          };
        }
      });
      return result;
    } catch (e) {
      stderr.writeln('Falha ao ler ${lockFile.path}: $e');
      return const {};
    }
  }

  Map<String, dynamic> _analyzeStateManagement(
    List<_Dep> deps,
    List<_Dep> devDeps,
    List<File> libFiles,
    Map<String, Map<String, String>> resolved,
  ) {
    final depNames = {
      for (final d in [...deps, ...devDeps]) d.name,
    };

    // Pacotes conhecidos por abordagem
    final approachPackages = <String, List<String>>{
      'BLoC': ['flutter_bloc', 'bloc', 'hydrated_bloc'],
      'Provider': ['provider'],
      'Riverpod': ['flutter_riverpod', 'riverpod', 'hooks_riverpod'],
      'GetX': ['get'],
      'MobX': ['mobx', 'flutter_mobx'],
      'Redux': ['redux', 'flutter_redux'],
      'GetIt/Injectable': ['get_it', 'injectable'],
    };

    final detectedByPubspec = <String>[];
    final packageMatches = <String, List<String>>{};
    approachPackages.forEach((approach, pkgs) {
      final hits = pkgs.where(depNames.contains).toList();
      if (hits.isNotEmpty) {
        detectedByPubspec.add(approach);
        packageMatches[approach] = hits;
      }
    });

    // Detecção por scan de código
    var blocCount = 0;
    var cubitCount = 0;
    var changeNotifierCount = 0;
    var providerConsumerCount = 0;
    var consumerWidgetCount = 0;
    var getxControllerCount = 0;
    var mobxStoreCount = 0;
    var setStateHits = 0;
    var streamBuilderCount = 0;

    final blocRegex =
        RegExp(r'class\s+\w+\s+extends\s+Bloc<', multiLine: true);
    final cubitRegex =
        RegExp(r'class\s+\w+\s+extends\s+Cubit<', multiLine: true);
    final changeNotifierRegex =
        RegExp(r'extends\s+ChangeNotifier', multiLine: true);
    final providerOfRegex =
        RegExp(r'Provider\.of<|Consumer<\w+>|context\.watch<|context\.read<');
    final consumerWidgetRegex =
        RegExp(r'extends\s+ConsumerWidget|WidgetRef\s+ref');
    final getxControllerRegex =
        RegExp(r'extends\s+GetxController|Get\.put\(|Get\.find\(');
    final mobxStoreRegex =
        RegExp(r'@observable|@computed|@action|Store\s+with\s+_\$');
    final setStateRegex = RegExp(r'\bsetState\s*\(');
    final streamBuilderRegex = RegExp(r'StreamBuilder<');

    for (final f in libFiles) {
      String content;
      try {
        content = f.readAsStringSync();
      } catch (_) {
        continue;
      }
      blocCount += blocRegex.allMatches(content).length;
      cubitCount += cubitRegex.allMatches(content).length;
      changeNotifierCount += changeNotifierRegex.allMatches(content).length;
      providerConsumerCount += providerOfRegex.allMatches(content).length;
      consumerWidgetCount += consumerWidgetRegex.allMatches(content).length;
      getxControllerCount += getxControllerRegex.allMatches(content).length;
      mobxStoreCount += mobxStoreRegex.allMatches(content).length;
      setStateHits += setStateRegex.allMatches(content).length;
      streamBuilderCount += streamBuilderRegex.allMatches(content).length;
    }

    // Score final por abordagem, com peso maior para uso real no código
    final scores = <String, int>{
      'BLoC': blocCount * 5 + cubitCount * 5,
      'Provider': changeNotifierCount * 3 + providerConsumerCount * 2,
      'Riverpod': consumerWidgetCount * 5,
      'GetX': getxControllerCount * 5,
      'MobX': mobxStoreCount * 5,
    };
    // Se está no pubspec mas não achou uso, ainda pontua fraco
    for (final approach in detectedByPubspec) {
      if (scores.containsKey(approach) && scores[approach] == 0) {
        scores[approach] = 1;
      }
    }
    // setState puro só é "primário" quando nada mais aparece
    final anyOther = scores.values.any((v) => v > 0);
    scores['setState (puro)'] = anyOther ? 0 : (setStateHits > 0 ? 1 : 0);

    scores.removeWhere((_, v) => v == 0);

    String primary;
    if (scores.isEmpty) {
      primary = 'Nenhum detectado';
    } else {
      final sorted = scores.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      primary = sorted.first.key;
    }

    return {
      'primary': primary,
      'detectedByPubspec': detectedByPubspec,
      'packages': packageMatches,
      'resolvedPackages': resolved,
      'counts': {
        'bloc': blocCount,
        'cubit': cubitCount,
        'changeNotifier': changeNotifierCount,
        'providerConsumer': providerConsumerCount,
        'consumerWidget': consumerWidgetCount,
        'getxController': getxControllerCount,
        'mobxStore': mobxStoreCount,
        'setState': setStateHits,
        'streamBuilder': streamBuilderCount,
      },
      'scores': scores,
    };
  }

  // -----------------------------------------------------------------
  // Dependency helpers
  // -----------------------------------------------------------------
  List<_Dep> _extractDeps(dynamic node) {
    if (node is! Map) return const [];
    final result = <_Dep>[];
    node.forEach((k, v) {
      if (k == 'flutter' || k == 'flutter_localizations') return;
      if (v is String) {
        result.add(_Dep(name: k.toString(), version: v));
      } else if (v is Map) {
        if (v['path'] != null) {
          result.add(_Dep(
            name: k.toString(),
            version: 'path:${v['path']}',
            isPathDependency: true,
            path: v['path'].toString(),
          ));
        } else if (v['git'] != null) {
          result.add(_Dep(name: k.toString(), version: 'git', isGit: true));
        } else if (v['sdk'] != null) {
          result.add(_Dep(name: k.toString(), version: 'sdk:${v['sdk']}'));
        } else if (v['version'] != null) {
          result.add(_Dep(name: k.toString(), version: v['version'].toString()));
        } else {
          result.add(_Dep(name: k.toString(), version: ''));
        }
      }
    });
    return result;
  }

  Map<String, List<String>> _categorizeDependencies(List<_Dep> deps) {
    final categories = <String, List<String>>{
      'Estado': [],
      'Injeção de dependência': [],
      'HTTP/API': [],
      'Banco/Storage local': [],
      'Firebase': [],
      'Roteamento': [],
      'UI/Widgets': [],
      'Utilidades': [],
      'Monitoramento': [],
    };
    final rules = <String, List<String>>{
      'Estado': [
        'flutter_bloc',
        'bloc',
        'hydrated_bloc',
        'provider',
        'riverpod',
        'flutter_riverpod',
        'hooks_riverpod',
        'mobx',
        'flutter_mobx',
        'get',
        'redux',
        'flutter_redux',
        'signals',
      ],
      'Injeção de dependência': ['get_it', 'injectable', 'kiwi'],
      'HTTP/API': [
        'dio',
        'http',
        'chopper',
        'retrofit',
        'graphql',
        'graphql_flutter',
        'web_socket_channel',
      ],
      'Banco/Storage local': [
        'drift',
        'drift_sqflite',
        'sqflite',
        'hive',
        'hive_flutter',
        'isar',
        'shared_preferences',
        'secure_storage',
        'flutter_secure_storage',
        'objectbox',
      ],
      'Firebase': [
        'firebase_analytics',
        'firebase_auth',
        'firebase_core',
        'firebase_crashlytics',
        'firebase_in_app_messaging',
        'firebase_messaging',
        'firebase_remote_config',
        'firebase_app_installations',
        'firebase_performance',
        'firebase_storage',
        'cloud_firestore',
      ],
      'Roteamento': ['go_router', 'auto_route', 'beamer', 'fluro'],
      'Monitoramento': [
        'datadog_flutter_plugin',
        'datadog_tracking_http_client',
        'sentry_flutter',
        'firebase_crashlytics',
      ],
    };

    for (final d in deps) {
      var placed = false;
      rules.forEach((cat, list) {
        if (list.contains(d.name)) {
          categories[cat]!.add(d.name);
          placed = true;
        }
      });
      if (!placed) {
        if (d.name.startsWith('flutter_') ||
            d.name.contains('widget') ||
            d.name.contains('ui') ||
            d.name.contains('chart') ||
            d.name.contains('picker') ||
            d.name.contains('image')) {
          categories['UI/Widgets']!.add(d.name);
        } else {
          categories['Utilidades']!.add(d.name);
        }
      }
    }
    categories.removeWhere((_, v) => v.isEmpty);
    for (final v in categories.values) {
      v.sort();
    }
    return categories;
  }

  // -----------------------------------------------------------------
  // Platforms
  // -----------------------------------------------------------------
  List<String> _detectPlatforms(Directory dir) {
    const platforms = ['android', 'ios', 'web', 'windows', 'macos', 'linux'];
    return platforms
        .where((p) => Directory(_join([dir.path, p])).existsSync())
        .toList();
  }

  bool _hasMainVariant(Directory libDir) {
    if (!libDir.existsSync()) return false;
    return libDir
        .listSync()
        .whereType<File>()
        .any((f) => RegExp(r'main[-_].*\.dart$').hasMatch(_basename(f.path)));
  }

  // -----------------------------------------------------------------
  // Helpers de FS
  // -----------------------------------------------------------------
  List<File> _collectDartFiles(Directory dir) {
    final files = <File>[];
    final skipDirs = {
      '.dart_tool',
      '.git',
      'build',
      'ios',
      'android',
      'macos',
      'windows',
      'linux',
      'web',
      'generated',
      'Pods',
    };

    void walk(Directory d, int depth) {
      if (depth > 12) return;
      List<FileSystemEntity> entries;
      try {
        entries = d.listSync(followLinks: false);
      } catch (_) {
        return;
      }
      for (final e in entries) {
        final name = _basename(e.path);
        if (e is Directory) {
          if (skipDirs.contains(name)) continue;
          if (name.startsWith('.')) continue;
          walk(e, depth + 1);
        } else if (e is File && name.endsWith('.dart')) {
          files.add(e);
        }
      }
    }

    walk(dir, 0);
    return files;
  }

  dynamic _parseYamlFile(File file) {
    try {
      final content = file.readAsStringSync();
      return loadYaml(content);
    } catch (e) {
      stderr.writeln('Falha ao ler ${file.path}: $e');
      return const {};
    }
  }

  String _basename(String path) {
    final norm = path.replaceAll('\\', '/');
    final idx = norm.lastIndexOf('/');
    return idx < 0 ? norm : norm.substring(idx + 1);
  }
}

// ============================================================================
// Models internos
// ============================================================================

class _Dep {
  _Dep({
    required this.name,
    required this.version,
    this.isPathDependency = false,
    this.isGit = false,
    this.path,
  });

  final String name;
  final String version;
  final bool isPathDependency;
  final bool isGit;
  final String? path;

  Map<String, dynamic> toJson() => {
        'name': name,
        'version': version,
        'isPathDependency': isPathDependency,
        'isGit': isGit,
        if (path != null) 'path': path,
      };
}

class _FeatureInfo {
  _FeatureInfo({
    required this.name,
    required this.hasData,
    required this.hasDomain,
    required this.hasPresentation,
    required this.fileCount,
    required this.lineCount,
    required this.presentationSubfolders,
  });

  final String name;
  final bool hasData;
  final bool hasDomain;
  final bool hasPresentation;
  final int fileCount;
  final int lineCount;
  final List<String> presentationSubfolders;

  Map<String, dynamic> toJson() => {
        'name': name,
        'hasData': hasData,
        'hasDomain': hasDomain,
        'hasPresentation': hasPresentation,
        'fileCount': fileCount,
        'lineCount': lineCount,
        'presentationSubfolders': presentationSubfolders,
      };
}
