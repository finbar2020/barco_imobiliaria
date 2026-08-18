// Modelos de dados que espelham o JSON gerado por tool/analyze_projects.dart.
//
// Toda a UI consome estes modelos. Se algum campo mudar no scanner, ajustar
// aqui e nos widgets que o utilizam.

class AnalysisReport {
  AnalysisReport({
    required this.generatedAt,
    required this.rootPath,
    required this.workBranches,
    required this.projects,
  });

  final DateTime generatedAt;
  final String rootPath;
  final List<WorkBranchSummary> workBranches;
  final List<ProjectAnalysis> projects;

  factory AnalysisReport.fromJson(Map<String, dynamic> json) {
    return AnalysisReport(
      generatedAt: DateTime.tryParse(json['generatedAt'] as String? ?? '') ??
          DateTime.now(),
      rootPath: json['rootPath'] as String? ?? '',
      workBranches: (json['workBranches'] as List<dynamic>? ?? [])
          .map((e) => WorkBranchSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      projects: (json['projects'] as List<dynamic>? ?? [])
          .map((e) => ProjectAnalysis.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WorkBranchSummary {
  WorkBranchSummary({
    required this.name,
    required this.purpose,
    required this.presentIn,
    required this.currentOn,
  });

  final String name;
  final String purpose;
  final List<String> presentIn;
  final List<String> currentOn;

  factory WorkBranchSummary.fromJson(Map<String, dynamic> json) =>
      WorkBranchSummary(
        name: json['name'] as String? ?? '',
        purpose: json['purpose'] as String? ?? '',
        presentIn: (json['presentIn'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList(),
        currentOn: (json['currentOn'] as List<dynamic>? ?? [])
            .map((e) => e.toString())
            .toList(),
      );
}

class GitInfo {
  GitInfo({
    required this.currentBranch,
    required this.workBranches,
  });

  final String currentBranch;
  final List<WorkBranchPresence> workBranches;

  bool get hasCurrent => currentBranch.isNotEmpty;

  factory GitInfo.fromJson(Map<String, dynamic> json) => GitInfo(
        currentBranch: json['currentBranch'] as String? ?? '',
        workBranches: (json['workBranches'] as List<dynamic>? ?? [])
            .map((e) => WorkBranchPresence.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class WorkBranchPresence {
  WorkBranchPresence({
    required this.name,
    required this.purpose,
    required this.present,
    required this.current,
  });

  final String name;
  final String purpose;
  final bool present;
  final bool current;

  factory WorkBranchPresence.fromJson(Map<String, dynamic> json) =>
      WorkBranchPresence(
        name: json['name'] as String? ?? '',
        purpose: json['purpose'] as String? ?? '',
        present: json['present'] as bool? ?? false,
        current: json['current'] as bool? ?? false,
      );
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
    required this.git,
    required this.toolchain,
    required this.coverage,
    required this.packageUpdates,
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
  final GitInfo git;
  final ToolchainInfo toolchain;
  final CoverageInfo coverage;
  final PackageUpdatesInfo packageUpdates;
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
      git: GitInfo.fromJson((json['git'] as Map<String, dynamic>?) ?? const {}),
      toolchain: ToolchainInfo.fromJson(
          (json['toolchain'] as Map<String, dynamic>?) ?? const {}),
      coverage: CoverageInfo.fromJson(
          (json['coverage'] as Map<String, dynamic>?) ?? const {}),
      packageUpdates: PackageUpdatesInfo.fromJson(
          (json['packageUpdates'] as Map<String, dynamic>?) ?? const {}),
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

class ToolchainInfo {
  ToolchainInfo({
    required this.fvmFlutter,
    required this.dartSdkConstraint,
    required this.flutterSdkConstraint,
    required this.lockDartSdk,
    required this.lockFlutterSdk,
  });

  /// Versão pinada no `.fvmrc` — a que o time atualizou/usa no projeto.
  final String fvmFlutter;
  final String dartSdkConstraint;
  final String flutterSdkConstraint;
  final String lockDartSdk;
  final String lockFlutterSdk;

  bool get hasFvm => fvmFlutter.isNotEmpty;

  factory ToolchainInfo.fromJson(Map<String, dynamic> json) => ToolchainInfo(
        fvmFlutter: json['fvmFlutter'] as String? ?? '',
        dartSdkConstraint: json['dartSdkConstraint'] as String? ?? '',
        flutterSdkConstraint: json['flutterSdkConstraint'] as String? ?? '',
        lockDartSdk: json['lockDartSdk'] as String? ?? '',
        lockFlutterSdk: json['lockFlutterSdk'] as String? ?? '',
      );
}

class CoverageInfo {
  CoverageInfo({
    required this.available,
    required this.hit,
    required this.found,
    required this.percent,
    required this.testFiles,
    required this.goldenImages,
  });

  final bool available;
  final int hit;
  final int found;
  final double percent;
  final int testFiles;
  final int goldenImages;

  factory CoverageInfo.fromJson(Map<String, dynamic> json) => CoverageInfo(
        available: json['available'] as bool? ?? false,
        hit: (json['hit'] as num? ?? 0).toInt(),
        found: (json['found'] as num? ?? 0).toInt(),
        percent: (json['percent'] as num? ?? 0).toDouble(),
        testFiles: (json['testFiles'] as num? ?? 0).toInt(),
        goldenImages: (json['goldenImages'] as num? ?? 0).toInt(),
      );
}

class PackageUpdatesInfo {
  PackageUpdatesInfo({
    required this.scanned,
    required this.skipped,
    required this.error,
    required this.direct,
    required this.dev,
    required this.upToDate,
    required this.outdated,
    required this.discontinued,
    required this.majorAvailable,
    required this.upgradable,
    required this.percentUpToDate,
    required this.packages,
  });

  final bool scanned;
  final bool skipped;
  final String error;
  final int direct;
  final int dev;
  final int upToDate;
  final int outdated;
  final int discontinued;
  final int majorAvailable;
  final int upgradable;
  final double percentUpToDate;
  final List<OutdatedPackage> packages;

  factory PackageUpdatesInfo.fromJson(Map<String, dynamic> json) =>
      PackageUpdatesInfo(
        scanned: json['scanned'] as bool? ?? false,
        skipped: json['skipped'] as bool? ?? false,
        error: json['error'] as String? ?? '',
        direct: (json['direct'] as num? ?? 0).toInt(),
        dev: (json['dev'] as num? ?? 0).toInt(),
        upToDate: (json['upToDate'] as num? ?? 0).toInt(),
        outdated: (json['outdated'] as num? ?? 0).toInt(),
        discontinued: (json['discontinued'] as num? ?? 0).toInt(),
        majorAvailable: (json['majorAvailable'] as num? ?? 0).toInt(),
        upgradable: (json['upgradable'] as num? ?? 0).toInt(),
        percentUpToDate: (json['percentUpToDate'] as num? ?? 0).toDouble(),
        packages: (json['packages'] as List<dynamic>? ?? [])
            .map((e) => OutdatedPackage.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class OutdatedPackage {
  OutdatedPackage({
    required this.name,
    required this.kind,
    required this.current,
    required this.upgradable,
    required this.resolvable,
    required this.latest,
    required this.isDiscontinued,
    required this.isMajor,
    required this.constraint,
  });

  final String name;
  final String kind;
  final String current;
  final String upgradable;
  final String resolvable;
  final String latest;
  final bool isDiscontinued;
  final bool isMajor;
  final String constraint;

  factory OutdatedPackage.fromJson(Map<String, dynamic> json) =>
      OutdatedPackage(
        name: json['name'] as String? ?? '',
        kind: json['kind'] as String? ?? '',
        current: json['current'] as String? ?? '',
        upgradable: json['upgradable'] as String? ?? '',
        resolvable: json['resolvable'] as String? ?? '',
        latest: json['latest'] as String? ?? '',
        isDiscontinued: json['isDiscontinued'] as bool? ?? false,
        isMajor: json['isMajor'] as bool? ?? false,
        constraint: json['constraint'] as String? ?? '',
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
      stateNoSuffix + eventNoSuffix + idleInitialStates + outcomeEnumStates;

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

  /// Feature alinhada ao padrão do Síndico (abstract+impl é o padrão, não defeito).
  bool get isClean =>
      inlineEvents == 0 && inlineStates == 0 && filesWithPrint == 0;

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
