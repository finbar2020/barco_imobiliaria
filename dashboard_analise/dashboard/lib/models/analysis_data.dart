// Modelos de dados que espelham o JSON gerado por tool/analyze_projects.dart.
//
// Toda a UI consome estes modelos. Se algum campo mudar no scanner, ajustar
// aqui e nos widgets que o utilizam.

class AnalysisReport {
  AnalysisReport({
    required this.generatedAt,
    required this.rootPath,
    required this.projects,
  });

  final DateTime generatedAt;
  final String rootPath;
  final List<ProjectAnalysis> projects;

  factory AnalysisReport.fromJson(Map<String, dynamic> json) {
    return AnalysisReport(
      generatedAt: DateTime.tryParse(json['generatedAt'] as String? ?? '') ??
          DateTime.now(),
      rootPath: json['rootPath'] as String? ?? '',
      projects: (json['projects'] as List<dynamic>? ?? [])
          .map((e) => ProjectAnalysis.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProjectAnalysis {
  ProjectAnalysis({
    required this.name,
    required this.folderName,
    required this.description,
    required this.version,
    required this.type,
    required this.path,
    required this.platforms,
    required this.dependencies,
    required this.devDependencies,
    required this.dependencyOverrides,
    required this.dependencyCategories,
    required this.architecture,
    required this.stateManagement,
    required this.stats,
    required this.features,
    required this.blocMetrics,
  });

  final String name;
  final String folderName;
  final String description;
  final String version;
  final String type; // app | package | library
  final String path;
  final List<String> platforms;
  final List<Dependency> dependencies;
  final List<Dependency> devDependencies;
  final List<Dependency> dependencyOverrides;
  final Map<String, List<String>> dependencyCategories;
  final ArchitectureInfo architecture;
  final StateManagementInfo stateManagement;
  final CodeStats stats;
  final List<FeatureInfo> features;
  final BlocMetrics blocMetrics;

  factory ProjectAnalysis.fromJson(Map<String, dynamic> json) {
    return ProjectAnalysis(
      name: json['name'] as String? ?? '',
      folderName: json['folderName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      version: json['version'] as String? ?? '',
      type: json['type'] as String? ?? 'library',
      path: json['path'] as String? ?? '',
      platforms: (json['platforms'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      dependencies: (json['dependencies'] as List<dynamic>? ?? [])
          .map((e) => Dependency.fromJson(e as Map<String, dynamic>))
          .toList(),
      devDependencies: (json['devDependencies'] as List<dynamic>? ?? [])
          .map((e) => Dependency.fromJson(e as Map<String, dynamic>))
          .toList(),
      dependencyOverrides: (json['dependencyOverrides'] as List<dynamic>? ?? [])
          .map((e) => Dependency.fromJson(e as Map<String, dynamic>))
          .toList(),
      dependencyCategories:
          (json['dependencyCategories'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(
          k,
          (v as List<dynamic>).map((e) => e.toString()).toList(),
        ),
      ),
      architecture: ArchitectureInfo.fromJson(
          (json['architecture'] as Map<String, dynamic>?) ?? const {}),
      stateManagement: StateManagementInfo.fromJson(
          (json['stateManagement'] as Map<String, dynamic>?) ?? const {}),
      stats: CodeStats.fromJson(
          (json['stats'] as Map<String, dynamic>?) ?? const {}),
      features: (json['features'] as List<dynamic>? ?? [])
          .map((e) => FeatureInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      blocMetrics: BlocMetrics.fromJson(
          (json['blocMetrics'] as Map<String, dynamic>?) ?? const {}),
    );
  }

  bool get isApp => type == 'app';
  bool get isPackage => type == 'package' || type == 'library';

  int get totalDependencies => dependencies.length;

  Iterable<Dependency> get pathDependencies =>
      dependencies.where((d) => d.isPathDependency);
}

class Dependency {
  Dependency({
    required this.name,
    required this.version,
    required this.isPathDependency,
    required this.isGit,
    this.path,
  });

  final String name;
  final String version;
  final bool isPathDependency;
  final bool isGit;
  final String? path;

  factory Dependency.fromJson(Map<String, dynamic> json) => Dependency(
        name: json['name'] as String? ?? '',
        version: json['version'] as String? ?? '',
        isPathDependency: json['isPathDependency'] as bool? ?? false,
        isGit: json['isGit'] as bool? ?? false,
        path: json['path'] as String?,
      );
}

class ArchitectureInfo {
  ArchitectureInfo({
    required this.pattern,
    required this.hasFeatureFolder,
    required this.hasCoreFolder,
    required this.hasSharedFolder,
    required this.featureCount,
    required this.cleanFeatures,
    required this.cleanCoverage,
    required this.topLevelFolders,
    required this.topLevelFiles,
    required this.layerFirstFolders,
    required this.presentationSubUsage,
  });

  final String pattern;
  final bool hasFeatureFolder;
  final bool hasCoreFolder;
  final bool hasSharedFolder;
  final int featureCount;
  final int cleanFeatures;
  final int cleanCoverage;
  final Map<String, int> topLevelFolders;
  final List<String> topLevelFiles;
  final List<String> layerFirstFolders;
  final Map<String, int> presentationSubUsage;

  factory ArchitectureInfo.fromJson(Map<String, dynamic> json) {
    return ArchitectureInfo(
      pattern: json['pattern'] as String? ?? 'Indefinido',
      hasFeatureFolder: json['hasFeatureFolder'] as bool? ?? false,
      hasCoreFolder: json['hasCoreFolder'] as bool? ?? false,
      hasSharedFolder: json['hasSharedFolder'] as bool? ?? false,
      featureCount: json['featureCount'] as int? ?? 0,
      cleanFeatures: json['cleanFeatures'] as int? ?? 0,
      cleanCoverage: json['cleanCoverage'] as int? ?? 0,
      topLevelFolders:
          (json['topLevelFolders'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(k, (v as num).toInt()),
      ),
      topLevelFiles: (json['topLevelFiles'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      layerFirstFolders: (json['layerFirstFolders'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      presentationSubUsage:
          (json['presentationSubUsage'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(k, (v as num).toInt()),
      ),
    );
  }
}

class StateManagementInfo {
  StateManagementInfo({
    required this.primary,
    required this.detectedByPubspec,
    required this.packages,
    required this.resolvedPackages,
    required this.counts,
    required this.scores,
  });

  final String primary;
  final List<String> detectedByPubspec;
  final Map<String, List<String>> packages;
  final Map<String, ResolvedPackage> resolvedPackages;
  final Map<String, int> counts;
  final Map<String, int> scores;

  factory StateManagementInfo.fromJson(Map<String, dynamic> json) {
    return StateManagementInfo(
      primary: json['primary'] as String? ?? 'Nenhum detectado',
      detectedByPubspec: (json['detectedByPubspec'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      packages: (json['packages'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(
          k,
          (v as List<dynamic>).map((e) => e.toString()).toList(),
        ),
      ),
      resolvedPackages:
          (json['resolvedPackages'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(
          k,
          ResolvedPackage.fromJson(k, (v as Map<String, dynamic>?) ?? {}),
        ),
      ),
      counts: (json['counts'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(k, (v as num).toInt()),
      ),
      scores: (json['scores'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(k, (v as num).toInt()),
      ),
    );
  }

  /// Retorna as versões resolvidas para a família de pacotes informada.
  List<ResolvedPackage> resolvedForFamily(Iterable<String> names) {
    return names
        .map((n) => resolvedPackages[n])
        .whereType<ResolvedPackage>()
        .toList();
  }
}

class ResolvedPackage {
  ResolvedPackage({
    required this.name,
    required this.version,
    required this.dependencyType,
  });

  final String name;
  final String version;

  /// Valores comuns: `direct main`, `direct dev`, `direct overridden`,
  /// `transitive`. Vem do pubspec.lock.
  final String dependencyType;

  bool get isDirect => dependencyType.startsWith('direct');
  bool get isTransitive => dependencyType == 'transitive';

  String get originLabel {
    switch (dependencyType) {
      case 'direct main':
        return 'direta';
      case 'direct dev':
        return 'direta (dev)';
      case 'direct overridden':
        return 'override';
      case 'transitive':
        return 'transitiva';
      default:
        return dependencyType.isEmpty ? '' : dependencyType;
    }
  }

  factory ResolvedPackage.fromJson(String name, Map<String, dynamic> json) {
    return ResolvedPackage(
      name: name,
      version: json['version'] as String? ?? '',
      dependencyType: json['dependency'] as String? ?? '',
    );
  }
}

class CodeStats {
  CodeStats({
    required this.dartFiles,
    required this.totalLines,
    required this.codeLines,
    required this.generatedFiles,
    required this.testFiles,
  });

  final int dartFiles;
  final int totalLines;
  final int codeLines;
  final int generatedFiles;
  final int testFiles;

  factory CodeStats.fromJson(Map<String, dynamic> json) => CodeStats(
        dartFiles: (json['dartFiles'] as num? ?? 0).toInt(),
        totalLines: (json['totalLines'] as num? ?? 0).toInt(),
        codeLines: (json['codeLines'] as num? ?? 0).toInt(),
        generatedFiles: (json['generatedFiles'] as num? ?? 0).toInt(),
        testFiles: (json['testFiles'] as num? ?? 0).toInt(),
      );
}

class FeatureInfo {
  FeatureInfo({
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

  factory FeatureInfo.fromJson(Map<String, dynamic> json) => FeatureInfo(
        name: json['name'] as String? ?? '',
        hasData: json['hasData'] as bool? ?? false,
        hasDomain: json['hasDomain'] as bool? ?? false,
        hasPresentation: json['hasPresentation'] as bool? ?? false,
        fileCount: (json['fileCount'] as num? ?? 0).toInt(),
        lineCount: (json['lineCount'] as num? ?? 0).toInt(),
        presentationSubfolders:
            (json['presentationSubfolders'] as List<dynamic>? ?? [])
                .map((e) => e.toString())
                .toList(),
      );

  int get cleanScore =>
      (hasData ? 1 : 0) + (hasDomain ? 1 : 0) + (hasPresentation ? 1 : 0);
}

// ---------------------------------------------------------------------------
// Bloc / Cubit metrics
// ---------------------------------------------------------------------------

/// Métricas de higiene e padronização de blocos/cubits para um projeto.
class BlocMetrics {
  BlocMetrics({
    required this.perFeature,
    required this.totals,
  });

  final List<FeatureBlocMetrics> perFeature;
  final BlocTotals totals;

  bool get isEmpty => perFeature.isEmpty;
  bool get hasBlocs => (totals.blocs + totals.cubits) > 0;

  factory BlocMetrics.fromJson(Map<String, dynamic> json) {
    return BlocMetrics(
      perFeature: (json['perFeature'] as List<dynamic>? ?? [])
          .map((e) => FeatureBlocMetrics.fromJson(e as Map<String, dynamic>))
          .toList(),
      totals: BlocTotals.fromJson(
          (json['totals'] as Map<String, dynamic>?) ?? const {}),
    );
  }
}

class BlocTotals {
  BlocTotals({
    required this.features,
    required this.blocs,
    required this.cubits,
    required this.loc,
    required this.absImplPairs,
    required this.filesNoEquatable,
    required this.inlineEvents,
    required this.inlineStates,
    required this.filesWithPrint,
    required this.filesWithMapEventToState,
    required this.grade,
    required this.standardization,
  });

  final int features;
  final int blocs;
  final int cubits;
  final int loc;
  final int absImplPairs;
  final int filesNoEquatable;
  final int inlineEvents;
  final int inlineStates;
  final int filesWithPrint;
  final int filesWithMapEventToState;

  /// Média ponderada de higiene (0-100) por unidades bloc+cubit.
  final int grade;
  final StandardizationMetrics standardization;

  int get totalUnits => blocs + cubits;

  factory BlocTotals.fromJson(Map<String, dynamic> json) => BlocTotals(
        features: (json['features'] as num? ?? 0).toInt(),
        blocs: (json['blocs'] as num? ?? 0).toInt(),
        cubits: (json['cubits'] as num? ?? 0).toInt(),
        loc: (json['loc'] as num? ?? 0).toInt(),
        absImplPairs: (json['absImplPairs'] as num? ?? 0).toInt(),
        filesNoEquatable: (json['filesNoEquatable'] as num? ?? 0).toInt(),
        inlineEvents: (json['inlineEvents'] as num? ?? 0).toInt(),
        inlineStates: (json['inlineStates'] as num? ?? 0).toInt(),
        filesWithPrint: (json['filesWithPrint'] as num? ?? 0).toInt(),
        filesWithMapEventToState:
            (json['filesWithMapEventToState'] as num? ?? 0).toInt(),
        grade: (json['grade'] as num? ?? 100).toInt(),
        standardization: StandardizationMetrics.fromJson(
            (json['standardization'] as Map<String, dynamic>?) ?? const {}),
      );
}

/// Métricas de aderência ao padrão canônico de blocs/cubits (padronização),
/// separadas da higiene técnica. Espelha o bloco `standardization` do JSON.
class StandardizationMetrics {
  StandardizationMetrics({
    required this.stateClasses,
    required this.eventClasses,
    required this.stateNoSuffix,
    required this.eventNoSuffix,
    required this.idleInitialStates,
    required this.singleClassStates,
    required this.dedicatedErrorStates,
    required this.nonConstBaseStates,
    required this.outcomeEnumStates,
    required this.grade,
  });

  final int stateClasses;
  final int eventClasses;
  final int stateNoSuffix;
  final int eventNoSuffix;
  final int idleInitialStates;
  final int singleClassStates;
  final int dedicatedErrorStates;
  final int nonConstBaseStates;
  final int outcomeEnumStates;

  /// Nota 0-100 de aderência ao padrão — quanto maior, menos desvios.
  final int grade;

  int get totalDeviations =>
      stateNoSuffix +
      eventNoSuffix +
      idleInitialStates +
      singleClassStates +
      nonConstBaseStates +
      outcomeEnumStates;

  bool get isStandardized => totalDeviations == 0;

  factory StandardizationMetrics.fromJson(Map<String, dynamic> json) =>
      StandardizationMetrics(
        stateClasses: (json['stateClasses'] as num? ?? 0).toInt(),
        eventClasses: (json['eventClasses'] as num? ?? 0).toInt(),
        stateNoSuffix: (json['stateNoSuffix'] as num? ?? 0).toInt(),
        eventNoSuffix: (json['eventNoSuffix'] as num? ?? 0).toInt(),
        idleInitialStates: (json['idleInitialStates'] as num? ?? 0).toInt(),
        singleClassStates: (json['singleClassStates'] as num? ?? 0).toInt(),
        dedicatedErrorStates:
            (json['dedicatedErrorStates'] as num? ?? 0).toInt(),
        nonConstBaseStates: (json['nonConstBaseStates'] as num? ?? 0).toInt(),
        outcomeEnumStates: (json['outcomeEnumStates'] as num? ?? 0).toInt(),
        grade: (json['grade'] as num? ?? 100).toInt(),
      );
}

class FeatureBlocMetrics {
  FeatureBlocMetrics({
    required this.name,
    required this.blocs,
    required this.cubits,
    required this.loc,
    required this.absImplPairs,
    required this.filesNoEquatable,
    required this.inlineEvents,
    required this.inlineStates,
    required this.filesWithPrint,
    required this.filesWithMapEventToState,
    required this.grade,
    required this.standardization,
  });

  final String name;
  final int blocs;
  final int cubits;
  final int loc;
  final int absImplPairs;
  final int filesNoEquatable;
  final int inlineEvents;
  final int inlineStates;
  final int filesWithPrint;
  final int filesWithMapEventToState;

  /// Nota 0-100 de higiene técnica — quanto maior, menos fricção detectada.
  final int grade;

  /// Métricas e nota de aderência ao padrão canônico (padronização).
  final StandardizationMetrics standardization;

  int get totalUnits => blocs + cubits;

  /// Retorna true se a feature está em bom estado geral.
  bool get isClean =>
      inlineEvents == 0 &&
      inlineStates == 0 &&
      filesWithPrint == 0 &&
      filesWithMapEventToState == 0 &&
      absImplPairs == 0;

  factory FeatureBlocMetrics.fromJson(Map<String, dynamic> json) =>
      FeatureBlocMetrics(
        name: json['name'] as String? ?? '',
        blocs: (json['blocs'] as num? ?? 0).toInt(),
        cubits: (json['cubits'] as num? ?? 0).toInt(),
        loc: (json['loc'] as num? ?? 0).toInt(),
        absImplPairs: (json['absImplPairs'] as num? ?? 0).toInt(),
        filesNoEquatable: (json['filesNoEquatable'] as num? ?? 0).toInt(),
        inlineEvents: (json['inlineEvents'] as num? ?? 0).toInt(),
        inlineStates: (json['inlineStates'] as num? ?? 0).toInt(),
        filesWithPrint: (json['filesWithPrint'] as num? ?? 0).toInt(),
        filesWithMapEventToState:
            (json['filesWithMapEventToState'] as num? ?? 0).toInt(),
        grade: (json['grade'] as num? ?? 100).toInt(),
        standardization: StandardizationMetrics.fromJson(
            (json['standardization'] as Map<String, dynamic>?) ?? const {}),
      );
}
