import 'package:essentials/enum/app_origin_enum.dart';

class ComfortUtils {
  static String getCondoIdByProject(
      AppOriginEnum appOriginEnum, dynamic sessionBloc) {
    switch (appOriginEnum) {
      case AppOriginEnum.employee:
        return sessionBloc.state.session?.condominium?.id ?? "";
      case AppOriginEnum.owner:
        return sessionBloc.state.session?.condominium?.id ?? "";
      case AppOriginEnum.manager:
        return sessionBloc.state.session?.selectedCondominium?.id ?? "";
    }
  }
}
