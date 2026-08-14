import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/configs/flavor_config.dart';

class ClientFlavorHeaderResolver {
  static const String _morar = 'MORAR';
  static const String _viver = 'VIVER';
  static const String _hubert = 'HUBERT';

  static const String _appSindico = 'APPSINDICO';
  static const String _appSindicoViver = 'APPSINDICO_VIVER';
  static const String _appSindicoHubert = 'APPSINDICO_HUBERT';
  static const String _appDprep = 'APPDPREP';

  static String resolve({
    required AppOriginEnum appOrigin,
    required String packageName,
  }) {
    final isViver = _isViverPackage(packageName: packageName);

    if (appOrigin == AppOriginEnum.owner) {
      if (!isViver) return _morar;
      return FlavorConfig.isHubert ? _hubert : _viver;
    }

    if (appOrigin == AppOriginEnum.manager) {
      if (!isViver) return _appSindico;
      return FlavorConfig.isHubert ? _appSindicoHubert : _appSindicoViver;
    }

    if (appOrigin == AppOriginEnum.employee) {
      return _appDprep;
    }

    return _morar;
  }

  static String resolveCompanyId() {
    return FlavorConfig.config.idEmpresa.toString();
  }

  static bool _isViverPackage({required String packageName}) {
    final normalized = packageName.toLowerCase();
    return normalized.contains('viver');
  }
}
